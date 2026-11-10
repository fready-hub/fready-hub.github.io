# OPS — 에러·비용 알림 경로

모든 에러는 슬랙 `#rapa-에러` 로 간다(양식·현황은 `claude-common`).

| 어디서 나는 에러 | 무엇이 슬랙으로 보내는가 | 시험 |
|---|---|---|
| GitHub Pages 빌드 실패 | `.github/workflows/pages-alert.yml` (`page_build` 트리거, `errored` 일 때만) | `gh workflow run pages-alert.yml -f simulate=errored` → **연결됨**(2026-10-31 도착 확인) |
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

