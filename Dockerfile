# Base image for Jenkins
FROM jenkins/jenkins:lts

# Switch to root user to install dependencies
USER root

# Copy pre-downloaded Java and Maven tar.gz files to the Docker image
# Assuming you have the tar.gz files in the same directory as your Dockerfile
COPY zulu11.74.15-ca-jdk11.0.24-linux_x64.tar.gz /tmp/
COPY apache-maven-3.9.9-bin.tar.gz /tmp/

# Install necessary utilities
RUN apt-get update && \
    apt-get install -y curl git unzip wget tini && \
    rm -rf /var/lib/apt/lists/*

# Install Java from the tar.gz file
RUN mkdir -p /usr/lib/jvm && \
    tar -xzf /tmp/zulu11.74.15-ca-jdk11.0.24-linux_x64.tar.gz -C /usr/lib/jvm && \
    ln -s /usr/lib/jvm/jdk-11.0.24 /usr/lib/jvm/zulu11.74.15-ca-jdk11.0.24-linux_x64 && \
    rm /tmp/zulu11.74.15-ca-jdk11.0.24-linux_x64.tar.gz

# Set environment variables for Java
ENV JAVA_HOME=/usr/lib/jvm/zulu11.74.15-ca-jdk11.0.24-linux_x64
ENV PATH="$JAVA_HOME/bin:$PATH"

# Install Maven from the tar.gz file
RUN mkdir -p /opt/maven && \
    tar -xzf /tmp/apache-maven-3.9.9-bin.tar.gz -C /opt/maven && \
    ln -s /opt/maven/apache-maven-3.9.9 /opt/maven/latest && \
    ln -s /opt/maven/latest/bin/mvn /usr/bin/mvn && \
    rm /tmp/apache-maven-3.9.9-bin.tar.gz

# Set environment variables for Maven
ENV MAVEN_HOME=/opt/maven/latest
ENV PATH="$MAVEN_HOME/bin:$PATH"

# Install Flutter
ARG FLUTTER_VERSION=flutter-3.19-candidate.6
RUN git clone https://github.com/flutter/flutter.git /opt/flutter \
    && cd /opt/flutter && git checkout ${FLUTTER_VERSION} \
    && ln -s /opt/flutter/bin/flutter /usr/bin/flutter \
    && flutter precache

# Give permission for the jenkins user
RUN chown -R jenkins:jenkins /opt/flutter && \
    chmod -R 755 /opt/flutter

# Set Environment Variables for Flutter
ENV PATH="$PATH:/opt/flutter/bin"

# Switch back to Jenkins user
USER jenkins

# Expose Jenkins port
EXPOSE 8080

# Start Jenkins
ENTRYPOINT ["/usr/bin/tini", "--", "/usr/local/bin/jenkins.sh"]