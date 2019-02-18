# Matters OpenVPN Setup

## OpenVPN Server Setup

* `mkdir -p /home/ubuntu/ovpn-data`
* Generate config files: `docker-compose run --rm openvpn ovpn_genconfig -u tcp://{SERVER_IP}:14418`
* Generate private key: `docker-compose run --rm openvpn ovpn_initpki`
* Create client users: 
  * `docker-compose run --rm openvpn easyrsa build-client-full {USER_PROFILE_NAME}`
    * Enter login password
    * Enter CA passphase
  * `docker-compose run --rm openvpn ovpn_getclient {USER_PROFILE_NAME} > {USER_PROFILE_NAME}.ovpn`
* Run OpenVPN server: `docker-compose up -d`
* NOTE: make sure inbound rules for `TCP port: 14418` is open

## Connect to OpenVPN over Socks5 Proxy

Add the following lines to `.ovpn` file:

```
#by pass socks5 server address
route {SOCKS5_SERVER_IP} 255.255.255.255 net_gateway
#use socks5 proxy
socks-proxy 127.0.0.1 1080
```