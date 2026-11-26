# Docker - Build and Usage 

* Docker command below are to build and use this specific repo and not generally valid for any Docker project
* Install **Docker Desktop** from https://docs.docker.com/   
* Go to root-dir of this repo (relative paths used during build)

## 1. Build image 
`-t` stands for tag  
`-f` location of Dockerfile  
```
docker build --no-cache -t type-m-error:v0.0.0 -f docker/v2/Dockerfile .
docker build            -t type-m-error:v0.0.0 -f docker/v2/Dockerfile .
```

## 2. Usage 

### 2.1 Creates container from image and start
`-d`      detached: Docker runs it independently of terminal  
`-p`      HOST_PORT:CONTAINER_PORT  
`--name` 	Assign  name to  container  

```
# create container 1 and start (two-liner)
docker create -p  3838:3838 --name typemerror-cont type-m-error:v0.0.0
docker start typemerror-cont

# create container 2 and start (one-liner)
docker run -d -p 50111:3838 --name typemerror-cont type-m-error:v0.0.0
```

### 2.2 Local check/usage in browser 
http://localhost:3838  
http://localhost:50111  

### 2.3 Stop container
```
docker stop typemerror-cont
```

### 2.4 Get info
```
docker images
docker ps
docker ps -a
```

## 3. Clean-up

### 3.1 Remove container
`-f`  force
```
docker rm -f typemerror-cont
```

### 3.2 Erase image
```
docker rmi type-m-error:v0.0.0
```

