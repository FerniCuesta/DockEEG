# DockEEG

DockEEG es el repositorio principal del Trabajo Fin de Grado (TFG) dedicado al análisis de la contenerización de aplicaciones paralelas y distribuidas para la clasificación de EEGs. El proyecto evalúa el rendimiento, escalabilidad y portabilidad de la aplicación Hpmoon en diferentes entornos (nativo, Docker, Podman) y arquitecturas (CPU, GPU, multi-nodo).

## Personal y contacto

- **Autor**: Fernando Cuesta Bueno
- **Correo**: fernandocuesta@correo.ugr.es

- **Tutor**: Juan José Escobar Pérez

## Estructura del repositorio

- **analysis/**  
  Contiene notebooks para el análisis de resultados experimentales, incluyendo estudios de escalabilidad y visualización de datos.

- **docker/**  
  Incluye los archivos necesarios para la construcción de imágenes de contenedor y la ejecución de la aplicación Hpmoon:

  - `ubuntu/`: Dockerfile y subcarpeta `Hpmoon/` con el código fuente y scripts de la aplicación.

- **docs/**  
  Documentación adicional del proyecto, como el historial de imágenes de contenedor.

- **results/**  
  Resultados experimentales organizados por tipo de experimento:

  - `experiments/`: Resultados de barridos de parámetros y comparativas.
  - `multi-node/`, `single-node/`, `thread-sweep/`: Resultados específicos de experimentos multinodo, mononodo y barridos de hilos.

- **scripts/**  
  Scripts de automatización para la ejecución de experimentos en diferentes plataformas y configuraciones:

  - Scripts principales para lanzar experimentos en Ubuntu, Mac y Windows.
  - Subcarpetas para experimentos específicos (`experiments/`, `multi-node/`, `single-node/`, `thread-sweep/`).
  - `utils/`: Utilidades para la gestión del sistema y la compilación de Hpmoon.

- **thesis/**  
  Carpeta con la memoria del TFG en formato LaTeX, imágenes, bibliografía y capítulos organizados.

- **requirements.txt**  
  Dependencias de Python necesarias para el análisis de resultados.

- **README.md**  
  Este archivo, con la descripción general y guía de la estructura del repositorio.

---

Este repositorio proporciona todo lo necesario para reproducir los experimentos, analizar los resultados y consultar la documentación y memoria del
