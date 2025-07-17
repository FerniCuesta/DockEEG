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
