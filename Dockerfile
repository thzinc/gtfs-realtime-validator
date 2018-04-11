FROM maven:3-jdk-8 as build
WORKDIR /build
COPY ./pom.xml ./
COPY ./gtfs-realtime-validator-lib/pom.xml ./gtfs-realtime-validator-lib/
COPY ./gtfs-realtime-validator-webapp/pom.xml ./gtfs-realtime-validator-webapp/
RUN mvn verify --fail-never

COPY . .
RUN mvn package

FROM openjdk:8-jre-alpine as final
WORKDIR /app
COPY --from=build /build/gtfs-realtime-validator-webapp/target/gtfs-realtime-validator-webapp-1.0.0-SNAPSHOT.jar ./

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "gtfs-realtime-validator-webapp-1.0.0-SNAPSHOT.jar"]
# CMD ["-Djsse.enableSNIExtension=false"]