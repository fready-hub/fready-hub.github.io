#!/usr/bin/env bash
# check-site.sh 시험: 정상 주소는 0, 닿지 않는 주소·만료 임계 초과는 비0 이어야 한다.
set -uo pipefail
d=$(dirname "$0"); n=0; bad=0
t() { local want=$1; shift; "$@" >/dev/null 2>&1; local rc=$?
  if { [ "$want" = ok ] && [ $rc -eq 0 ]; } || { [ "$want" = fail ] && [ $rc -ne 0 ]; }; then n=$((n+1)); else echo "실패: want=$want rc=$rc $*"; bad=1; fi; }
t ok   bash "$d/check-site.sh" rapa.world
t fail bash "$d/check-site.sh" nonexistent.invalid
t fail env MIN_DAYS=99999 bash "$d/check-site.sh" rapa.world   # 인증서 임박 판정이 실제로 걸리는지
# 파이프 경로: 워크플로 점검 스텝과 같은 bash -e -o pipefail 에서 `false | tee` 가 실패로 전달돼야 한다
t fail bash -e -o pipefail -c 'false | tee /dev/null'
# 워크플로가 실제로 그 셸·실패 전달 설정을 쓰는지(없으면 사이트가 다운돼도 스텝이 성공한다)
y="$d/../workflows/site-watch.yml"
t ok grep -q 'shell: bash' "$y"
t ok grep -q 'continue-on-error: true' "$y"
t ok grep -q "if: steps.check.outcome == 'failure'" "$y"
t ok grep -q 'timeout-minutes: 5' "$y"
t ok grep -q 'contents: read' "$y"
[ $bad -eq 0 ] && echo "시험 통과 ${n}건 (완주)"; exit $bad
