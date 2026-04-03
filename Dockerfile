FROM eclipse-temurin:25-jdk

LABEL maintainer="richardhogan"
LABEL description="Valent PriceWell - Grails 7 application"

# Install git for cloning the repo
RUN apt-get update && apt-get install -y git && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Clone the latest code from GitHub
ARG REPO_URL=https://github.com/richardhogan/valent-pricewell.git
ARG BRANCH=master
RUN git clone --branch ${BRANCH} --single-branch ${REPO_URL} .

# Make Gradle wrapper executable
RUN chmod +x gradlew

# Clean compile all source
RUN ./gradlew clean :pricewell:compileGroovy --no-daemon

# Expose the application port
EXPOSE 8080

# JVM flags required for JAXB (docx4j 3.0.0) on Java 17+
ENV JAVA_OPTS="--add-opens java.base/java.lang=ALL-UNNAMED \
--add-opens java.base/java.lang.reflect=ALL-UNNAMED \
--add-opens java.base/java.io=ALL-UNNAMED \
--add-opens java.base/java.util=ALL-UNNAMED \
--add-opens java.base/java.text=ALL-UNNAMED \
--add-opens java.desktop/java.awt.font=ALL-UNNAMED"

# Start the application
# Use bootRun for dev; for production use bootJar and java -jar
CMD ["./gradlew", ":pricewell:bootRun", "--no-daemon"]
