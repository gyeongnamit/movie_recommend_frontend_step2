# 파일명: Dockerfile
# Docker 이미지를 생성하는 설정 파일입니다.

# 1단계: React 애플리케이션 빌드
# Node.js 16 버전의 이미지 사용
FROM node:16 AS builder 
# 작업 디렉터리를 /app으로 설정
WORKDIR /app 

# 의존성 설치
# package.json과 yarn.lock 파일을 복사
COPY package.json yarn.lock ./ 
# 필요한 패키지 설치 및 axios 추가
RUN yarn install && yarn add axios 
# 현재 디렉터리의 모든 파일을 컨테이너로 복사
COPY . . 
# React 애플리케이션 빌드
RUN yarn build 

# 2단계: nginx로 배포 설정
# 경량 nginx 이미지를 사용합니다.
FROM nginx:1.23-alpine 
# nginx 템플릿 파일을 위한 작업 디렉터리 설정
WORKDIR /etc/nginx/templates 

# 패키지 설치 및 설정
RUN apk update && apk add --no-cache bash gettext && rm -rf /var/cache/apk/*
# bash : 쉘 스크립트 실행을 위한 패키지
# gettext : envsubst 명령어를 제공하는 패키지

# 빌드한 파일 복사
# 빌드된 정적 파일을 nginx 루트 디렉터리에 복사
COPY --from=builder /app/build /usr/share/nginx/html 
# nginx 설정 템플릿 복사
COPY nginx.conf.template /etc/nginx/templates/nginx.conf.template 
# 시작 스크립트 복사
COPY entrypoint.sh /entrypoint.sh 
# 시작 스크립트에 실행 권한 추가
RUN chmod +x /entrypoint.sh 

# 컨테이너의 80번 포트를 호스트에 노출
EXPOSE 80 
# 컨테이너 시작 시 entrypoint.sh 실행
CMD ["/entrypoint.sh"] 

