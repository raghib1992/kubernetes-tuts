1. Create users app
- create user-token app container image from Dockerfile in users-api folder 
- create users-deplaoyment.yaml file and users-service.yaml file and create service
    - either create nodePort or LoadBalancer service
    - Loadbalancer is prefered
- Create Deployent and service
- Check frompostman
```
localhost:8080/signup
Body-JSON
{
    "email": "r@r.com",
    "password": "qwe"
}

localhost:8080/login
body-JSON
{
    "email": "r@r.com",
    "password": "qwe"
}
```
2. Create auth app
3. Create tasks app
4. Create reverse proxy
