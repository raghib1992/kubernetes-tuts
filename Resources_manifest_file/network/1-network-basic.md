# Network Basic
## To see the host interfaces
```
ip link
```
## to assign ip address to interface
```
ip addr add 192.168.1.0/24 dev eth0
```
## to existing routing configuration on the network
```
route
```
## to configure a gateway
```
ip route add 192.168.2.0/24 via 192.168.1.1/24
```

# Setup linux as router
## add gate0way 
```
ip addr add 192.168.2.0 via 192.168.1.6
```
## in linux, to allow traffic forward from one eth port to other eth port
```
cat /proc/sys/net/ipv4/ip_forward
0 (default)     No forward
1               forward
```

## Network namespace in linux host
```sh
# Create new namespace
ip netns add red
ip netns add blue
# List the namespace
ip netns

# link
ip netns exec red ip link
ip -n red link 
```