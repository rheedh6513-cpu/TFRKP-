# TFRKP Hong Nak - 문제 진단과 자동 고침 (fix.bat으로 실행)
# 모드가 런처에 안 보이거나, 켜지지 않거나, 글자가 깨져 보일 때 씁니다.
# 고칠 수 있는 것은 바로 고치고, 결과를 바탕 화면의 tfrkp_hongnak_report.txt에 남깁니다.
param([string]$DocsDir)
$ErrorActionPreference = 'Continue'
$name = 'tfrkp_hongnak'
$rep  = New-Object System.Collections.Generic.List[string]
function Say([string]$t, [string]$c = 'Gray') { Write-Host $t -ForegroundColor $c; $script:rep.Add($t) }
function Ok([string]$t)   { Say "[정상] $t" 'Green' }
function Fix([string]$t)  { Say "[고침] $t" 'Cyan' }
function Warn([string]$t) { Say "[확인] $t" 'Yellow' }
function Bad([string]$t)  { Say "[문제] $t" 'Red' }

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$docs = $DocsDir
if (-not $docs) { $docs = [Environment]::GetFolderPath('MyDocuments') }
if (-not $docs) { $docs = Join-Path $env:USERPROFILE 'Documents' }
$hoi = [IO.Path]::Combine($docs, 'Paradox Interactive', 'Hearts of Iron IV')
$mod = Join-Path $hoi 'mod'
$dst = Join-Path $mod $name

Say ''
Say '=== TFRKP Hong Nak 문제 진단 ===' 'Cyan'
Say ("시각      : " + (Get-Date -Format 'yyyy-MM-dd HH:mm'))
Say "문서 폴더 : $docs"
Say "mod 폴더  : $mod"
Say ''

# 1) mod 폴더
if (-not (Test-Path -LiteralPath $mod)) {
    New-Item -ItemType Directory -Force -Path $mod | Out-Null
    Fix 'mod 폴더가 없어서 만들었습니다. (게임을 한 번도 켠 적이 없으면 런처를 먼저 한 번 켜 주세요.)'
} else { Ok 'mod 폴더가 있습니다.' }

# 2) 모드 폴더가 없으면 이 파일이 있는 폴더에서 복사
if (-not (Test-Path -LiteralPath $dst)) {
    if (Test-Path -LiteralPath (Join-Path $here 'descriptor.mod')) {
        New-Item -ItemType Directory -Force -Path $dst | Out-Null
        Get-ChildItem -LiteralPath $here -Force | Where-Object { @('.git','.github') -notcontains $_.Name } | Copy-Item -Destination $dst -Recurse -Force
        Fix "모드 폴더가 없어서 여기 있는 파일을 복사했습니다: $dst"
    } else {
        Bad "모드 폴더가 없습니다: $dst"
        Say '       압축을 푼 폴더(common, events, interface가 보이는 곳)에서 install.bat을 먼저 실행하세요.'
    }
}

# 3) 폴더가 한 겹 더 들어가 있는 경우 (예: tfrkp_hongnak\TFRKP--main\descriptor.mod)
if ((Test-Path -LiteralPath $dst) -and -not (Test-Path -LiteralPath (Join-Path $dst 'descriptor.mod'))) {
    $inner = @(Get-ChildItem -LiteralPath $dst -Directory | Where-Object { Test-Path -LiteralPath (Join-Path $_.FullName 'descriptor.mod') })
    if ($inner.Count -eq 1) {
        Get-ChildItem -LiteralPath $inner[0].FullName -Force | Move-Item -Destination $dst -Force
        Remove-Item -LiteralPath $inner[0].FullName -Recurse -Force -ErrorAction SilentlyContinue
        Fix ("폴더가 한 겹 더 들어가 있어서 꺼냈습니다: " + $inner[0].Name)
    } else {
        Bad 'tfrkp_hongnak 폴더 바로 아래에 descriptor.mod가 없습니다. 압축을 다시 풀어 주세요.'
    }
}
$hasMod = Test-Path -LiteralPath (Join-Path $dst 'descriptor.mod')
if ($hasMod) { Ok 'descriptor.mod가 제자리에 있습니다.' }

