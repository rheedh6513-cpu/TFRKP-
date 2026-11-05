# TFR 중점 트리 만들기 튜토리얼

> TFRKP Hong Nak 모드 협업자용 안내서입니다. 받은 사람 누구나 고쳐서 다시 올려도 됩니다.
> 고칠 때는 맨 아래 **[이 문서 고치는 법](#10-이-문서-고치는-법)** 을 먼저 읽어 주세요.
>
> 마지막 수정: 2026-11-05

The Fire Rises(TFR) 서브모드에 중점 트리를 새로 만들거나 고칠 때 필요한 내용을, 우리 모드(TFRKP Hong Nak)의 실제 코드를 예시로 정리했습니다. TFR 전용 해외 튜토리얼은 찾지 못해 HOI4 기본 중점 문법을 기준으로 썼고, TFR에서 주의할 점은 7장에 따로 모았습니다.

## 목차

1. [파일 구조](#1-파일-구조)
2. [기본 틀](#2-기본-틀)
3. [위치 잡기](#3-위치-잡기)
4. [선행 조건과 상호 배타](#4-선행-조건과-상호-배타)
5. [조건과 보상](#5-조건과-보상)
6. [문구 쓰기](#6-문구-쓰기)
7. [TFR 서브모드 주의점](#7-tfr-서브모드-주의점)
8. [테스트](#8-테스트)
9. [우리 모드 파일 지도](#9-우리-모드-파일-지도)
10. [이 문서 고치는 법](#10-이-문서-고치는-법)

---

## 1. 파일 구조

중점 트리 하나는 보통 네 종류의 파일로 이루어집니다. 모드 폴더 안의 경로와 이름이 원본 TFR과 겹치면 원본 파일이 통째로 가려지므로, 새 파일에는 반드시 모드 고유 접두어(우리는 `TFRKPHN_`)를 붙입니다.

| 무엇 | 경로 | 우리 모드 예시 |
| --- | --- | --- |
| 중점 트리 | `common/national_focus/` | `TFRKPHN_hong_focus.txt` |
| 중점 이름과 설명 | `localisation/korean/` (파일명 끝 `_l_korean.yml`) | `TFRKP_HN_hong_focus_l_korean.yml` |
| 아이콘 등록 | `interface/*.gfx` | `TFRKP_HN.gfx` |
| 아이콘 그림 | `gfx/interface/goals/` | `TFRKPHN_hongkacola.png` |

- 문구 파일은 **UTF-8 BOM**으로 저장하고 첫 줄은 `l_korean:`이어야 합니다. 둘 중 하나라도 어긋나면 파일 전체가 무시됩니다.
- 아이콘 그림은 기본 중점 아이콘(약 95×85)에 비율을 맞추고, `.gfx`에 `GFX_focus_` 접두어로 등록합니다.

## 2. 기본 틀

트리 파일은 `focus_tree` 블록 하나에 `focus` 블록을 여러 개 넣는 구조입니다. 아래는 홍준표 트리의 실제 시작 부분입니다.

```
focus_tree = {
	id = TFRKPHN_hong_tree
	country = { factor = 0 }   # 자동으로 붙지 않게 (이벤트로 불러옴)
	default = no
	continuous_focus_position = { x = 50 y = 1170 }

	focus = {
		id = TFRKPHN_hong_b01_01
		icon = GFX_focus_TFRKPHN_hong_start
		x = 6
		y = 0
		cost = 5
		ai_will_do = { factor = 1 }
		completion_reward = {
			add_stability = 0.10
			country_event = { id = tfrkphn.20 }
		}
	}
}
```

| 필드 | 뜻 | 메모 |
| --- | --- | --- |
| `id` | 중점 고유 이름 | 문구 키도 이 이름을 그대로 씀 |
| `icon` | 아이콘 스프라이트 | `.gfx`에 등록된 이름 |
| `x`, `y` | 위치 | 3장 참고 |
| `relative_position_id` | 기준이 되는 중점 | 있으면 `x`, `y`는 그 중점에서의 거리 |
| `cost` | 소요 기간 | 1 = 7일 |
| `prerequisite` | 선행 중점 | 4장 참고 |
| `mutually_exclusive` | 같이 못 찍는 중점 | 4장 참고 |
| `available` | 선택 가능 조건 | 5장 참고 |
| `allow_branch` | 보이기 조건 | 5장 참고 |
| `bypass` | 건너뛰기 조건 | 5장 참고 |
| `completion_reward` | 완료 보상 | 5장 참고 |
| `ai_will_do` | AI가 고를 비중 | 0이면 AI가 안 고름 |

## 3. 위치 잡기

위치는 칸 단위입니다. `x`는 오른쪽으로 한 칸, `y`는 아래로 한 줄이고, 음수도 쓸 수 있습니다. `relative_position_id`를 적으면 그 중점을 기준점으로 삼아, 기준이 움직이면 따라서 같이 움직입니다.

```
focus = {
	id = TFRKPHN_hong_b03_12		# 모병제 확대
	relative_position_id = TFRKPHN_hong_b03_10
	x = 1		# 기준보다 오른쪽 한 칸
	y = 1		# 기준보다 아래 한 줄
}
```

### 좌우 불규칙하게 배치하는 요령

좌우를 거울처럼 맞춘 다이아몬드형 트리는 읽기는 쉽지만 단조롭습니다. 갈래마다 길이와 간격을 다르게 하면 훨씬 자연스럽습니다.

- **형제 중점의 높이를 엇갈리게**: 한쪽은 `y = 1`, 다른 쪽은 `y = 2`. 긴 갈래와 짧은 갈래가 생깁니다.
- **간격을 다르게**: 왼쪽은 `x = -1`, 오른쪽은 `x = 2`처럼 비대칭으로.
- **합류 중점은 가운데가 아니어도 됨**: 두 갈래가 만나는 중점을 한쪽에 치우치게 두면 흐름이 생깁니다.
- **끝점은 맞추기**: 여러 갈래가 하나의 최종 중점으로 모일 때는 각 갈래 끝을 같은 줄에 두면 선이 깔끔합니다.
- **겹침 확인**: 같은 칸에 두 중점이 오면 게임에서 하나가 가려집니다. 위치를 바꾼 뒤에는 꼭 게임에서 트리를 열어 봅니다.

홍준표 트리는 2026년 11월 5일에 이 방식으로 다시 배치했습니다. 예를 들어 「충 - 충성 충」 갈래는 「3축 체계 완성」을 왼쪽으로 한 칸 더 빼고 「PDTO 핵억지 협의」를 한 줄 아래로 내렸습니다.

## 4. 선행 조건과 상호 배타

`prerequisite` 블록 **하나 안**에 여러 중점을 넣으면 "그중 하나만"(OR), 블록을 **여러 개** 쓰면 "전부 다"(AND)입니다. 게임 화면에서는 OR이 점선, AND가 실선으로 그려집니다.

```
# OR: 4개 중 하나만 완료하면 됨 (민생도 보수)
prerequisite = { focus = TFRKPHN_hong_b01_06 focus = TFRKPHN_hong_b01_07 focus = TFRKPHN_hong_b01_08 focus = TFRKPHN_hong_b01_09 }

# AND: 두 개 모두 완료해야 함 (홍카콜라 국정 소통)
prerequisite = { focus = TFRKPHN_hong_b03_06 }
prerequisite = { focus = TFRKPHN_hong_b03_07 }
```

`mutually_exclusive`는 둘 중 하나를 고르면 다른 하나가 잠기는 관계입니다. **양쪽 중점에 모두** 서로를 적어야 확실하게 작동합니다.

```
# 대한민국의 양안전쟁 참전 (b02_02)
mutually_exclusive = { focus = TFRKPHN_hong_b02_03 }
# 부결 (b02_03)
mutually_exclusive = { focus = TFRKPHN_hong_b02_02 }
```

상호 배타인 두 중점은 같은 줄에 두어야 빨간 선이 수평으로 깔끔하게 그려집니다.

## 5. 조건과 보상

세 가지 조건은 하는 일이 다릅니다.

| 조건 | 거짓일 때 | 언제 쓰나 |
| --- | --- | --- |
| `available` | 보이지만 누를 수 없음 | 사건이나 수치가 채워져야 할 때 |
| `allow_branch` | 트리에서 아예 안 보임 | 경로가 갈릴 때 (승전/패전 등) |
| `bypass` | 참이면 자동으로 건너뜀 | 이미 다른 방법으로 달성했을 때 |

```
# 대한민국의 양안전쟁 참전: 대만지원법이 통과해야만 누를 수 있음
available = { has_country_flag = TFRKPHN_hong_tw_bill_passed }
```

보상은 `completion_reward` 안에 씁니다. 이벤트를 띄우거나 플래그를 세우는 것처럼 플레이어 눈에 잘 안 보이는 효과는 `custom_effect_tooltip`으로 설명을 붙이고, 보여 줄 필요 없는 내부 처리는 `hidden_effect`로 감춥니다.

```
completion_reward = {
	country_event = tfrkphn.63
	add_war_support = 0.05
	set_global_flag = TFRKPHN_kj_nuke_open
	custom_effect_tooltip = TFRKPHN_kj_nuke_unlock_tt	# "한일 공동 핵무장 패널이 열립니다"
	hidden_effect = {
		JAP = { country_event = { id = tfrkphn.324 days = 1 } }
	}
}
```

### 이벤트 선택지도 같은 원칙

버튼 문구는 인물의 반응으로 쓰고, 결과 설명은 툴팁으로 내립니다.

```
option = {
	name = tfrkphn.317.a				# "이번 총선, 쉽지 않겠군."
	custom_effect_tooltip = tfrkphn.317.a_tt	# "페미니즘과 여성 인권이 이번 총선의 쟁점 중 하나로 떠오릅니다."
}
```

툴팁 문구 키는 선택지 키 뒤에 `_tt`를 붙여 같은 문구 파일에 둡니다.

## 6. 문구 쓰기

중점 이름 키는 중점 `id`와 같고, 설명 키는 뒤에 `_desc`를 붙입니다. 한 줄에 키 하나이고, 줄은 공백 한 칸으로 시작합니다.

```
 TFRKPHN_hong_b03_12:0 "모병제 확대"
 TFRKPHN_hong_b03_12_desc:0 "고급 기술을 갖춘 직업군인 중심의 정예군으로 바꿉니다."
```

- 줄바꿈은 `\n`, 색은 `§Y노란 글씨§!`처럼 씁니다. § 뒤에는 색 글자를, 끝에는 항상 `§!`를 붙입니다.
- 다른 키의 문구를 가져오려면 `$키이름$`, 상황에 따라 바뀌는 문구는 `[이름]`(scripted_localisation)을 씁니다. 없는 이름을 쓰면 글자가 그대로 찍힙니다.
- ㆍ, …, —, → 같은 특수문자는 게임 글꼴에 없어 `?`로 보일 수 있습니다. `,` `...` `-` `>`로 바꿉니다.

### 과장된 표현 줄이기

중점 설명은 연설문보다 보고서에 가깝게 씁니다. 무엇을 하고 왜 하는지만 담고, 감탄사와 단정은 뺍니다.

| 줄이기 전 | 줄인 뒤 |
| --- | --- |
| 대만이 불타고 있습니다. 대만이 무너지면 다음은 우리입니다. | 대만해협에서 전쟁이 벌어졌습니다. 대만이 무너지면 한반도도 안전하지 않습니다. |
| 평양이 감히 움직일 엄두조차 내지 못하게 하겠습니다. | 도발에는 즉각 대응한다는 원칙을 분명히 해 평양의 오판을 막습니다. |
| 힘을 다한 정치 끝에 대한민국은 다시 하나가 됩니다. | 갈등이 모두 사라지지는 않았지만, 대화의 자리는 다시 마련되었습니다. |

인물의 실제 구호나 어록("평화는 구걸이 아니라 힘으로" 등)은 캐릭터 색이니 그대로 둡니다.

## 7. TFR 서브모드 주의점

TFR 서브모드는 원본 위에 얹히는 구조라서, 새로 만드는 것보다 원본과 부딪히지 않게 하는 것이 더 중요합니다.

- **의존성**: `descriptor.mod`의 `dependencies`에 "The Fire Rises"와 "The Fire Rises: Korea Plus"를 적어 두어야 원본보다 나중에 읽힙니다.
- **트리 불러오기**: 우리 트리는 `country = { factor = 0 }`으로 자동 적용을 막고, 당선 이벤트에서 `load_focus_tree = { tree = TFRKPHN_hong_tree keep_completed = no }`로 교체합니다.
- **같은 id 주의**: 중점 id가 원본과 같으면 두 트리가 완료 상태를 공유합니다. 홍준표 트리의 군사 갈래(`KOR_yoon_after_*`, `KOR_military_common_*`)는 일부러 원본 id를 그대로 쓴 경우입니다. 새 중점은 항상 우리 접두어를 붙입니다.
- **파일 덮어쓰기**: 원본과 같은 경로, 같은 이름의 파일은 원본을 통째로 대체합니다. `events/TFR_events_KOR.txt`처럼 원본을 복사해 고친 파일은 원본이 업데이트되면 다시 맞춰야 합니다.
- **원본 문구 바꾸기**: 원본 키를 바꾸려면 `localisation/korean/replace/` 폴더에 같은 키를 넣습니다. 이 폴더의 키가 원본보다 우선합니다.
- **명령 이름 확인**: HOI4에 없는 명령은 조용히 무시됩니다. 예를 들어 전역 변수는 `set_global_variable`이 아니라 `set_variable = { global.이름 = 60 }`입니다.
- **같은 모드를 두 번 켜지 않기**: 런처 플레이셋에 옛 복사본(예: "tfrkp 홍준표 이낙연")이 같이 켜져 있으면 파일이 서로를 덮어쓸 수 있습니다. 하나만 켭니다.

## 8. 테스트

고친 뒤에는 게임을 **완전히 껐다 켜야** 합니다. 문구와 트리는 게임을 켤 때 한 번만 읽힙니다.

| 콘솔 명령 | 하는 일 |
| --- | --- |
| `focus.ignoreprerequisites` | 선행 조건 무시 (다시 입력하면 꺼짐) |
| `focus.autocomplete` | 누르면 중점 즉시 완료 |
| `event tfrkphn.317 KOR` | 이벤트 바로 띄우기 |
| `tag JAP` | 다른 나라로 바꿔 보기 |

문제가 생기면 `문서\Paradox Interactive\Hearts of Iron IV\logs\error.log`에서 우리 파일 이름(`TFRKPHN`, `TFRKP_HN`)을 찾습니다. 자주 보는 오류는 이렇습니다.

| 로그 문구 | 뜻 |
| --- | --- |
| `Unknown effect-type` | 없는 명령을 씀 |
| `Illegal break character` | 문구 안에 따옴표를 잘못 씀 |
| `texture` 관련 오류 / 빈 아이콘 | `.gfx` 경로에 그림 파일이 없음 |

게임에서 키 이름(예: `tfrkphn.317.t`)이 그대로 보이면 그 키가 어느 문구 파일에도 없거나, 파일이 통째로 안 읽힌 것입니다.

## 9. 우리 모드 파일 지도

각 파일 맨 위에는 `# [안내]`로 시작하는 설명 줄이 있습니다. 파일을 열면 먼저 그 줄을 읽고, 아래 표에서 고칠 곳을 찾으세요.

| 고치고 싶은 것 | 파일 |
| --- | --- |
| 홍준표 중점 위치, 조건, 보상 | `common/national_focus/TFRKPHN_hong_focus.txt` |
| 홍준표 중점 이름과 설명 | `localisation/korean/TFRKP_HN_hong_focus_l_korean.yml` |
| 2027 후임 트리 | `common/national_focus/TFRKPHN_이름_focus.txt` |
| 이벤트 내용(코드) | `events/TFRKP_HN_*.txt` |
| 이벤트 본문(스토리) | `localisation/korean/TFRKP_HN_story_l_korean.yml` |
| 2027 대선 문구, 선택지 툴팁 | `localisation/korean/TFRKP_HN_ge2027_l_korean.yml` |
| 이벤트가 뜨는 날짜와 조건 | `common/on_actions/TFRKPHN_on_actions.txt` |
| 결정(개헌, 범죄, 모래시계 등) | `common/decisions/TFRKPHN_*_decisions.txt` |
| 결정 화면의 버튼 | `common/scripted_guis/TFRKPHN_scripted_guis.txt` + `interface/TFRKPHN_*.gui` |
| 그림 등록 | `interface/TFRKP_HN.gfx` |
| 원본 TFR 문구 덮어쓰기 | `localisation/korean/replace/zzz_TFRKP_HN_replace_l_korean.yml` |

### 협업 규칙

1. 새 중점, 이벤트, 플래그, 그림 이름에는 `TFRKPHN_`(이벤트는 `tfrkphn.`)을 붙입니다.
2. 이벤트 번호는 겹치지 않게, 파일 끝의 가장 큰 번호 다음을 씁니다.
3. 문구 파일은 UTF-8 BOM으로 저장합니다. 메모장보다 VS Code가 안전합니다.
4. 선택지 버튼에는 반응을, 결과 설명은 `_tt` 키의 툴팁에 씁니다(5장).
5. 고친 뒤에는 게임을 다시 켜고, error.log에 우리 파일 이름이 없는지 확인합니다(8장).

## 10. 이 문서 고치는 법

이 문서는 `TUTORIAL_KO.md`라는 텍스트 파일 하나입니다. 받은 사람은 누구나 고쳐서 다시 올려도 됩니다.

- **여는 법**: 메모장, VS Code 등 아무 편집기로 열면 됩니다. 마크다운을 지원하는 뷰어(VS Code 미리보기, Typora, 노션 가져오기 등)로 열면 표와 제목이 정리되어 보입니다.
- **고치는 법**: 편집기에서 고친 뒤 UTF-8로 저장합니다. 제목은 `#`, 표는 `|`, 코드는 ``` 로 감싸는 마크다운 문법을 그대로 씁니다.
- **다시 올리는 법**: 고친 파일을 그대로 올리고, 무엇을 바꿨는지 한 줄로 같이 적어 주세요. 여러 사람이 동시에 고쳤다면 최신 파일을 받아서 그 위에 다시 고칩니다.
- **고칠 때 지킬 것**
  - 예시 코드는 실제 모드 파일에서 복사해 옵니다. 지어낸 코드를 넣지 않습니다.
  - 장을 새로 만들면 위 목차에도 추가합니다.
  - 맨 위의 "마지막 수정" 날짜를 바꿉니다.
  - 모드 파일 맨 위의 `# [안내]` 줄은 이 파일(`TUTORIAL_KO.md`)의 장 번호를 가리키니, 장 번호를 바꾸면 그 줄도 맞춰 주세요.
