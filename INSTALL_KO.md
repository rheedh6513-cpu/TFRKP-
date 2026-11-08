# TFRKP Hong Nak 설치 방법

> 런처 플레이세트에 모드가 안 보일 때도 이 문서를 따라 하세요.
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

## 그래도 안 보일 때

| 증상 | 확인할 것 |
| --- | --- |
| 목록에 TFRKP Hong Nak이 없다 | `mod` 폴더 바로 아래에 `tfrkp_hongnak.mod`가 있는지 (폴더 안이 아니라 밖). 이름이 `.mod.txt`로 끝나면 확장자를 고칩니다. 탐색기에서 "파일 확장명" 보기를 켜서 확인하세요. |
| 목록에는 있는데 경고 표시가 뜬다 | `.mod`의 `path=`가 실제 폴더와 같은지. 사용자 이름이나 OneDrive 경로가 다른 경우가 많습니다. |
| 폴더를 넣었는데도 경고 | 압축을 풀면 `TFRKP--main\TFRKP--main`처럼 폴더가 한 겹 더 들어 있는 경우가 있습니다. `descriptor.mod`가 `path=`로 지정한 폴더 **바로 아래**에 있어야 합니다. |
| 켜졌는데 이벤트·중점 문구가 `tfrkphn.317.t`처럼 보인다 | 모드 순서와 한글패치 위치를 다시 확인하고, `TFRKP_HN_*_l_korean.yml` 파일이 모두 `localisation\korean` 안에 있는지 봅니다. 게임을 껐다 켜야 반영됩니다. |
| 위 내용을 다 했는데도 안 된다 | `Documents\Paradox Interactive\Hearts of Iron IV\logs\error.log`의 첫 부분과 런처 화면을 캡처해서 알려 주세요. |
