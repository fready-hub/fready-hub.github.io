# RELEASE — 배포·검증

- 빌드·패키지 없음. `index.html` 한 파일 + `assets/` + `CNAME`·`robots.txt`·`sitemap.xml`. Node·nvm 불필요.
- `main` 에 push 하면 곧 `rapa.world` 에 배포된다(Pages). 그래서 작업 브랜치에서 확인한 뒤 머지·push 한다.
- `fready-hub.github.io` 는 `rapa.world` 로 301 리다이렉트된다. 외부에 등록하는 주소는 `rapa.world` 만 쓴다.
- 서비스 카드를 추가·변경하면 스토어 링크가 200 인지 먼저 본다(아래 검증).

⚠️ **bash 로 돌린다**(`bash -euo pipefail -c '…'`). 맥 기본 셸 zsh 는 `$urls` 를 단어로 쪼개지 않아 전체가 URL 하나로 묶여 `000` 한 줄만 나온다(2026-11-06 실측).
```bash
set -euo pipefail
# 저장소 루트에서 실행
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
