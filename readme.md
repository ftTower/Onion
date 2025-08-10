#Oignon webserver

## setup

for this demo i use this version of debian : https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-13.0.0-amd64-netinst.iso

add additional gest to have shared clipboard


## make a oignon web server 

```bash
su -
```

```bash
apt-get install git -y && git clone https://github.com/ftTower/Onion.git Onion && cd Onion && make start 
```

## Client testing

```bash
su -
```


```bash
sudo apt-get update && sudo apt-get upgrade && sudo apt install wget curl -y
wget https://www.torproject.org/dist/torbrowser/14.5.5/tor-browser-linux-x86_64-14.5.5.tar.xz

```