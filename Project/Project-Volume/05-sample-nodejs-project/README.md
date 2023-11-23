1. Build Image using Dockerfile
```sh
docker build -t raghib1992/sample-story:latest .
docker login
docker push raghib1992/sample-story:latest
```
2. Create deployment.yaml
3. Create service.yaml
4. test REST-API using POstman
```sh
# GET 
localhost/story
# POst
localhost/story
### Body
{
    "text": "New Text"
}
```
