# Docker Cheatsheet

Guía rápida de comandos Docker para gestión de imágenes, contenedores y recursos.

---

## Imágenes

### Listar imágenes

```bash
docker images
```

Muestra todas las imágenes locales disponibles en tu sistema.

```bash
docker image ls -a
```

Lista todas las imágenes, incluyendo las intermedias y huérfanas.

---

### Construir imagen

```bash
docker build -t nombre:tag -f Dockerfile.dev .
```

Construye una imagen usando el Dockerfile especificado (`-f Dockerfile.dev`) y le asigna un nombre y etiqueta (`-t nombre:tag`). El punto (`.`) indica el contexto de construcción (directorio actual).

---

### Eliminar imagen

```bash
docker rmi imagen_id
```

Elimina la imagen cuyo ID se indica.

```bash
docker rmi nombre:tag
```

Elimina la imagen por nombre y etiqueta.

```bash
docker image prune
```

Elimina todas las imágenes huérfanas (no asociadas a ningún contenedor).

---

## Contenedores

### Ejecutar contenedor

```bash
docker run nombre:tag
```

Ejecuta un contenedor a partir de la imagen especificada.

```bash
docker run -it nombre:tag bash
```

Ejecuta el contenedor en modo interactivo (`-it`) y abre una terminal bash dentro del contenedor.

```bash
docker run -d nombre:tag
```

Ejecuta el contenedor en segundo plano (`-d`, detached).

```bash
docker run --rm nombre:tag
```

Elimina el contenedor automáticamente al finalizar la ejecución (`--rm`).

```bash
docker run --name mi-contenedor app
```

Ejecuta el contenedor y le asigna el nombre personalizado `mi-contenedor` (`--name`).

---

### Montar volúmenes y puertos

```bash
docker run -v $(pwd):/app app
```

Monta el directorio actual (`$(pwd)`) como `/app` dentro del contenedor (`-v` para volúmenes).

```bash
docker run -p 8080:80 app
```

Mapea el puerto 80 del contenedor al puerto 8080 del host (`-p` para puertos).

```bash
docker run -v config.xml:/root/config.xml app
```

Monta el archivo `config.xml` del host en la ruta `/root/config.xml` del contenedor.

---

### Variables de entorno

```bash
docker run -e VAR=valor app
```

Establece la variable de entorno `VAR` con el valor `valor` dentro del contenedor (`-e`).

```bash
docker run --env-file .env app
```

Carga todas las variables de entorno definidas en el archivo `.env` (`--env-file`).

---

## Gestión de contenedores

### Listar contenedores

```bash
docker ps
```

Muestra los contenedores en ejecución.

```bash
docker ps -a
```

Muestra todos los contenedores, incluyendo los detenidos.

```bash
docker ps -q
```

Muestra solo los IDs de los contenedores.

---

### Controlar contenedores

```bash
docker start contenedor_id
```

Inicia un contenedor detenido.

```bash
docker stop contenedor_id
```

Detiene un contenedor en ejecución.

```bash
docker restart contenedor_id
```

Reinicia un contenedor.

```bash
docker kill contenedor_id
```

Detiene un contenedor de forma inmediata (forzada).

---

### Eliminar contenedores

```bash
docker rm contenedor_id
```

Elimina un contenedor detenido.

```bash
docker rm -f contenedor_id
```

Elimina un contenedor, forzando su parada si está en ejecución.

```bash
docker container prune
```

Elimina todos los contenedores detenidos.
