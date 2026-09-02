# Pintos Docker Environment Setup Guide (Fedora)

This guide documents the complete setup and workflow for developing **Pintos OS** inside a Docker container on **Fedora Linux**.

---

# Project Directory

The Pintos project is stored at:

```text
/mnt/newvolume/Acadamic/Labs/3rdSem/OSLabs/
```

The project structure is:

```text
OSLabs/
├── Dockerfile
└── pintos/
    ├── doc/
    ├── src/
    ├── LICENSE
    └── ...
```

---

# Docker Image

The Docker image uses **Ubuntu 18.04**, matching the environment recommended by the Pintos documentation.

## Dockerfile

Create a file named **Dockerfile** inside:

```text
/mnt/newvolume/Acadamic/Labs/3rdSem/OSLabs/
```

with the following contents:

```dockerfile
FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    build-essential \
    automake \
    git \
    libncurses5-dev \
    texinfo \
    perl \
    qemu \
    gdb \
    cgdb \
    ctags \
    cscope \
    python \
    wget \
    vim \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace
```

---

# Build the Docker Image

Navigate to the project directory:

```bash
cd /mnt/newvolume/Acadamic/Labs/3rdSem/OSLabs
```

Build the Docker image:

```bash
docker build -t pintos-env .
```

This only needs to be done once.

---

# Create the Docker Container

Run:

```bash
docker run -it \
--name pintos \
-v /mnt/newvolume/Acadamic/Labs/3rdSem/OSLabs/pintos:/workspace/pintos \
pintos-env
```

The Pintos source code is now mounted inside the container at:

```text
/workspace/pintos
```

---

# Build the Toolchain

Inside the Docker container:

```bash
cd /workspace/pintos/src

mkdir -p /workspace/toolchain

misc/toolchain-build.sh /workspace/toolchain
```

This process may take **30–60 minutes**.

---

# Configure PATH

Temporarily:

```bash
export PATH=/workspace/toolchain/x86_64/bin:$PATH
```

Verify:

```bash
i386-elf-gcc --version
```

---

# Make PATH Permanent

Instead of exporting every time, run:

```bash
echo 'export PATH=/workspace/toolchain/x86_64/bin:$PATH' >> ~/.bashrc
source ~/.bashrc
```

Now every new shell will automatically find the toolchain.

---

# Install Pintos Utility Scripts

```bash
cd /workspace/pintos/src/utils

make
```

Copy the utilities:

```bash
cp backtrace pintos Pintos.pm pintos-gdb \
pintos-set-cmdline pintos-mkdisk \
setitimer-helper squish-pty squish-unix \
/workspace/toolchain/x86_64/bin
```

Copy GDB macros:

```bash
mkdir -p /workspace/toolchain/x86_64/misc

cp ../misc/gdb-macros \
/workspace/toolchain/x86_64/misc
```

---

# Build Pintos

```bash
cd /workspace/pintos/src/threads

make clean
make
```

---

# Run Pintos

```bash
cd build

pintos --
```

Expected output:

```text
Pintos booting with 3,968 kB RAM...
367 pages available in kernel pool.
367 pages available in user pool.
Calibrating timer...
Boot complete.
```

---

# Successful Installation

If you see:

```text
Boot complete.
```

then everything is working correctly.

This means:

- ✅ The `i386-elf` cross-compiler is installed correctly.
- ✅ Pintos compiled successfully.
- ✅ QEMU is working correctly.
- ✅ Pintos booted successfully.

---

# Daily Workflow

Every time you want to work on Pintos:

## 1. Start the container

```bash
docker start -ai pintos
```

---

## 2. Go to the source directory

```bash
cd /workspace/pintos/src/threads
```

---

## 3. Rebuild

```bash
make clean
make
```

---

## 4. Run Pintos

```bash
cd build

pintos --
```

---

# Docker Commands

## List containers

```bash
docker ps -a
```

---

## Start the container

```bash
docker start -ai pintos
```

---

## Stop the container

Inside the container:

```bash
exit
```

or from another terminal:

```bash
docker stop pintos
```

---

## Remove the container

```bash
docker rm pintos
```

---

## Remove the Docker image

```bash
docker rmi pintos-env
```

---

# Running Docker Without sudo

Create the Docker group (if necessary):

```bash
sudo groupadd docker
```

Add your user:

```bash
sudo usermod -aG docker $USER
```

Apply the changes:

```bash
newgrp docker
```

or simply log out and log back in.

Verify:

```bash
groups
```

You should see:

```text
docker
```

Now Docker commands can be run without `sudo`.

---

# Useful Docker Commands

Check Docker version:

```bash
docker --version
```

List images:

```bash
docker images
```

List running containers:

```bash
docker ps
```

List all containers:

```bash
docker ps -a
```

Open a shell inside a running container:

```bash
docker exec -it pintos bash
```

View logs:

```bash
docker logs pintos
```

---

# Recommended Development Tools

The following tools are recommended while working with Pintos:

- VS Code
- Docker
- GDB
- CGDB
- ctags
- cscope
- Git

---

# Debugging

Instead of running:

```bash
pintos --
```

you can use:

```bash
pintos-gdb
```

This allows you to:

- set breakpoints
- inspect memory
- inspect threads
- step through kernel execution
- debug Pintos assignments

---

# Final Notes

Your development environment now consists of:

- **Host OS:** Fedora Linux
- **Container OS:** Ubuntu 18.04
- **Emulator:** QEMU
- **Compiler:** i386-elf GCC
- **Debugger:** GDB / CGDB
- **Source Code:** Mounted from Fedora into Docker

This setup closely matches the environment recommended by the Pintos documentation while keeping your Fedora system clean and isolated.
