# OPS — 에러·비용 알림 경로

모든 에러는 슬랙 `#rapa-에러` 로 간다(양식·현황은 `claude-common`).

| 어디서 나는 에러 | 무엇이 슬랙으로 보내는가 | 시험 |
|---|---|---|
| GitHub Pages 빌드 실패 | `.github/workflows/pages-alert.yml` (`page_build` 트리거, `errored` 일 때만) | `gh workflow run pages-alert.yml -f simulate=errored` → **연결됨**(2026-10-31 도착 확인) |
| Actions 워크플로 실패 | `.github/workflows/workflow-fail-alert.yml` (`workflow_run` 으로 `pages-alert`·`site-watch` 실패 감시 → 슬랙). 슬랙 전송까지 실패하면(토큰 만료·채널 변경) 같은 경로라 못 가므로 저장소 이슈를 열어 GitHub 알림으로 남긴다. 워크플로를 추가하면 감시 목록에 이름을 더한다 | `gh workflow run workflow-fail-alert.yml -f simulate=failure` → **연결됨**(2026-11-22 시험 발송 run 44923572501 `#rapa-에러` 도착 확인. `workflow_run` 은 기본 브랜치 파일만 발화 — 실제 실패 연쇄 발화는 미시험) |
| 크래시·서버·Functions·배치 | 해당 없음 — 서버·앱·배치가 없는 정적 페이지 | — |
| 사이트 다운·인증서 만료 | `.github/workflows/site-watch.yml` (6시간마다 HTTP 200·인증서 잔여 14일 점검, 문제 시 슬랙) | `gh workflow run site-watch.yml -f simulate=down` → **확인됨**(2026-11-22 16:23 KST, run 44998036007 `simulate=down` → `#rapa-에러` 에 「사이트 점검 실패 (시험 전송)」 1건 도착·workflow-fail-alert skipped·이중 알림 없음). 점검 실패가 스텝에 전달되도록 `shell: bash`·`continue-on-error`·`steps.check.outcome` 조건으로 고쳤고 파이프 시험은 `.github/scripts/test-check-site.sh`(이슈 #10·#20) |

### 루트 채널 연결 확인 (2026-11-22, 이슈 #17)
- `#rapa-에러`: claude-common `tests.yml` 실패(2026-11-19 14:38 도착)·`store-rank` 셸 단계 실패 시험(2026-11-04 도착) 확인.
- `#rapa-운영이벤트`: claude-common `daily-report` 도착 확인(2026-10-27~29 일일 보고). 최근 날짜 도착은 미확인 — 소유는 claude-common.
- 이 채널 발송 경로의 소유는 claude-common(`docs/SLACK.md`) — 그쪽 기록은 해당 프로젝트 세션 몫.

### 비용 출처 (`#rapa-마케팅수익`)
| 출처 | 상태 |
|---|---|
| GitHub Pages | 무료(public 저장소, GitHub Free 의 Pages)·확인일 2026-10-31. 대역폭 소프트 한도 월 100GB |
| Actions (`pages-alert`·`site-watch`) | 무료(public 저장소는 Actions 분 무제한)·확인일 2026-10-31 |
| `rapa.world` 도메인 갱신 | 계정 단위 비용 — 프로젝트에 못 붙으므로 루트 `#rapa-마케팅수익` 에서 관리. 갱신일은 이 문서에 없음(미확인) |
| Google Fonts | 무료 |

