FROM openjdk:14

ENV CONFIG_PATH="/config/";

WORKDIR /app
COPY . .

RUN ./gradlew test

RUN ./gradlew build

RUN mkdir /app/bin/
RUN cp "./build/libs/spring-aws-practice-1.0-SNAPSHOT.jar" /app/bin/
EXPOSE 8080
ENTRYPOINT java -jar \
-Dspring.config.location=$CONFIG_PATH \
-Dspring.profiles.active=prod \
"/app/bin/spring-aws-practice-1.0-SNAPSHOT.jar"
