# Container Image Log

Registro de imágenes de contenedor (Docker y Podman) utilizadas en el proyecto, con versión, nombre y cambios introducidos.

| Imagen        | Versión              | Descripción                             |
| ------------- | -------------------- | --------------------------------------- |
| hpmoon-ubuntu | v0.0.1               | Imagen base, sin soporte GPU            |
| hpmoon-ubuntu | v0.0.2 / v0.0.2-logs | Añade soporte para logs                 |
| hpmoon-ubuntu | v0.0.3 / v0.0.3-logs | Actualiza la imagen base a Ubuntu 24.04 |
| hpmoon-ubuntu | v0.0.4 / v0.0.4-logs | Añade soporte para GPU                  |

Las versiones con sufijo `-logs` incluyen soporte para logs detallados, mientras que las versiones sin sufijo son versiones estándar sin este soporte adicional.

Las imágenes están disponibles en [Docker Hub](https://hub.docker.com/repository/docker/ferniicueesta/hpmoon-ubuntu/general).
