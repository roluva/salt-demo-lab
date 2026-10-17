FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

# 1. Instalar herramientas base en Ubuntu 20.04
RUN apt-get update && apt-get install -y \
    curl \
    gnupg \
    procps \
    iputils-ping \
    && rm -rf /var/lib/apt/lists/*

# 2. Agregar el repositorio oficial de Salt Project e instalar Master y Minion
RUN mkdir -p /etc/apt/keyrings && \
    curl -fsSL https://packages.broadcom.com/artifactory/api/security/keypair/SaltProjectKey/public | tee /etc/apt/keyrings/salt-archive-keyring.pgp > /dev/null && \
    curl -fsSL https://github.com/saltstack/salt-install-guide/releases/latest/download/salt.sources | tee /etc/apt/sources.list.d/salt.sources > /dev/null && \
    apt-get update && apt-get install -y salt-master salt-minion && \
    rm -rf /var/lib/apt/lists/*

# 3. Aceptar las llaves de los Minions automáticamente
RUN mkdir -p /etc/salt/master.d && \
    echo "auto_accept: True" > /etc/salt/master.d/auto_accept.conf
