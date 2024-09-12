# Custom Jenkins Image Repo

## Introduction

This repository provides a custom Docker image for Jenkins with Java 11, Maven 3.9.9, and Flutter 3.19.6 pre-installed. The image is configured with necessary environment variables. You can modify the versions of Maven, Java, and Flutter in the Dockerfile if needed.

## Build and Running

### Prerequisites

- Docker installed on your system.
- Download the required compatible Java and Maven versions if you wish to build with different versions.

### Build

To build the Docker image, run the following command from the project root directory:

```sh
docker build -t custom-jenkins-image .
```

This command will create a Jenkins image with Java, Maven, and Flutter pre-installed. The Dockerfile includes steps to copy Maven and Java into the image, and to download and install the specified version of Flutter.

### Building for Specific Architecture

If you need to build the image for a specific architecture, use Docker Buildx. This is useful if you are building on a different architecture than the target server.

1. **Ensure Docker Buildx is Set Up:**

   ```sh
   docker buildx create --use
   ```

2. **Build the Image for a Specific Architecture:**

   For example, to build for `linux/amd64`:

   ```sh
   docker buildx build --platform linux/amd64 -t custom-jenkins-image .
   ```

   Replace `linux/amd64` with the appropriate platform if needed (e.g., `linux/arm64` for ARM architecture).

### Post-Build Steps

After building the Docker image, you need to prepare the `jenkins_home` directory and set the correct permissions for Jenkins to run smoothly.

#### Create Directory and Set Permissions

Create a directory for Jenkins home in your preferred location and set the necessary permissions:

```sh
mkdir -p ~/jenkins_home
chmod -R 777 ~/jenkins_home
```

The `chmod -R 777` command ensures that Jenkins has full read/write/execute permissions on the directory. Adjust permissions according to your security needs.

### Run

To start the Jenkins server with the newly built image, use the following command:

```sh
docker run -d -p 9876:8080 -p 50000:50000 -v ~/jenkins_home:/var/jenkins_home custom-jenkins-image
```

This command runs Jenkins in detached mode (`-d`), maps port 9876 on your host to port 8080 in the container, and maps the `~/jenkins_home` directory to `/var/jenkins_home` in the container.

Once the Jenkins server is running, it will be accessible at port 9876 of your server. On first login, you will be prompted for the initial admin password. You can find this password at the following location:

```sh
~/jenkins_home/secrets/initialAdminPassword
```

### Viewing Logs

To view logs from the running Jenkins container, use the `docker logs` command:

```sh
docker logs <container_id>
```

Replace `<container_id>` with the ID or name of your Jenkins container. You can find the container ID by listing all running containers:

```sh
docker ps
```

For real-time log streaming, use:

```sh
docker logs -f <container_id>
```

### Additional Notes

- **Modifying Versions:** To change the versions of Java, Maven, or Flutter, edit the Dockerfile and rebuild the image.
- **Security Considerations:** The `chmod -R 777` command provides full permissions to everyone. For better security, adjust the permissions to restrict access as needed.
- **Container Management:** Use `docker stop <container_id>` to stop the container and `docker rm <container_id>` to remove it. To restart the container, use `docker start <container_id>`.
- **Container Shell Access:** If you need to access the container’s shell for debugging or other purposes, use:

  ```sh
  docker exec -it <container_id> /bin/bash
  ```

- **Updating Jenkins Plugins:** After running Jenkins, you can manage plugins from the Jenkins dashboard under **Manage Jenkins** > **Manage Plugins**.


