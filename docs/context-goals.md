# Contexto y Objetivos del TFG

## Problemática

Los equipos modernos, especialmente los nuevos MacBooks, utilizan arquitectura **big.LITTLE** que combina:

- **Núcleos de alto rendimiento** (performance cores)
- **Núcleos energéticamente eficientes** (efficiency cores)

### Cronología de adopción:

- **Móviles**: Años de uso establecido
- **Apple**: Introducido en MacBooks en 2020
- **Intel**: Adoptado en 2021

Esta tecnología está **apenas sin explorar** para aplicaciones de escritorio, ofreciendo nuevas oportunidades de cómputo paralelo pero también planteando retos significativos.

## Objetivos del TFG

### 1. Viabilidad de Docker para HPC

Estudiar las **limitaciones y viabilidad** de usar tecnología de contenedores (Docker) para encapsular aplicaciones HPC, con el objetivo de:

- Facilitar el uso a la comunidad científica
- Abstraer la complejidad de instalación y configuración
- Permitir ejecución en cualquier sistema, no solo el original

### 2. Análisis multiplataforma

Realizar un análisis riguroso en los **3 sistemas operativos dominantes**:

- **Microsoft Windows**
- **Linux**
- **macOS**

Utilizando un MacBook para macOS y PCs de escritorio para Windows/Linux.

## Resultados Preliminares

### Funcionamiento básico

- Las aplicaciones funcionan correctamente en **modo multi-núcleo** en todos los sistemas

### Limitaciones identificadas

#### Arquitectura big.LITTLE

- Las aplicaciones de **computación homogénea CPU** necesitan adaptación
- Riesgo de **desbalanceo de carga** si no se adaptan correctamente
- Los **cores de eficiencia no son detectados** en MacBooks

#### GPU Computing

- **GPUs integradas**: No utilizables en ningún sistema
- **GPUs dedicadas**: Funcionamiento dependiente del driver del fabricante
- **Incompatibilidad**: No es posible crear una imagen Docker única para GPUs NVIDIA y AMD

## Implicaciones

Estos hallazgos preliminares sugieren que:

1. La containerización de aplicaciones HPC presenta **retos específicos** en arquitecturas heterogéneas
2. Es necesario desarrollar **estrategias de adaptación** para arquitecturas big.LITTLE
3. El soporte GPU requiere **enfoques específicos por fabricante**

## Referencias

