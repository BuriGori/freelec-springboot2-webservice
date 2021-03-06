CURRENT_PORT=$(cat /homr/ec2-user/service_url.inc | grep -Po '[0-9]+' | tail -1)
TARGET_PORT=0

echo "> CURRENT PORT of running WAS is ${CURRENT_PORT}."

if [ ${CURRENT_PORT} -eq 8080 ]; then
  TARGET_PORT=8081
elif [ ${CURRENT_PORT} -eq 8081]; then
  TARGET_PORT=8080
else
  echo "> No WAS is connected to nginx"
fi

TARGET_PID=$(lsof -Fp -i TCP:${TARGET_PORT} | grep -Po 'p[0-9]+' | grep -Po '[0-9]+')

if [ ! -z ${TARGET_PID} ]; then
  echo "> Kill WAS running at ${TARGET_PORT}"
  sudo kill ${TARGET_PID}
fi

nohup java -jar -Dserver.port=${TARGET_PORT} /home/ec2-uesr/freelec-springboot2-webservice/build/libs/* > /home/ec2-user/nohup.out 2>&1 &
echo "> Now new WAS runs at ${TARGET_PORT}"
exit 0