# Container Image Log

Registro de imágenes de contenedor (Docker y Podman) utilizadas en el proyecto, con versión, nombre y cambios introducidos.

| Imagen               | Versión    | Cambios introducidos                                                    | Fecha      |
| -------------------- | ---------- | ----------------------------------------------------------------------- | ---------- |
| hpmoon-ubuntu-no-gpu | v0.0.1     | Imagen base, sin soporte GPU                                            | 2025-07-18 |
| hpmoon-ubuntu-no-gpu | v0.0.2     | Añade soporte para logs                                                 | 2025-07-19 |
| hpmoon-ubuntu-no-gpu | v0.0.3     | Permite añadir comandos por CMD                                         | 2025-07-19 |
| hpmoon-ubuntu-no-gpu | v0.0.4     | Permite elegir si se muestran logs o no                                 | 2025-07-21 |
| hpmoon-ubuntu-no-gpu | v0.0.5     | Actualizada la imagen base a Ubuntu 24.04                               | 2025-07-21 |
| hpmoon-ubuntu-no-gpu | v0.0.5-log | Logs activados                                                          | 2025-07-22 |
| hpmoon-ubuntu-no-gpu | v0.0.6     | Permite ejecutar la imagen indicando el comando de entrada por terminal | 2025-08-12 |
| hpmoon-ubuntu-no-gpu | v0.0.6-log | Logs activados para multinodo en localhost                              | 2025-08-12 |
| hpmoon-ubuntu-no-gpu | v0.0.7     | Reduce el número de dependencias y optimiza el tamaño de la imagen      | 2025-08-28 |