# 4) 런처용 .mod 파일
$modFile = Join-Path $mod "$name.mod"
foreach ($wrong in @("$name.mod.txt", "$name.txt")) {
    $w = Join-Path $mod $wrong
    if (Test-Path -LiteralPath $w) { Remove-Item -LiteralPath $w -Force; Fix "이름이 잘못된 파일을 지웠습니다: $wrong" }
}
if ($hasMod) {
    $lines = Get-Content -LiteralPath (Join-Path $dst 'descriptor.mod') -Encoding UTF8 | Where-Object { $_ -notmatch '^\s*(path|archive)\s*=' }
    $want  = @($lines) + ('path="' + ($dst -replace '\\', '/') + '"')
    $have  = @()
    if (Test-Path -LiteralPath $modFile) { $have = @(Get-Content -LiteralPath $modFile -Encoding UTF8) }
    if (($have -join "`n") -ne ($want -join "`n")) {
        [IO.File]::WriteAllLines($modFile, [string[]]$want, (New-Object System.Text.UTF8Encoding($false)))
        if ($have.Count -eq 0) { Fix "런처용 파일이 없어서 만들었습니다: $modFile" } else { Fix "런처용 파일의 내용(경로)이 달라서 다시 썼습니다: $modFile" }
    } else { Ok '런처용 tfrkp_hongnak.mod 파일이 올바릅니다.' }
}

# 5) 꼭 있어야 하는 파일
if ($hasMod) {
    $must = @('common\national_focus', 'events', 'interface', 'localisation\korean', 'gfx', 'localisation\korean\TFRKP_HN_l_korean.yml')
    $miss = @($must | Where-Object { -not (Test-Path -LiteralPath (Join-Path $dst $_)) })
    if ($miss.Count -gt 0) { Bad ('빠진 것이 있습니다: ' + ($miss -join ', ') + '  → 압축을 다시 받아 풀어 주세요.') }
    else {
        $n = @(Get-ChildItem -LiteralPath $dst -Recurse -File).Count
        Ok "모드 파일 $n 개가 들어 있습니다."
        if ($n -lt 1000) { Warn '파일 수가 적습니다(1,000개 미만). 압축이 덜 풀렸을 수 있습니다.' }
    }
    # 옛 판에서 남은 파일
    $old = @('interface\TFRKPHN_nk.gui','common\scripted_guis\TFRKPHN_nk_scripted_guis.txt','interface\TFRKPHN_bj.gui','common\scripted_guis\TFRKPHN_bj_scripted_guis.txt','common\decisions\categories\TFRKPHN_bj_decision_categories.txt')
    foreach ($o in $old) { $p = Join-Path $dst $o; if (Test-Path -LiteralPath $p) { Remove-Item -LiteralPath $p -Force; Fix "옛 판에서 남은 파일을 지웠습니다: $o" } }
    # 글 파일(.yml)은 UTF-8 BOM이 있어야 게임이 읽습니다
    $fixed = 0
    Get-ChildItem -LiteralPath (Join-Path $dst 'localisation') -Recurse -Filter '*.yml' | ForEach-Object {
        $b = [IO.File]::ReadAllBytes($_.FullName)
        if ($b.Length -ge 3 -and -not ($b[0] -eq 0xEF -and $b[1] -eq 0xBB -and $b[2] -eq 0xBF)) {
            # 손으로 쓰는 글 파일 두 개는 건드리지 않고 알리기만 합니다
            if (@('TFRKP_HN_l_korean.yml','zzz_TFRKP_HN_replace_l_korean.yml') -contains $_.Name) { Warn ($_.Name + '의 저장 형식이 UTF-8 BOM이 아닙니다. 메모장에서 UTF-8(BOM)으로 다시 저장해 주세요.') }
            else { [IO.File]::WriteAllBytes($_.FullName, [byte[]](0xEF,0xBB,0xBF) + $b); $fixed++ }
        }
    }
    if ($fixed -gt 0) { Fix "글 파일 $fixed 개의 저장 형식(UTF-8 BOM)을 바로잡았습니다." } else { Ok '글 파일의 저장 형식이 올바릅니다.' }
    # 설명서가 .yml.txt로 저장된 경우
    Get-ChildItem -LiteralPath (Join-Path $dst 'localisation') -Recurse -Include '*.yml.txt','*.yml.yml' | ForEach-Object { Warn ("이름이 잘못된 글 파일: " + $_.Name + "  → 끝을 .yml로 고쳐 주세요.") }
}

