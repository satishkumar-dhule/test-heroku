FROM eclipse-temurin:17-jdk-jammy

WORKDIR /app

# Copy the Maven files first for better caching
COPY pom.xml .
COPY .mvn/ .mvn/
COPY mvnw .
COPY mvnw.cmd .

# Copy the source code
COPY src/ src/

# Build the application
RUN ./mvnw package -DskipTests

# Use the same Jetty runner setup as Heroku
FROM eclipse-temurin:17-jre-jammy

WORKDIR /app

# Copy the built war file and dependencies
COPY --from=0 /app/target/*.war /app/
COPY --from=0 /app/target/dependency/jetty-runner.jar /app/jetty-runner.jar

EXPOSE 8080

# Use similar command as in Procfile but with fixed port
CMD ["java", "-jar", "jetty-runner.jar", "--port", "8080", "*.war"]
