# rapa (rapa.world 루트)

정적 랜딩 — 출시 서비스(코코세이버·옜다·아이키·아이타임·토닥) 소개 허브. 저장소 `fready-hub/fready-hub.github.io`(GitHub 사용자 사이트, 폴더명과 다름), Pages 소스 `main` `/`, 커스텀 도메인 `rapa.world`(`CNAME`).
공통 규칙은 `~/projects/CLAUDE.md` 에서 자동 로드된다. 여기엔 rapa 고유 내용만 둔다. 진행 문서는 따로 없고 `git log` 가 기록이다.

## 새 세션 진입 순서
1. `git fetch --prune` 후 미머지 브랜치 확인(공통 「브랜치·배포 일원화」 1번의 `git cherry` 스크립트). 기본 브랜치는 `main`, 원격에 옛 `master` 가 남아 있다(Pages 소스 아님).
2. `index.html` 의 `SERVICES` 배열(서비스 카드·스토어 링크)과 `git log --oneline -10` 을 본다.
3. `gh issue list` 로 열린 이슈 확인.

## 환경 제약
- 빌드·패키지 없음. `index.html` 한 파일 + `assets/` + `CNAME`·`robots.txt`·`sitemap.xml`. Node·nvm 불필요.
- `main` 에 push 하면 곧 `rapa.world` 에 배포된다(Pages). 그래서 작업 브랜치에서 확인 후 머지한다.
- `fready-hub.github.io` 는 `rapa.world` 로 301 리다이렉트된다. 외부에 등록하는 주소는 `rapa.world` 만 쓴다.
- 서비스 카드를 추가·변경하면 스토어 링크가 200 인지 먼저 본다(아래 검증).

## 검증 명령
```bash
set -euo pipefail
cd ~/projects/rapa
# 1) 로컬 서빙 후 열기 — 화면은 눈으로 확인(QA)
python3 -m http.server 8080   # http://localhost:8080
# 2) 외부 링크 전부 200 인지(0건이면 실패로 본다)
urls=$(grep -oE "https://[^\"' <)\`]+" index.html | grep -v -E 'fonts\.|\$\{' | sort -u)
test -n "$urls"
for u in $urls; do echo "$u $(curl -s -L -o /dev/null -w '%{http_code}' --max-time 15 "$u")"; done
# 3) 배포 상태
curl -s -o /dev/null -w '%{http_code} %{ssl_verify_result}\n' https://rapa.world/   # 200 0
gh api repos/fready-hub/fready-hub.github.io/pages --jq '{status,cname,https_enforced}'
echo "점검 완료"
```
단위 테스트·타입체크·빌드는 해당 없음 — 컴파일 대상이 없는 정적 HTML.

## 테스트 대장·QA
- 대장 파일: 해당 없음 — 기능 로직이 없는 랜딩이라 `T-` 대상이 없다. 카드·링크 변경 시 위 검증으로 대신한다.
- `QA-` 확인 수단: 브라우저(모바일 폭·데스크톱 폭에서 카드 배치, 스토어 버튼이 올바른 스토어로 가는지). 화면 QA 구간은 `device-qa` 에이전트에 넘긴다.
- `SEC-`: 비밀값을 쓰지 않는 공개 정적 페이지(저장소 public). 변경 시 눈으로 볼 것은 **비밀값이 커밋에 들어갔는가** 하나다. DB·접근 제어·개인정보 로그·서버 의존성 없음(해당 없음).

## 건드리면 안 되는 경로
- `CNAME` — 지우거나 바꾸면 `rapa.world` 연결이 끊긴다(Pages 가 도메인을 잃는다).
- `.github/workflows/pages-alert.yml` — Pages 실패 알림 경로. 채널 ID·시크릿 이름을 바꾸면 알림이 조용히 끊긴다.
- `robots.txt`·`sitemap.xml` — 검색엔진 등록(네이버 소유 확인 메타 포함)에 쓰인다. 호스트는 `rapa.world` 유지.
- 서비스 카드의 스토어 링크·`referrer` utm 파라미터는 유입 측정에 쓰이므로 임의로 바꾸지 않는다.

## 세션 구성
이 세션이 관리 세션이다. 작업은 경중에 따라 직접 / 서브에이전트 / 별도 세션 중 고른다.

| 세션 | 폴더 | 역할 |
|---|---|---|
| 관리 | `~/projects/rapa` | 카드 추가·수정, 배포(push), 이슈, 도메인·검색엔진 설정 |

현재 세션은 이것 하나뿐이다. 별도 세션이 필요한 일(맥 빌드·실기기)은 없다.

## 에러 알림 경로
모든 에러는 슬랙 `#rapa-에러` 로 간다(채널 ID `C0C7X9G9L04`, 양식·현황은 `claude-common/docs/SLACK.md`).

| 어디서 나는 에러 | 무엇이 슬랙으로 보내는가 | 시험 |
|---|---|---|
| GitHub Pages 빌드 실패 | `.github/workflows/pages-alert.yml` (`page_build` 트리거, `errored` 일 때만) | `gh workflow run pages-alert.yml -f simulate=errored` → run 41081976888 success (2026-10-30). **슬랙 도착 확인됨** — `#rapa-에러` 에 시험 메시지(커밋 f29c7de) 2026-10-31 00:34 KST 도착, 2026-11-04 슬랙 채널 직접 조회 → **연결됨** |
| Actions 워크플로 실패 | 워크플로가 `pages-alert` 뿐이고 자체 실패 알림 없음 → **안 가는 것** (`SLACK_BOT_TOKEN` 만료·채널 변경 시 알림 스텝이 exit 1 로 실패하지만 그 실패는 알려지지 않는다) | — |
| 크래시·서버·Functions·배치 | 해당 없음 — 서버·앱·배치가 없는 정적 페이지 | — |
| 사이트 다운·인증서 만료 | 감시 없음 → **안 가는 것** (Pages 가 인증서를 자동 갱신하나 장애 알림은 없다) | — |

### 비용 출처 (`#rapa-마케팅수익`)
| 출처 | 상태 |
|---|---|
| GitHub Pages | 무료(public 저장소, GitHub Free 의 Pages)·확인일 2026-10-31. 대역폭 소프트 한도 월 100GB |
| Actions (`pages-alert`) | 무료(public 저장소는 Actions 분 무제한)·확인일 2026-10-31 |
| `rapa.world` 도메인 갱신 | 계정 단위 비용 — 프로젝트에 못 붙으므로 루트 `#rapa-마케팅수익` 에서 관리. 갱신일은 이 문서에 없음(미확인) |
| Google Fonts | 무료 |
