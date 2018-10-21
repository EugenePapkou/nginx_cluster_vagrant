# Setting up nginx web-cluster with load balancer using Vagrant

Each nginx node adds header "backend_srv" with a unique value (node1, node2) using directive add_header.

Load balancer has the following conditions:

1. Serves HTTPS requests using self-signed certificate.
  
2. Redirects all HTTP requests to HTTPS.
  
3. Listens on port 8080 for HTTP and 8443 for HTTPS
  
4. Binds on all interfaces.
  
5. Server_name identical to host’s ip-address.
  
6. Balances requests to two NGINX servers.
  
7. Uses round-robin balance algorithm.
  
8. Requests are distributed as 1/3 among upstreams.
  
9. /status location isn't passed to upstream, but show status of LB itself.
  
10. LB intercepts 404 errors from upstreams and return err.html file located on LB.
  
11. Upstream block is in a separate config file "web.conf" under "/home/<user>/nginx/conf/upstreams/" folder.
  
12. Server block is in a separate config file "lb.conf" under "/home/<user>/nginx/conf/vhosts/" folder.
