FROM openjdk:14

ENV OAUTH_CONFIG_PATH="~/config/application-oauth.properties";

WORKDIR /app
COPY . .

RUN ./gradlew test

RUN ./gradlew build

RUN cp "./build/libs/spring-aws-practice-1.0-SNAPSHOT.jar" /app/bin
EXPOSE 8080
ENTRYPOINT java -jar \
-Dspring.profiles.active=prod \
"/app/bin/spring-aws-practice-1.0-SNAPSHOT.jar"
