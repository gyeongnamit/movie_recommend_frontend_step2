# 파일명: Dockerfile
# Docker 이미지를 생성하는 설정 파일입니다.

# 1단계: React 애플리케이션 빌드
# Node.js 16 버전의 이미지 사용
# - Node.js는 JavaScript 실행 환경으로, React 애플리케이션을 빌드하는 데 필요합니다.
FROM node:16 AS builder 

# 작업 디렉터리를 /app으로 설정
# - 모든 명령어는 /app 디렉터리에서 실행됩니다.
WORKDIR /app 

# 의존성 설치
# - 프로젝트의 의존성 목록(package.json과 yarn.lock)을 복사합니다.
COPY package.json yarn.lock ./ 

# 필요한 패키지 설치 및 axios 추가
# - yarn install: package.json에 정의된 패키지를 설치합니다.
# - yarn add axios: axios(HTTP 요청 라이브러리)를 추가로 설치합니다.
RUN yarn install && yarn add axios 

# 현재 디렉터리의 모든 파일을 컨테이너로 복사
# - 소스 코드와 구성 파일을 복사합니다.
COPY . . 

# React 애플리케이션 빌드
# - 소스를 압축 및 최적화하여 배포 가능한 상태로 만듭니다.
RUN yarn build 

# 2단계: nginx로 배포 설정
# - nginx는 웹 서버로, React 빌드 결과물을 제공하는 역할을 합니다.
FROM nginx:1.23-alpine 

# nginx 템플릿 파일을 위한 작업 디렉터리 설정
# - nginx 설정 파일(template)을 저장할 디렉터리를 작업 디렉터리로 설정합니다.
WORKDIR /etc/nginx/templates 

# 패키지 설치 및 설정
# - nginx 구동을 위한 추가 패키지 설치
RUN apk update && apk add --no-cache bash gettext && rm -rf /var/cache/apk/*
# bash : 쉘 스크립트 실행을 위한 패키지
# gettext : envsubst 명령어를 제공하는 패키지로, 환경 변수 치환을 지원합니다.

# 빌드한 파일 복사
# - React 애플리케이션의 빌드 결과물을 nginx의 기본 경로에 복사합니다.
COPY --from=builder /app/build /usr/share/nginx/html 

# nginx 설정 템플릿 복사
# - 환경 변수 치환을 지원하는 템플릿 파일을 복사합니다.
COPY nginx.conf.template /etc/nginx/templates/nginx.conf.template 

# 시작 스크립트 복사
# - nginx 설정을 적용하고 서버를 시작하는 스크립트를 복사합니다.
COPY entrypoint.sh /entrypoint.sh 

# 시작 스크립트의 줄바꿈 형식 변환
# - Windows와 Linux의 줄바꿈 형식 차이를 해결합니다.
RUN dos2unix /entrypoint.sh

# 시작 스크립트에 실행 권한 추가
# - 스크립트 실행을 위해 실행 권한을 부여합니다.
RUN chmod +x /entrypoint.sh 

# 엔트리포인트 설정
# - 컨테이너가 시작될 때 /entrypoint.sh 스크립트를 실행합니다.
ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]
