docker build --no-cache -t nodejs-core .

docker run -d -p 8080:8080 --restart=always --name=iis-node nodejs-core