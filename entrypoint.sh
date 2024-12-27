# 파일명: entrypoint.sh
#!/bin/bash
# 이 스크립트는 Docker 컨테이너가 시작될 때 실행됩니다.

# 1. 환경 변수로 설정된 백엔드 URL을 기반으로 nginx 설정 파일을 생성합니다.

# $BACKEND_URL : 백엔드 서버의 주소와 포트를 설정하는 환경 변수입니다.
# envsubst : 환경 변수를 실제 값으로 치환해주는 명령어입니다.
#            예를 들어, '$BACKEND_URL'을 'http://localhost:8080'으로 변환합니다.
# nginx.conf.template : nginx 설정 파일의 템플릿 파일로, 변수 자리를 표시한 형태입니다.
# default.conf : 실제로 nginx에서 사용하는 최종 설정 파일입니다.
envsubst '$BACKEND_URL' < /etc/nginx/templates/nginx.conf.template > /etc/nginx/conf.d/default.conf

# 2. nginx 서버를 시작합니다.
# nginx -g "daemon off;" : nginx를 포그라운드(foreground)에서 실행하여 컨테이너가 종료되지 않도록 합니다.
#                            (Docker 컨테이너는 포그라운드 프로세스가 없으면 자동 종료됩니다.)
nginx -g "daemon off;"