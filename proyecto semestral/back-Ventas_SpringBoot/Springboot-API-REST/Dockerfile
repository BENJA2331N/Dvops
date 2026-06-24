# Stage 1: Build Spring Boot app
FROM maven:3.9-eclipse-temurin-17 AS builder
WORKDIR /app
COPY pom.xml .
RUN mvn dependency:go-offline -B
COPY src ./src
RUN mvn package -DskipTests

# Stage 2: Run with JRE Alpine
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app

# Create non-root group and user
RUN addgroup -S spring && adduser -S spring -G spring

# Copy jar from builder stage
COPY --from=builder /app/target/*.jar app.jar

# Change ownership of the runtime files
RUN chown -R spring:spring /app

# Run as non-root user
USER spring

EXPOSE 8082

ENTRYPOINT ["java", "-jar", "app.jar"]
