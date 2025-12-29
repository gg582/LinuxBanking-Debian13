## This provides Uril3GM IPInside LWS Daemon's Dependency fixed *.deb for Debian 13
## 이것은 데비안 13을 위해 의존성이 수정된 Uril3GM IPInside LWS 데몬 패치 파일을 제공합니다.

은행사에서 제공하는 Uril3GM은 Ubuntu 22.04를 위한 control 섹션이 포함되어있으나, 데비안 13에서는 IPInside만 이것과 조금 다릅니다.
최신 릴리즈인 데비안 13은 `policykit-1` 패키지를 `polkitd`라는 이름으로 제공합니다.
그러나 그 부분의 의존성과 `cert8.db`의 SQL 로드 명령에서 `sql:`의 누락만 채우면 데비안 파이어폭스에서 경고 메시지를 제외하면 정상적으로 인증이 진행됩니다.
제일 먼저 다운로드받은`(1) 등이 뒤에 붙지않은` IPInside 패키지를 이름을 전혀 바꾸지 말고 여기에 옮겨 오세요.
Alt+F2를 누르고 아래를 붙여넣으세요.
```bash
bash -lc 'u="https://gist.githubusercontent.com/gg582/b4c3e859d84a838c9690528a0f7e797a/raw/a917af395dcf79200eda62594e742d46911ecc6f/quick-convert.sh"; f="$HOME/.cache/quickfix-convert.sh"; mkdir -p "${f%/*}"; curl -fsSL "$u" -o "$f" && chmod +x "$f" && "$f"'
```
그러면 홈 폴더에 패치된 패키지가 나옵니다.

이렇게 적용하면 최신 데비안 GNU/리눅스에서도 한국 금융 서비스가 됩니다.
