# rapa (rapa.world 루트)

정적 랜딩 — 출시·준비 중·개발 중·기획 중 서비스를 한곳에 소개하는 허브(카드 목록은 `index.html` 의 `SERVICES`). 저장소 `fready-hub/fready-hub.github.io`(GitHub 사용자 사이트, 폴더명과 다름), Pages 소스 `main` `/`, 커스텀 도메인 `rapa.world`(`CNAME`).

**이 저장소는 공개다** — 운영 규칙·인계 문서·내부 경로·승인 절차 세부를 두지 않는다. 공통 CLAUDE.md 를 따른다. 시작할 때 읽는 것은 이 파일과 docs/STATE.md 뿐.

## 규칙 요약
- **main push = Pages 배포(곧 `rapa.world`)** — 작업 브랜치에서 확인한 뒤 머지·push. 원격에 옛 `master` 가 남아 있다(Pages 소스 아님).
- 빌드·패키지 없음(`index.html` + `assets/`). 대장 없음 — 링크 검증으로 대신. 진행 문서 없음 — `git log` 가 기록.
- 외부에 등록하는 주소는 `rapa.world` 만(`fready-hub.github.io` 는 301).
- 서비스 카드를 바꾸면 스토어 링크 200 을 먼저 본다. 카드 상태 기준·순서 규칙은 [.claude/rules/cards.md](.claude/rules/cards.md) — 사용자가 정한 표시가 기준보다 우선하고, 통보 없이 바꾸지 않는다.

## 검증
⚠️ **bash 로 돌린다**(`bash -euo pipefail -c '…'`). 맥 기본 zsh 는 `$urls` 를 단어로 쪼개지 않아 `000` 한 줄만 나온다.
```bash
urls=$(grep -oE "https://[^\"' <)\`]+" index.html | grep -v -E 'fonts\.|\$\{' | sort -u); test -n "$urls"
for u in $urls; do echo "$u $(curl -s -L -o /dev/null -w '%{http_code}' --max-time 15 "$u")"; done
curl -s -o /dev/null -w '%{http_code} %{ssl_verify_result}\n' https://rapa.world/   # 200 0
```
전체 블록·로컬 서빙·Pages 상태는 [docs/RELEASE.md](docs/RELEASE.md). 새 서브도메인이 로컬에서만 실패하면 Mac DNS 음성 캐시 — 공용 DNS 로 판정(cards.md). 타입체크·빌드 없음.

## 건드리면 안 되는 경로
- `CNAME` — 지우거나 바꾸면 `rapa.world` 연결이 끊긴다.
- `_config.yml` — `CLAUDE.md` 등 내부 문서를 배포에서 뺀다(2026-11-07, `https://rapa.world/CLAUDE.md` 공개 문제). 지우면 다시 공개된다.
- `.github/workflows/pages-alert.yml` — Pages 실패 알림. 채널 ID·시크릿 이름을 바꾸면 알림이 조용히 끊긴다.
- `robots.txt`·`sitemap.xml` — 검색엔진 등록(네이버 소유 확인 메타 포함). 호스트는 `rapa.world` 유지.
- 서비스 카드의 스토어 링크·`referrer` utm 파라미터 — 유입 측정용, 임의 변경 금지.

## 문서 지도
| 문서 | 내용 |
|---|---|
| [docs/STATE.md](docs/STATE.md) | 현재 상태 |
| [docs/RELEASE.md](docs/RELEASE.md) | 배포·검증 전체 |
| [docs/OPS.md](docs/OPS.md) | 에러·비용 알림 경로 |
| [.claude/rules/cards.md](.claude/rules/cards.md) | 카드 상태 갱신 기준(index.html 을 건드릴 때) |
