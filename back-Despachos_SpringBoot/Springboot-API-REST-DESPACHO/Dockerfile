# --- Etapa de Compilación ---
FROM maven:3.9.6-eclipse-temurin-17-alpine AS build
WORKDIR /app

# Copiar el archivo POM y descargar dependencias (se aprovecha la caché de Docker)
COPY pom.xml .
RUN maven_opts="-XX:+TieredCompilation -XX:TieredStopAtLevel=1" mvn dependency:go-offline

# Copiar el código fuente y empaquetar
COPY src ./src
RUN mvn clean package -DskipTests

# --- Etapa de Ejecución ---
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app

# Crear un usuario de sistema no-root para ejecutar la aplicación de forma segura
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser

# Copiar el JAR compilado desde la etapa anterior
COPY --from=build --chown=appuser:appgroup /app/target/*.jar app.jar

# Exponer el puerto configurado (8081 en application.properties)
EXPOSE 8081

# Ejecutar la aplicación
ENTRYPOINT ["java", "-jar", "app.jar"]
