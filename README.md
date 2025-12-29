## This provides Uril3GM IPInside LWS Daemon's Dependency fixed *.deb for Debian 13
## 이것은 데비안 13을 위해 의존성이 수정된 Uril3GM IPInside LWS 데몬 패치 파일을 제공합니다.

은행사에서 제공하는 Uril3GM은 Ubuntu 22.04를 위한 control 섹션이 포함되어있으나, 데비안 13에서는 이것과 조금 다릅니다.
최신 릴리즈인 데비안 13은 `policykit-1` 패키지를 `polkitd`라는 이름으로 제공합니다.
그러나 그 부분의 의존성과 `cert8.db`의 SQL 로드 명령에서 `sql:`의 누락만 채우면 데비안 파이어폭스에서 경고 메시지를 제외하면 정상적으로 인증이 진행됩니다.

이렇게 적용하면 최신 데비안 GNU/리눅스에서도 한국 금융 서비스가 됩니다.
