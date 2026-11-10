# OPS — 에러·비용 알림 경로

모든 에러는 슬랙 `#rapa-에러` 로 간다(양식·현황은 `claude-common`).

| 어디서 나는 에러 | 무엇이 슬랙으로 보내는가 | 시험 |
|---|---|---|
| GitHub Pages 빌드 실패 | `.github/workflows/pages-alert.yml` (`page_build` 트리거, `errored` 일 때만) | `gh workflow run pages-alert.yml -f simulate=errored` → **연결됨**(2026-10-31 도착 확인) |
| Actions 워크플로 실패 | `.github/workflows/workflow-fail-alert.yml` (`workflow_run` 으로 `pages-alert` 실패 감시 → 슬랙). 슬랙 전송까지 실패하면(토큰 만료·채널 변경) 같은 경로라 못 가므로 저장소 이슈를 열어 GitHub 알림으로 남긴다. 워크플로를 추가하면 감시 목록에 이름을 더한다 | `gh workflow run workflow-fail-alert.yml -f simulate=failure` → **main 병합 후 도착 확인 전까지 미연결** (`workflow_run` 은 기본 브랜치 파일만 발화) |
| 크래시·서버·Functions·배치 | 해당 없음 — 서버·앱·배치가 없는 정적 페이지 | — |
| 사이트 다운·인증서 만료 | 감시 없음 → **안 가는 것** (Pages 가 인증서를 자동 갱신하나 장애 알림은 없다) | — |

### 비용 출처 (`#rapa-마케팅수익`)
| 출처 | 상태 |
|---|---|
| GitHub Pages | 무료(public 저장소, GitHub Free 의 Pages)·확인일 2026-10-31. 대역폭 소프트 한도 월 100GB |
| Actions (`pages-alert`) | 무료(public 저장소는 Actions 분 무제한)·확인일 2026-10-31 |
| `rapa.world` 도메인 갱신 | 계정 단위 비용 — 프로젝트에 못 붙으므로 루트 `#rapa-마케팅수익` 에서 관리. 갱신일은 이 문서에 없음(미확인) |
| Google Fonts | 무료 |

