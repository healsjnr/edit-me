sudo docker build -t editme/site .
sudo docker run -p 80:80 -d editme/site
