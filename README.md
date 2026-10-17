# Laboratorio Práctico: Automatización de Infraestructura con Salt Project (SaltStack)

Este repositorio contiene un entorno de laboratorio basado en **Docker** y **Docker Compose**, diseñado para demostrar la gestión de configuración declarativa, la ejecución remota en paralelo mediante ZeroMQ y la idempotencia utilizando **Salt Project (SaltStack)**.

---

## 🏗️ Arquitectura del entorno

El laboratorio despliega un entorno local compuesto por **3 contenedores interconectados**:

| Contenedor | Rol en SaltStack | Descripción | Puerto expuesto |
|:---|:---|:---|:---|
| `salt-master` | Salt Master | Servidor central encargado de administrar los estados y enviar órdenes. | Interno |
| `web-01` | Salt Minion | Primer nodo administrado, donde se instalará y configurará Nginx automáticamente. | `8081 → 80` |
| `web-02` | Salt Minion | Segundo nodo administrado, donde se instalará y configurará Nginx automáticamente. | `8082 → 80` |

Los servidores web estarán disponibles en las siguientes direcciones una vez aplicada la configuración:

- **Web 01:** http://localhost:8081
- **Web 02:** http://localhost:8082

## 📁 Estructura del proyecto

```text
salt-demo-lab/
├── Dockerfile
├── docker-compose.yml
├── README.md
└── salt/
    ├── top.sls
    ├── webserver.sls
    └── files/
        └── index.html
```

| Archivo o directorio | Descripción |
|:---|:---|
| `Dockerfile` | Define la imagen base Ubuntu 20.04 con Salt y los ajustes necesarios del sistema. |
| `docker-compose.yml` | Configura los contenedores, sus servicios y la red virtual. |
| `salt/top.sls` | Asocia los nodos objetivo con los estados que deben aplicarse. |
| `salt/webserver.sls` | Define la instalación de Nginx, la configuración de archivos y la gestión del servicio. |
| `salt/files/index.html` | Contiene la página web personalizada que se distribuirá a los servidores. |

---

## 🚀 Pasos de ejecución

### 1. Construir e iniciar la infraestructura

Desde el directorio raíz del proyecto, ejecuta el siguiente comando para construir las imágenes e iniciar los contenedores en segundo plano:

```bash
sudo docker compose up -d --build
```

### 2. Verificar el estado de los contenedores

Comprueba que los tres contenedores se encuentren activos:

```bash
sudo docker compose ps
```

Debes identificar los siguientes servicios:

- `salt-master`
- `web-01`
- `web-02`

### 3. Comprobar el estado inicial de los servidores

Antes de aplicar los estados de Salt, consulta las direcciones de los servidores web:

```bash
curl http://localhost:8081
curl http://localhost:8082
```

Si Nginx todavía no está instalado o en ejecución, las solicitudes deberían fallar. Esto permite comprobar el estado inicial de los servidores antes de la automatización.

### 4. Acceder al Salt Master

Abre una terminal interactiva dentro del contenedor encargado de administrar los nodos:

```bash
sudo docker exec -it salt-master bash
```

El prompt cambiará a una terminal dentro del contenedor, similar a:

```text
root@salt-master:/#
```

A partir de este momento, los siguientes comandos se ejecutarán dentro del Salt Master.

### 5. Verificar las llaves criptográficas

Salt utiliza llaves para autenticar a los Minions y permitir que se comuniquen con el Master.

Ejecuta:

```bash
salt-key -L
```

Comprueba que `web-01` y `web-02` aparezcan en la sección `Accepted Keys`, lo que indica que sus llaves han sido aceptadas por el Master.

### 6. Comprobar la comunicación con los Minions

Ejecuta una prueba de conectividad con todos los nodos:

```bash
salt '*' test.ping
```

El carácter `*` selecciona todos los Minions disponibles. Si la comunicación funciona correctamente, ambos nodos responderán con `True`.

### 7. Aplicar los estados de Salt (primera ejecución)

Ejecuta el siguiente comando para aplicar los estados definidos en los archivos de configuración:

```bash
salt '*' state.apply
```

Salt se encargará de ejecutar las tareas declaradas, entre ellas:

- Instalar Nginx en ambos servidores.
- Distribuir la página web personalizada.
- Asegurar que el servicio de Nginx esté habilitado y en ejecución, según los estados definidos.

### 8. Demostrar la idempotencia (segunda ejecución)

Vuelve a ejecutar el mismo comando:

```bash
salt '*' state.apply
```

Esta segunda ejecución permite comprobar el principio de **idempotencia**: si los nodos ya se encuentran en el estado deseado, Salt no debería realizar cambios innecesarios.

En el resultado, revisa los valores `Succeeded`, `Failed` y `Changes`. Si la configuración ya está aplicada, los estados deberían completarse correctamente sin cambios adicionales.

> **Nota:** Los resultados exactos dependen de los estados definidos y de la configuración de los contenedores. No necesariamente se reportará `Succeeded: 3`, ya que el número de estados ejecutados puede variar.

### 9. Salir del Salt Master

Cuando termines las pruebas, cierra la sesión interactiva:

```bash
exit
```

Volverás a la terminal del sistema anfitrión.

### 10. Verificar el resultado final

Consulta nuevamente las direcciones de los servidores web:

```bash
curl http://localhost:8081
curl http://localhost:8082
```

Si la automatización se ejecutó correctamente, ambos servidores devolverán el contenido de la página web personalizada definida en `salt/files/index.html`.

También puedes abrir las direcciones directamente en tu navegador:

- http://localhost:8081
- http://localhost:8082

---

## ✅ Resultados esperados

Al finalizar el laboratorio, se espera haber comprobado los siguientes aspectos:

- **Infraestructura:** los tres contenedores se encuentran en ejecución.
- **Comunicación:** el Salt Master se comunica correctamente con ambos Minions.
- **Automatización:** Nginx se instala y configura mediante estados declarativos.
- **Despliegue:** la página web personalizada está disponible en ambos servidores.
- **Idempotencia:** al volver a aplicar los estados, no se producen cambios innecesarios si la configuración ya coincide con el estado deseado.

## 🛠️ Tecnologías utilizadas

- [Docker](https://www.docker.com/)
- [Docker Compose](https://docs.docker.com/compose/)
- [Salt Project](https://saltproject.io/)
- [Nginx](https://nginx.org/)
- [ZeroMQ](https://zeromq.org/)