- [Docker Mac cores eficiencia issue](https://github.com/docker/for-mac/issues/5812)
- Conclusiones preliminares del tutor (Juan José Escobar)

## Objetivo Principal

Analizar la viabilidad y las limitaciones del uso de contenedores para encapsular y ejecutar aplicaciones de alto rendimiento (HPC) en arquitecturas heterogéneas modernas y entornos multiplataforma, con el fin de facilitar su portabilidad, uso y adopción por parte de la comunidad científica.

### Objetivos Secundarios

- **OB1:** Investigar el estado actual de la tecnología de contenedores, especialmente Docker, y su aplicación en entornos de computación de alto rendimiento.

- **OB2:** Estudiar el comportamiento de aplicaciones HPC ejecutadas en contenedores sobre sistemas operativos mayoritarios: Microsoft Windows, Linux y macOS.

- **OB3:** Analizar el impacto de las arquitecturas heterogéneas big.LITTLE en el rendimiento de aplicaciones HPC containerizadas, investigando específicamente los problemas de detección de núcleos de eficiencia y el balanceamiento de carga de trabajo entre núcleos de alto rendimiento y eficiencia energética.

- **OB4:** Analizar las capacidades de Docker para aprovechar recursos hardware avanzados, como núcleos eficientes y GPUs (integradas y dedicadas), en diferentes plataformas y arquitecturas.

- **OB5:** Detectar y documentar los problemas de compatibilidad y portabilidad que dificultan la creación de imágenes Docker universales para entornos heterogéneos.

- **OB6:** Proponer recomendaciones o estrategias para mejorar la ejecución y portabilidad de aplicaciones HPC en entornos contenedorizados y heterogéneos.

- **OB7:** Caracterizar el soporte GPU en contenedores, evaluando las limitaciones y capacidades de Docker para el aprovechamiento de recursos GPU tanto integrados como dedicados, analizando la compatibilidad con diferentes fabricantes (NVIDIA y AMD) y las restricciones impuestas por los drivers.

- **OB8:** Desarrollar un marco de evaluación que establezca métricas y metodologías de benchmarking para la evaluación sistemática del rendimiento de aplicaciones HPC containerizadas en arquitecturas big.LITTLE.

- **OB9:** Analizar la reproducibilidad científica, determinando en qué medida la containerización con Docker contribuye a la reproducibilidad y portabilidad de experimentos científicos computacionales.

## Estado del Arte

### OB1. Tecnología de contenedores en HPC

1. **Evolución de la contenerización en el ámbito científico:** Docker, Podman y Singularity/Apptainer.
2. **Casos reales de uso:** Implementación de contenedores en clústeres de supercomputación y entornos HPC.
3. **Beneficios en HPC:** Portabilidad, facilidad de uso, simplificación de instalación y configuración.
4. **Desafíos técnicos:** Problemas de rendimiento (overhead), seguridad, aislamiento y acceso al hardware.

### OB2. Comportamiento en distintos sistemas operativos

1. **Comparación de rendimiento:** Docker en Windows, Linux y macOS.
2. **Diferencias arquitectónicas:** Docker Engine (Linux) vs Docker Desktop (Windows/macOS).
3. **Limitaciones y compatibilidades:** Específicas de cada sistema operativo.

### OB3. Arquitecturas big.LITTLE y rendimiento containerizado

1. **Fundamentos de arquitecturas heterogéneas:** ARM big.LITTLE, Intel Lakefield, Apple Silicon.
2. **Origen y adopción:** De móviles a escritorio y portátiles.
3. **Impacto en rendimiento:** Aplicaciones HPC containerizadas.
4. **Detección y aprovechamiento:** Núcleos de eficiencia desde el contenedor.
5. **Balanceo de carga:** Problemas entre núcleos de distinto tipo.
6. **Asignación óptima de hilos:** Estrategias de thread placement.
7. **Adaptación de aplicaciones:** De cómputo homogéneo a arquitecturas heterogéneas.

### OB4. Acceso a hardware avanzado desde Docker

1. **Soporte de Docker:** Núcleos de rendimiento y eficiencia en arquitecturas híbridas.
2. **Acceso a GPUs:** Integradas y dedicadas desde contenedores.
3. **Compatibilidad:** Diferentes fabricantes (NVIDIA y AMD).
4. **Restricciones:** Impuestas por los drivers.
5. **Dificultades:** Creación de imágenes Docker compatibles con múltiples fabricantes y tipos de GPU.

### OB5. Compatibilidad y portabilidad de imágenes Docker

1. **Optimización de imágenes:** Técnicas (tamaño, dependencias, multietapa).
2. **Imágenes multiarquitectura:** linux/amd64, linux/arm64, buildx.
3. **Compatibilidad entre arquitecturas:** x86_64 vs ARM.
4. **Influencia del sistema anfitrión:** En la ejecución del contenedor.
5. **Buenas prácticas:** Para imágenes altamente portables.
6. **Retos:** Creación de imágenes Docker universales para HPC heterogéneo.

### OB6. Estrategias para mejorar ejecución y portabilidad

1. **Diseño eficiente:** Imágenes Docker para HPC.
2. **Enfoques adaptativos:** Según recursos disponibles (CPU, GPU, arquitectura).
3. **Detección dinámica:** Del entorno de ejecución.
4. **Automatización:** Despliegue y configuración en entornos diversos.

### OB7. Soporte GPU y compatibilidad por fabricante

1. **Diferencias en containerización:** GPUs integradas vs dedicadas.
2. **Estado actual:** Soporte para GPUs integradas (Intel, Apple) desde contenedores.
3. **Comparativas:** Compatibilidad y rendimiento entre GPUs NVIDIA y AMD.
4. **Limitaciones:** Herramientas, drivers y falta de estandarización.

### OB8. Marco de evaluación y benchmarking

1. **Herramientas de benchmarking HPC:** HPL, LINPACK, sysbench, Phoronix Test Suite.
2. **Métricas relevantes:** Rendimiento por core, eficiencia energética, escalabilidad.
3. **Comparación:** Ejecución nativa vs en contenedor.
4. **Metodologías de evaluación:** En entornos heterogéneos.
5. **Marcos reproducibles:** Evaluación sistemática en entornos containerizados.
6. **Enfoques específicos:** Benchmarking para arquitecturas big.LITTLE.

### OB9. Reproducibilidad científica con contenedores

1. **Ventajas de Docker:** En la reproducibilidad de entornos científicos.
2. **Casos reales:** Contenerización y replicabilidad de experimentos.
3. **Gestión de versiones:** Control del entorno mediante contenedores.
4. **Comparativa:** Métodos tradicionales vs enfoques basados en contenedores.
