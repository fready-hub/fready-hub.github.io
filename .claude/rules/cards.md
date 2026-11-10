---
paths:
  - "index.html"
  - "assets/*"
  - "sitemap.xml"
  - "robots.txt"
---
## 카드 상태 갱신
`SERVICES` 의 `status` 값(`STATUS_LABEL`): `soon` 출시 준비 중 · `dev` 개발 중 · `plan` 기획 중 · 이 셋이 없으면 출시.
- **기준**: 스토어 심사 제출까지는 `soon`, 스토어 공개(링크 200)가 확인되면 출시로 바꾸고 `play`·`appstore` 링크를 단다.
- ⚠️ **사용자가 따로 정한 표시가 기준보다 우선한다.** 옜다는 Play 에 공개돼 있지만 기능·디자인 수정이 많아 `dev` 로 둔다(2026-11 사용자 결정) — 기준만 보고 출시로 바꾸지 않는다. 바꾸려면 사용자에게 묻는다.
- **트리거**: 각 앱의 출시·상태 변경 소식. 통보 없이 바꾸지 않는다. 갱신 전에 새 스토어 링크가 200 인지 위 검증으로 본다.
- 카드 순서는 사용자 결정이다(아이키·코코세이버·아이타임·구구단·토닥·옜다·카드세이버). 새 카드의 자리는 묻는다.

- **Mac 로컬 DNS 는 새 서브도메인을 음성 캐시한다** — 방금 만든 `*.rapa.world` 가 로컬에서만 실패할 수 있다(카드세이버 링크에서 헛짚을 뻔했다). 판정은 공용 DNS 로 한다:
  `ip=$(dig +short @8.8.8.8 <host> A | tail -1)` → `curl -s -o /dev/null -w '%{http_code}\n' --resolve <host>:443:$ip https://<host>/`
- **카톡 미리보기는 카카오 캐시다** — `og:image`·제목을 바꿔 배포해도 바로 안 바뀐다. 초기화는 사용자가 https://developers.kakao.com/tool/debugger/sharing 에 로그인해 `https://rapa.world/` 를 넣고 캐시 초기화한다(배포 뒤 「변한 게 없다」 는 대개 이것).
