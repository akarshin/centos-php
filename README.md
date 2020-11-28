Cheat sheet to build and push

```
docker build -t docker.pkg.github.com/akarshin/centos-php/app:0.1.3 -t docker.pkg.github.com/akarshin/centos-php/app:latest .
docker push docker.pkg.github.com/akarshin/centos-php/app:0.1.3
docker push docker.pkg.github.com/akarshin/centos-php/app:latest
```
