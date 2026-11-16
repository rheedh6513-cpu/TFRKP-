# TFRKP Hong Nak (홍준표 서브섭모드)

HOI4 모드 **The Fire Rises: Korea Plus**의 서브섭모드입니다.
홍준표가 2021년 국민의힘 경선에서 승리하고 2022년 대선에서 당선되는 대체역사를 다룹니다.

## 같이 작업하려면

### 1. 준비물
- [GitHub Desktop](https://desktop.github.com/) 설치
- HOI4 본편 + 모드 2개 구독
  - The Fire Rises (워크샵 3350890356)
  - The Fire Rises: Korea Plus (워크샵 3617039195)

### 2. 내려받기
GitHub Desktop에서 `File` → `Clone repository`로 이 저장소를 받습니다.
받을 위치는 아래로 지정하면 바로 게임에 적용됩니다.

```
문서\Paradox Interactive\Hearts of Iron IV\mod\tfrkp_hongnak
```

### 3. 고치고 올리기
1. 파일을 고칩니다.
2. GitHub Desktop 왼쪽에 바뀐 파일이 뜹니다.
3. 아래 칸에 무엇을 바꿨는지 한 줄 적고 `Commit to main`을 누릅니다.
4. 위쪽 `Push origin`을 누르면 올라갑니다.

### 4. 남이 바꾼 것 받기
작업 시작 전에 **항상** `Fetch origin` → `Pull origin`을 먼저 누릅니다.

## 폴더 설명

| 폴더 | 내용 |
|---|---|
| `common/national_focus/` | 중점 트리 |
| `common/decisions/` | 결정(디시전)과 결정 묶음 |
| `common/scripted_effects/` | 여러 곳에서 쓰는 효과 묶음 |
| `common/scripted_guis/` | 결정 탭 화면 동작 |
| `common/ideas/` | 국민정신 |
| `common/on_actions/` | 매일 자동으로 도는 처리 |
| `events/` | 이벤트 |
| `interface/` | 화면 배치(.gui)와 그림 등록(.gfx) |
| `gfx/` | 그림 파일 |
| `localisation/korean/` | 게임에 보이는 모든 글 |

## 파일 고칠 때 지켜야 할 것

- **글 파일(`localisation/*.yml`)은 BOM 있는 UTF-8**로 저장합니다.
- **그 외 모든 파일(common, events, interface)은 BOM 없는 UTF-8**로 저장합니다.
  BOM이 들어가면 그 파일 전체가 게임에서 무시됩니다.
- 글 파일은 한 줄에 하나씩, ` 키:0 "내용"` 형식입니다. 줄바꿈은 실제 엔터가 아니라 `\n`으로 씁니다.
- 이벤트 사진은 **500x250 PNG**로 만들어 `gfx/event_pictures/`에 넣고 `interface/TFRKP_HN.gfx`에 등록합니다.

## 작업 분담 요령

같은 파일을 둘이 동시에 고치면 충돌이 납니다. 아래처럼 나누면 편합니다.

- A: 중점 트리(`TFRKPHN_hong_focus.txt`)
- B: 이벤트 글(`localisation/korean/TFRKP_HN_l_korean.yml`)

## 콘솔 치트 (테스트용)

```
event tfrkphn.10                          홍준표 대통령 시작 처리
effect set_global_flag = PRC_taiwan_war_lost   양안전쟁 승전 상태로
effect TFRKPHN_amend_start = yes          개헌 논의 시작
effect TFRKPHN_crime_init = yes           범죄와의 전쟁 상황판 준비
```
