# FROM openjdk:20-slim AS builder
# COPY App/ /App
# WORKDIR /App
# # Creates JAR File
# RUN ./mvnw package

# FROM openjdk:20-slim
# COPY  --from=builder /App/target/spring-petclinic-3.0.0-SNAPSHOT.jar ./app.jar
# USER nobody
# EXPOSE 8080
# CMD ["java", "-jar", "/app.jar"]

# Use a specific version to ensure reproducible builds
FROM openjdk:22-jdk-bullseye AS builder

# Update system packages
RUN apt-get update && apt-get upgrade -y && rm -rf /var/lib/apt/lists/*

COPY App/ /App
WORKDIR /App

# Creates JAR File
RUN ./mvnw package

FROM openjdk:22-jdk-bullseye
# Update system packages
RUN apt-get update && apt-get upgrade -y && rm -rf /var/lib/apt/lists/*

# Copy from builder
COPY  --from=builder /App/target/spring-petclinic-3.0.0-SNAPSHOT.jar ./app.jar

# Run as non-root
USER nobody

EXPOSE 8080

CMD ["java", "-jar", "/app.jar"]
