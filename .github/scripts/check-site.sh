#!/usr/bin/env bash
# 사이트 가용성·인증서 만료 점검. 문제가 있으면 사유를 출력하고 비0 으로 끝난다.
# 사용: check-site.sh <호스트> (환경: MIN_DAYS=인증서 최소 잔여일, 기본 14)
set -uo pipefail
host=${1:?host}; min=${MIN_DAYS:-14}; rc=0
code=$(curl -s -L -o /dev/null -w '%{http_code}' --max-time 20 --retry 2 --retry-delay 5 "https://$host/") || true
[ "$code" = 200 ] || { echo "HTTP $code (기대 200)"; rc=1; }
cert=$(echo | openssl s_client -servername "$host" -connect "$host:443" 2>/dev/null | openssl x509 2>/dev/null)
if [ -z "$cert" ]; then echo "인증서를 읽지 못함"; rc=1
elif ! echo "$cert" | openssl x509 -noout -checkend $((min * 86400)) >/dev/null; then
  echo "인증서가 ${min}일 안에 만료 (만료일 $(echo "$cert" | openssl x509 -noout -enddate | cut -d= -f2))"; rc=1
fi
[ $rc -eq 0 ] && echo "$host 정상 (HTTP $code, 인증서 ${min}일 이상 유효)"
exit $rc
