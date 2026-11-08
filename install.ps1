# TFRKP Hong Nak - installer (run via install.bat)
# 이 파일이 있는 폴더(= 내려받아 압축을 푼 모드 폴더)를 HOI4 mod 폴더에 복사하고,
# 런처가 모드를 인식하도록 tfrkp_hongnak.mod 파일을 만들어 줍니다.
param([string]$DocsDir)
$ErrorActionPreference = 'Stop'

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$name = 'tfrkp_hongnak'
$docs = $DocsDir
if (-not $docs) { $docs = [Environment]::GetFolderPath('MyDocuments') }
if (-not $docs) { $docs = Join-Path $env:USERPROFILE 'Documents' }
$mod  = [IO.Path]::Combine($docs, 'Paradox Interactive', 'Hearts of Iron IV', 'mod')
$dst  = Join-Path $mod $name

Write-Host ''
Write-Host '=== TFRKP Hong Nak 설치 ===' -ForegroundColor Cyan
Write-Host "문서 폴더 : $docs"
Write-Host "mod 폴더  : $mod"

if (-not (Test-Path -LiteralPath (Join-Path $here 'descriptor.mod'))) {
    Write-Host ''
    Write-Host '[오류] 이 파일 옆에 descriptor.mod가 없습니다.' -ForegroundColor Red
    Write-Host '       압축을 푼 모드 폴더 안(common, events, interface 폴더가 보이는 곳)에서 실행하세요.'
    exit 1
}

# 1) 모드 폴더 복사
New-Item -ItemType Directory -Force -Path $dst | Out-Null
if ((Resolve-Path -LiteralPath $here).Path.TrimEnd('\','/') -ne (Resolve-Path -LiteralPath $dst).Path.TrimEnd('\','/')) {
    $skip = @('.git', '.github', 'install.bat', 'install.ps1')
    Get-ChildItem -LiteralPath $here -Force | Where-Object { $skip -notcontains $_.Name } |
        Copy-Item -Destination $dst -Recurse -Force
    Write-Host "복사 완료: $dst" -ForegroundColor Green
} else {
    Write-Host "이미 mod 폴더 안에 있어서 복사는 건너뜁니다: $dst"
}

# 2) 런처용 .mod 파일 만들기 (descriptor.mod 내용 + path)
$lines = Get-Content -LiteralPath (Join-Path $dst 'descriptor.mod') -Encoding UTF8 |
    Where-Object { $_ -notmatch '^\s*(path|archive)\s*=' }
$modPath = ($dst -replace '\\', '/')
$modFile = Join-Path $mod "$name.mod"
$out = @($lines) + ('path="' + $modPath + '"')
[IO.File]::WriteAllLines($modFile, [string[]]$out, (New-Object System.Text.UTF8Encoding($false)))
Write-Host "런처용 파일 생성: $modFile" -ForegroundColor Green

# 3) 필요한 모드가 설치돼 있는지 확인
$names = @{}
Get-ChildItem -LiteralPath $mod -Filter '*.mod' -ErrorAction SilentlyContinue | ForEach-Object {
    $m = Select-String -LiteralPath $_.FullName -Pattern '^name="(.*)"' | Select-Object -First 1
    if ($m) { $names[$m.Matches[0].Groups[1].Value] = 1 }
}
Write-Host ''
$need = @('The Fire Rises', 'The Fire Rises: Korea Plus')
$missing = @($need | Where-Object { -not $names.ContainsKey($_) })
if ($missing.Count -gt 0) {
    Write-Host '[주의] 아래 모드가 설치돼 있지 않거나 런처가 아직 읽지 않았습니다:' -ForegroundColor Yellow
    $missing | ForEach-Object { Write-Host "   - $_" -ForegroundColor Yellow }
    Write-Host '       Steam 창작마당에서 구독하고, 런처를 한 번 켠 뒤 이 설치를 다시 실행하세요.'
} else {
    Write-Host '필요한 모드(The Fire Rises, Korea Plus)가 확인되었습니다.' -ForegroundColor Green
}

Write-Host ''
Write-Host '다음 순서로 진행하세요.' -ForegroundColor Cyan
Write-Host ' 1. Paradox 런처를 완전히 끄고 다시 켭니다.'
Write-Host ' 2. 새 플레이세트를 만들고, 설치된 모드 목록에서 아래 순서로 추가합니다.'
Write-Host '      The Fire Rises  ->  The Fire Rises: Korea Plus  ->  TFRKP Hong Nak'
Write-Host ' 3. 한국어 패치 등 다른 모드는 TFRKP Hong Nak보다 위(먼저)에 둡니다.'
Write-Host ''
