# ==========================================================
# Stage 1 - Build the application
# ==========================================================
FROM maven:3.9-eclipse-temurin-8 AS build

WORKDIR /app

# Copy pom.xml first so Maven dependencies can be cached
COPY pom.xml .

# Download dependencies
RUN mvn dependency:go-offline -B

# Copy application source
COPY src ./src

# Build the WAR
RUN mvn clean package -DskipTests


# ==========================================================
# Stage 2 - Run the application
# ==========================================================
FROM tomcat:9-jre8-temurin

# Remove default Tomcat applications
RUN rm -rf /usr/local/tomcat/webapps/*

# Deploy the application as ROOT so it is available at /
COPY --from=build /app/target/helloworld.war \
    /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080

CMD ["catalina.sh", "run"]
