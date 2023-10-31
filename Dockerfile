FROM eclipse-temurin:17-jdk-alpine

VOLUME /tmp

COPY target/backend-0.0.1-SNAPSHOT.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-Dspring.profiles.active=test", "-jar", "app.jar"]
