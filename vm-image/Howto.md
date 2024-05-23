### Download an CloudImg
```
wget https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img
```

### Create Docker Image and push to registry (public)
```
docker build -t ghcr.io/USERNAME/kubevirt-noble-x64:latest .
docker push ghcr.io/USERNAME/kubevirt-noble-x64:latest
```