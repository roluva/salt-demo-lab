# Laboratorio Práctico: Automatización de Infraestructura con Salt Project (SaltStack)

Este repositorio contiene un entorno de laboratorio basado en **Docker** y **Docker Compose** diseñado para demostrar la gestión de configuración declarativa, ejecución remota en paralelo (vía bus ZeroMQ) e idempotencia utilizando **Salt Project (SaltStack)**.

---

## 🏗️ Arquitectura del Entorno

El escenario levanta un clúster local con 3 contenedores interconectados:

| Contenedor | Rol en SaltStack | Descripción | Puerto Expuesto (Host -> Contenedor) |
| :--- | :--- | :--- | :--- |
| **`salt-master`** | **Salt Master** | Servidor central de control encargado de administrar los estados y enviar órdenes. | N/A (Control interno) |
| **`web-01`** | **Salt Minion** | Nodo administrado #1 donde se instalará y configurará Nginx automáticamente. | `http://localhost:8081` -> `80` |
| **`web-02`** | **Salt Minion** | Nodo administrado #2 donde se instalará y configurará Nginx automáticamente. | `http://localhost:8082` -> `80` |

### Estructura del Proyecto
```text
salt-demo-lab/
├── Dockerfile              # Imagen base Ubuntu 20.04 con Salt Master/Minion y parche de sistema
├── docker-compose.yml      # Orquestación de contenedores y redes virtuales
├── README.md               # Documentación y guía de ejecución
└── salt/                   # Directorio sincronizado (/srv/salt en el Master)
    ├── top.sls             # Mapeo de nodos (Target '*web*') hacia los estados correspondientes
    ├── webserver.sls       # Estado declarativo: instalación de Nginx, archivos y servicio
    └── files/
        └── index.html      # Página web personalizada distribuida automáticamente
