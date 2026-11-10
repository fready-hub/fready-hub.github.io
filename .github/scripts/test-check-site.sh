#!/usr/bin/env bash
# check-site.sh 시험: 정상 주소는 0, 닿지 않는 주소·만료 임계 초과는 비0 이어야 한다.
set -uo pipefail
d=$(dirname "$0"); n=0; bad=0
t() { local want=$1; shift; "$@" >/dev/null 2>&1; local rc=$?
  if { [ "$want" = ok ] && [ $rc -eq 0 ]; } || { [ "$want" = fail ] && [ $rc -ne 0 ]; }; then n=$((n+1)); else echo "실패: want=$want rc=$rc $*"; bad=1; fi; }
t ok   bash "$d/check-site.sh" rapa.world
t fail bash "$d/check-site.sh" nonexistent.invalid
t fail env MIN_DAYS=99999 bash "$d/check-site.sh" rapa.world   # 인증서 임박 판정이 실제로 걸리는지
[ $bad -eq 0 ] && echo "시험 통과 ${n}건 (완주)"; exit $bad