# 6) 필요한 모드, 겹치는 모드
$names = @{}
Get-ChildItem -LiteralPath $mod -Filter '*.mod' -ErrorAction SilentlyContinue | ForEach-Object {
    $m = Select-String -LiteralPath $_.FullName -Pattern '^name="(.*)"' | Select-Object -First 1
    if ($m) { $k = $m.Matches[0].Groups[1].Value; if (-not $names.ContainsKey($k)) { $names[$k] = @() }; $names[$k] += $_.Name }
}
foreach ($need in @('The Fire Rises', 'The Fire Rises: Korea Plus')) {
    if ($names.ContainsKey($need)) { Ok "필요한 모드가 있습니다: $need" }
    else { Bad "필요한 모드가 없습니다: $need  → Steam 창작마당에서 구독하고 런처를 한 번 켠 뒤 다시 실행하세요." }
}
if ($names.ContainsKey('TFRKP Hong Nak') -and @($names['TFRKP Hong Nak']).Count -gt 1) {
    Warn ('같은 이름의 모드가 여러 개 있습니다: ' + (@($names['TFRKP Hong Nak']) -join ', ') + '  → tfrkp_hongnak.mod만 남기고 나머지는 플레이세트에서 끄세요.')
}
$dupes = @(Get-ChildItem -LiteralPath $mod -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -ne $name -and (Test-Path -LiteralPath (Join-Path $_.FullName 'events\TFRKP_HN_events.txt')) })
foreach ($d in $dupes) { Warn ("이 모드의 옛 복사본으로 보이는 폴더가 있습니다: " + $d.Name + "  → 플레이세트에서 끄세요. 같이 켜면 서로 덮어씁니다.") }

# 7) 게임 오류 기록
$log = Join-Path $hoi 'logs\error.log'
if (Test-Path -LiteralPath $log) {
    $hits = @(Select-String -LiteralPath $log -Pattern 'TFRKPHN|TFRKP_HN|tfrkphn' | Select-Object -First 25)
    Say ''
    Say ("게임 오류 기록(error.log)에서 이 모드와 관련된 줄: " + $hits.Count + " 개 (최대 25개까지 표시)")
    foreach ($h in $hits) { $t = $h.Line; if ($t.Length -gt 200) { $t = $t.Substring(0,200) }; Say ("   " + $t) }
} else { Say ''; Say '게임 오류 기록(error.log)이 아직 없습니다. 게임을 한 번 켠 뒤 다시 실행하면 여기에 표시됩니다.' }

# 8) 결과 저장
Say ''
Say '다음 순서로 진행하세요.' 'Cyan'
Say ' 1. Paradox 런처를 완전히 끄고 다시 켭니다. (작업 표시줄 오른쪽 아래 아이콘까지 종료)'
Say ' 2. 플레이세트에 아래 순서로 넣고 켭니다.'
Say '      The Fire Rises  ->  The Fire Rises: Korea Plus  ->  TFRKP Hong Nak'
Say ' 3. 그래도 안 되면 바탕 화면의 tfrkp_hongnak_report.txt 파일을 모드 만든 사람에게 보내 주세요.'
try {
    $out = Join-Path ([Environment]::GetFolderPath('Desktop')) 'tfrkp_hongnak_report.txt'
    [IO.File]::WriteAllLines($out, [string[]]$rep, (New-Object System.Text.UTF8Encoding($true)))
    Write-Host ''; Write-Host "진단 결과 저장: $out" -ForegroundColor Green
} catch { Write-Host '진단 결과를 바탕 화면에 저장하지 못했습니다. 이 창을 캡처해서 보내 주세요.' -ForegroundColor Yellow }
