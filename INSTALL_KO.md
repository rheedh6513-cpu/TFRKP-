# TFRKP Hong Nak 설치 방법

> 런처 플레이세트에 모드가 안 보이거나 실행이 안 될 때도 이 문서를 따라 하세요. 급하면 `fix.bat`부터 실행합니다.
> 모드 만들기·고치기 안내는 [TUTORIAL_KO.md](TUTORIAL_KO.md)에 있습니다.

## 먼저 알아둘 것

HOI4 런처는 `Documents\Paradox Interactive\Hearts of Iron IV\mod` 폴더 **바로 아래에 있는 `.mod` 파일**을 보고 모드 목록을 만듭니다.
모드 폴더만 복사해 두면 런처에 나타나지 않습니다. 그래서 폴더와 `.mod` 파일, 둘 다 있어야 합니다.

## 준비물

Steam 창작마당에서 아래 두 모드를 구독하고, 런처를 한 번 켜서 내려받게 합니다.

- The Fire Rises
- The Fire Rises: Korea Plus

## 방법 A. 설치 파일 (권장)

1. GitHub에서 내려받은 압축 파일을 풉니다. `common`, `events`, `interface` 폴더가 바로 보이는 폴더까지 들어갑니다.
2. 그 폴더의 **`install.bat`을 더블클릭**합니다. (Windows가 경고하면 "추가 정보 → 실행")
3. 화면에 `런처용 파일 생성`이 나오면 끝입니다. 필요한 모드가 빠졌으면 경고가 함께 나옵니다.
4. [플레이세트 설정](#플레이세트-설정)으로 갑니다.

잘 안 되면 같은 폴더의 `fix.bat`을 더블클릭하세요. ([안 될 때](#안-될-때) 참고)

문서 폴더가 OneDrive 안에 있어도 설치 파일이 알아서 찾습니다.

## 방법 B. 직접 하기

1. 모드 파일을 아래 위치에 복사합니다. (`tfrkp_hongnak` 바로 아래에 `descriptor.mod`, `common`, `events`가 보여야 합니다.)

   `C:\Users\내이름\Documents\Paradox Interactive\Hearts of Iron IV\mod\tfrkp_hongnak`

2. 같은 `mod` 폴더(`tfrkp_hongnak` 폴더 **밖**)에 메모장으로 `tfrkp_hongnak.mod` 파일을 만들고, 아래 내용을 붙여 넣습니다. 마지막 줄의 `내이름`만 바꿉니다.

```
version="1.0"
tags={
	"Alternative History"
	"Gameplay"
}
dependencies={
	"The Fire Rises"
	"The Fire Rises: Korea Plus"
}
name="TFRKP Hong Nak"
supported_version="1.19.*"
path="C:/Users/내이름/Documents/Paradox Interactive/Hearts of Iron IV/mod/tfrkp_hongnak"
```

   - 저장할 때 파일 형식을 **모든 파일**로 하고, 이름 끝이 `.mod.txt`가 되지 않게 합니다.
   - 경로 구분은 `\`가 아니라 `/`입니다.

## 플레이세트 설정

1. Paradox 런처를 **완전히 끄고 다시 켭니다.** (`.mod` 파일은 런처를 켤 때 읽습니다.)
2. 새 플레이세트를 만들거나 쓰던 플레이세트를 엽니다.
3. 설치된 모드 목록에서 **TFRKP Hong Nak**을 찾아 추가하고 켭니다. 목록이 길면 검색창을 쓰세요.
4. 순서는 이렇게 둡니다.

   The Fire Rises → The Fire Rises: Korea Plus → TFRKP Hong Nak

   한글패치 같은 다른 모드는 TFRKP Hong Nak보다 **위**에 둡니다. 아래에 있는 모드가 위의 것을 덮어씁니다.
5. 예전 복사본(예: "tfrkp 홍준표 이낙연")이 켜져 있으면 **끕니다.** 같이 켜면 서로 덮어씁니다.

## 안 될 때

### 1. 먼저 fix.bat

모드 폴더(또는 압축을 푼 폴더)의 **`fix.bat`을 더블클릭**합니다. 아래를 차례로 확인하고, 고칠 수 있는 것은 바로 고칩니다.

- `mod` 폴더와 `tfrkp_hongnak` 폴더가 있는지
- 폴더가 한 겹 더 들어가 있는지 (`tfrkp_hongnak\TFRKP--main\...`)
- 런처용 `tfrkp_hongnak.mod`가 있는지, 경로가 맞는지, 이름이 `.mod.txt`로 저장되지 않았는지
- 옛 판에서 남은 파일, 글 파일(`.yml`)의 저장 형식
- The Fire Rises와 Korea Plus가 설치돼 있는지, 이 모드의 옛 복사본이 같이 있는지
- 게임 오류 기록(`error.log`)에서 이 모드와 관련된 줄

결과는 바탕 화면의 `tfrkp_hongnak_report.txt`에 저장됩니다. 해결이 안 되면 이 파일을 보내 주세요.

### 2. 증상별 확인

| 증상 | 확인할 것 |
| --- | --- |
| 목록에 TFRKP Hong Nak이 없다 | `mod` 폴더 바로 아래에 `tfrkp_hongnak.mod`가 있는지 (폴더 안이 아니라 밖). 이름이 `.mod.txt`로 끝나면 확장자를 고칩니다. 탐색기에서 "파일 확장명" 보기를 켜서 확인하세요. 고친 뒤에는 런처를 완전히 껐다 켭니다. |
| 목록에는 있는데 경고 표시가 뜬다 | `.mod`의 `path=`가 실제 폴더와 같은지. 사용자 이름이나 OneDrive 경로가 다른 경우가 많습니다. |
| 폴더를 넣었는데도 경고 | 압축을 풀면 `TFRKP--main\TFRKP--main`처럼 폴더가 한 겹 더 들어 있는 경우가 있습니다. `descriptor.mod`가 `path=`로 지정한 폴더 **바로 아래**에 있어야 합니다. |
| "필요한 모드가 없다"고 나온다 | Steam 창작마당에서 The Fire Rises와 The Fire Rises: Korea Plus를 구독하고, 런처를 한 번 켜서 내려받게 합니다. |
| 켜졌는데 글이 `tfrkphn.317.t`처럼 보인다 | 게임 언어가 한국어인지, 모드 순서가 맞는지 봅니다. 한글패치는 TFRKP Hong Nak보다 위에 둡니다. |
| 사건 그림이나 초상이 비어 보인다 | 압축이 덜 풀렸을 수 있습니다. `gfx` 폴더가 있는지 보고 다시 풉니다. |
| 게임이 시작 화면에서 꺼진다 | 다른 모드를 모두 끄고 세 모드만 켜서 다시 해 봅니다. HOI4와 두 원본 모드가 최신인지도 확인합니다. |
| 예전 저장 파일에서 이상하다 | 모드가 바뀌면 예전 저장 파일은 맞지 않을 수 있습니다. 새 게임으로 확인하세요. |

### 3. 직접 붙여 넣는 PowerShell 코드

시작 메뉴에서 **Windows PowerShell**을 열고 붙여 넣은 뒤 Enter를 누릅니다.

> 메신저로 코드를 주고받으면 밑줄(`_`)이 사라지는 경우가 있습니다. 그래서 아래 코드는 밑줄을 `[char]95`로 적었습니다. 코드를 전달할 때는 이 문서 파일이나 `.txt` 파일째로 보내는 편이 안전합니다.

**(가) 런처용 파일 다시 만들기** — 모드가 목록에 안 보일 때

```powershell
$u=[char]95; $n="tfrkp${u}hongnak"
$mod=Join-Path ([Environment]::GetFolderPath('MyDocuments')) 'Paradox Interactive\Hearts of Iron IV\mod'
$dst=Join-Path $mod $n
if(-not(Test-Path "$dst\descriptor.mod")){ "모드 폴더가 없거나 한 겹 더 들어가 있습니다: $dst" } else {
  $l=Get-Content "$dst\descriptor.mod" -Encoding UTF8 | Where-Object { $_ -notmatch '^\s*(path|archive)\s*=' }
  $o=@($l)+('path="'+($dst -replace '\\','/')+'"')
  [IO.File]::WriteAllLines((Join-Path $mod "$n.mod"),[string[]]$o,(New-Object System.Text.UTF8Encoding($false)))
  "만들었습니다: " + (Join-Path $mod "$n.mod") }
```

**(나) 상태만 확인하기** — 아무것도 바꾸지 않고 보여 주기만 합니다

```powershell
$u=[char]95; $n="tfrkp${u}hongnak"
$mod=Join-Path ([Environment]::GetFolderPath('MyDocuments')) 'Paradox Interactive\Hearts of Iron IV\mod'
"mod 폴더: $mod  /  있음: " + (Test-Path $mod)
"모드 폴더 있음: " + (Test-Path "$mod\$n") + "  /  descriptor.mod 있음: " + (Test-Path "$mod\$n\descriptor.mod")
"런처용 파일 있음: " + (Test-Path "$mod\$n.mod")
if(Test-Path "$mod\$n.mod"){ Get-Content "$mod\$n.mod" -Encoding UTF8 }
"파일 수: " + @(Get-ChildItem "$mod\$n" -Recurse -File -ErrorAction SilentlyContinue).Count
Get-ChildItem $mod -Filter *.mod | ForEach-Object { $m=Select-String $_.FullName -Pattern '^name="(.*)"' | Select-Object -First 1; if($m){ $_.Name + "  ->  " + $m.Matches[0].Groups[1].Value } }
```

**(다) 게임 오류 기록에서 이 모드 줄만 보기** — 게임을 한 번 켠 뒤에 실행합니다

```powershell
$log=Join-Path ([Environment]::GetFolderPath('MyDocuments')) 'Paradox Interactive\Hearts of Iron IV\logs\error.log'
Select-String $log -Pattern 'TFRKPHN|TFRKP.HN|tfrkphn' | Select-Object -First 40 | ForEach-Object { $_.Line }
```

**(라) 깨끗하게 다시 설치하기** — 모드 폴더를 지우고 처음부터. 압축을 푼 폴더에서 `install.bat`을 다시 실행하기 전에 씁니다

```powershell
$u=[char]95; $n="tfrkp${u}hongnak"
$mod=Join-Path ([Environment]::GetFolderPath('MyDocuments')) 'Paradox Interactive\Hearts of Iron IV\mod'
if(Test-Path "$mod\$n"){ Remove-Item "$mod\$n" -Recurse -Force }
if(Test-Path "$mod\$n.mod"){ Remove-Item "$mod\$n.mod" -Force }
"지웠습니다. 이제 install.bat을 다시 실행하세요."
```

(라)는 모드 폴더를 통째로 지웁니다. 그 안에서 직접 고친 파일이 있으면 먼저 다른 곳에 복사해 두세요.

### 4. 그래도 안 될 때 보내 줄 것

- 바탕 화면의 `tfrkp_hongnak_report.txt`
- 런처의 플레이세트 화면 캡처
- 어느 단계에서 어떤 화면이 나오는지
