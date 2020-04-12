#!/bin/bash

REPOSITORY=/home/ec2-user/ec2/app/step2
PROJECT_NAME=springboots-webservice

echo ">Build 파일 복사"
cp $REPOSITORY/zip/*.jar $REPOSITORY/

echo ">현재 구동중인 애플리케이션 pid 확인"

CURRENT_PID=$(pgrep -fl spirngboot2-webservice | grep jar | awk '{print $1}')

echo ">현재 구동죽인 pid : $CURRENT_PID"

if[-z "$CURRENT_PID"];then
    echo">현재 구동중인 애플리케이션이 없으므로 종료하지 않습니다."
else
    echo">kill -15  CURRENT_PID"
    kill -15 $CURRENT_PID
    sleep -5
fi

echo">새애플리케이션 배포"

JAR_NAME=$(ls -tr $REPOSITORY/*.jar | tail -n -1)

echo">JAR_NAME= $JAR_NAME"

echo">$JAR_NAME에 실행 권한 추가"

chmod +x $JAR_NAME

echo ">$JAR_NAME 실행"

nohub java -jar \
    -Dspring.config.location=classpath:/application.properties,classpath:/appplication-real.properties,/home/ec2-user/ec2/app/application-oauth.properties,/hoem/ec2-user/ec2/app/application-real-db.properties \
    -Dspring.profiles.active=real \
    $JAR_NAME > $REPOSITORY/nohub.out 2>&1 &
