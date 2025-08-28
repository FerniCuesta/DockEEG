# Docker Cheatsheet

Guía rápida de comandos Docker para gestión de imágenes, contenedores y recursos.

---

## Imágenes

### Listar imágenes

Muestra todas las imágenes locales disponibles en tu sistema.

```bash
docker images
```

Lista todas las imágenes, incluyendo las intermedias y huérfanas.

```bash
docker image ls -a
```

---

### Construir imagen

Construye una imagen usando el Dockerfile especificado (`-f Dockerfile`) y le asigna un nombre y etiqueta (`-t nombre:tag`). El punto (`.`) indica el contexto de construcción (directorio actual).

```bash
docker build -t nombre:tag -f Dockerfile .
```

---

### Eliminar imagen

Elimina la imagen cuyo ID se indica.

```bash
docker rmi imagen_id
```

Elimina la imagen por nombre y etiqueta.

```bash
docker rmi nombre:tag
```

Elimina todas las imágenes huérfanas (no asociadas a ningún contenedor).

```bash
docker image prune
```

---

## Contenedores

### Ejecutar contenedor

Ejecuta un contenedor a partir de la imagen especificada.

```bash
docker run nombre:tag
```

Ejecuta el contenedor en modo interactivo (`-it`) y abre una terminal bash dentro del contenedor.

```bash
docker run -it nombre:tag bash
```

Ejecuta el contenedor en segundo plano (`-d`, detached).

```bash
docker run -d nombre:tag
```

Elimina el contenedor automáticamente al finalizar la ejecución (`--rm`).

```bash
docker run --rm nombre:tag
```

Ejecuta el contenedor y le asigna el nombre personalizado `mi-contenedor` (`--name`).

```bash
docker run --name mi-contenedor app
```

---

### Montar volúmenes y puertos

Monta el directorio actual (`$(pwd)`) como `/app` dentro del contenedor (`-v` para volúmenes).

```bash
docker run -v $(pwd):/app app
```

Mapea el puerto 80 del contenedor al puerto 8080 del host (`-p` para puertos).

```bash
docker run -p 8080:80 app
```

Monta el archivo `config.xml` del host en la ruta `/root/config.xml` del contenedor.

```bash
docker run -v config.xml:/root/config.xml app
```

---

### Variables de entorno

Establece la variable de entorno `VAR` con el valor `valor` dentro del contenedor (`-e`).

```bash
docker run -e VAR=valor app
```

Carga todas las variables de entorno definidas en el archivo `.env` (`--env-file`).

```bash
docker run --env-file .env app
```

---

## Gestión de contenedores

### Listar contenedores

Muestra los contenedores en ejecución.

```bash
docker ps
```

Muestra todos los contenedores, incluyendo los detenidos.

```bash
docker ps -a
```

Muestra solo los IDs de los contenedores.

```bash
docker ps -q
```

---

### Controlar contenedores

Inicia un contenedor detenido.

```bash
docker start contenedor_id
```

Detiene un contenedor en ejecución.

```bash
docker stop contenedor_id
```

Reinicia un contenedor.

```bash
docker restart contenedor_id
```

Detiene un contenedor de forma inmediata (forzada).

```bash
docker kill contenedor_id
```

---

### Eliminar contenedores

Elimina un contenedor detenido.

```bash
docker rm contenedor_id
```

Elimina un contenedor, forzando su parada si está en ejecución.

```bash
docker rm -f contenedor_id
```

Elimina todos los contenedores detenidos.

```bash
docker container prune
```
