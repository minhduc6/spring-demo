FROM openjdk:11
ARG JAR_FILE
COPY ${JAR_FILE} app.jar
ENV PORT 8081
EXPOSE $PORT
ENTRYPOINT ["java","-jar","-Xmx1024M","-Dserver.port=${PORT}","app.jar"]