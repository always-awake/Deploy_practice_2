# image python의 3.6.7 - slime 버전의 이미지로부터 레이어를 쌓을 것
FROM    python:3.6.7-slim

# 이 이미지의 운영체제(debian) 패키지 관리자 업데이트, 설치되어있는 패키지 업그레이드
RUN     apt -y update &&\
        apt -y dist-upgrade &&\
        # nginx - 웹 서버
        # supervisor - 프로세스 컨트롤 시스템
        # build-essential - uWSGI를 설치하기 위해 필요한 빌드용 패키지
        apt -y install nginx supervisor build-essential

# 여기까지 작성하고 nginx가 잘 설치되었는 지 확인한 후, 이후 작업 진행하기(git push 등..)

# uWSGI 설치
RUN     pip3 install uwsgi

# 여기까지 작성하고 uwsgi가 잘 설치되었는 지 확인 ~


# pip freeze >> requirements.txt 명령어로 현재 개발 환경에 설치된 python 모듈 목록 추출
# 해당 requirements.txt 파일을 이미지 속 /tmp 안에 복사해줌
# (이후, 이미지 내에서 해당 파일을 이용해 현재 개발 환경과 같은 환경을 한번에 구축 가능)
COPY    ./requirements.txt  /tmp/requirements.txt

# 여기까지 작성하고 docker run 하여 tmp안에 requirements.txt가 잘 copy되었는 지 확인 ~

# /tmp/requirements.txt에 기록된 내용을 이미지에 설치
# 웹 애플리케이션 프레임워크 Django 설치
RUN     pip3 install -r /tmp/requirements.txt
# pip3을 이용해서 requirements.txt에 있는 python 모듈을 한번에 모두 설치해준다.

# 소스코드를 복사
COPY    .   /srv/project/
#
RUN         cp -f   /srv/project/.config/app.conf \
                    /etc/nginx/sites-enabled/ &&\
            rm      /etc/nginx/sites-enabled/default

CMD         nginx && uwsgi --ini /srv/project/.config/uwsgi.ini