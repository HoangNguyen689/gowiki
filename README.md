Terraform lib: https://registry.terraform.io

```bash
terraform init
```

```bash
terraform plan
```

```bash
terraform apply
```

Simple web app

- https://go.dev/doc/articles/wiki/

Docker

- https://docs.docker.com/language/golang/build-images/


```bash
docker build --tag docker-gowiki

# Directly
docker run --publish 8080:8080 docker-gowiki

# Detached
docker run -d -p 8080:8080 docker-gowiki
```

**TODO**
- CD
- grpc, grpc-web
- dynamoDB