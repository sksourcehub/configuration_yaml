# Cluster configuration file

-  Change kind-deploy file if you need a worker node 
-  Give executable permission to k8s.sh
-  Execute k8s.sh  


### For allowing kubernetes to pull private registry

- First login to docker from inside the kind cluster (master if you are using onlu master node)

```
$ docker login
```
When prompted, enter your Docker username and password.

The login process creates or updates a config.json file that holds an authorization token.

View the config.json file:

```
$ cat ~/.docker/config.json
```
The output contains a section similar to this:

```
{
    "auths": {
        "https://index.docker.io/v1/": {
            "auth": "c3R...zE2"
        }
    }
}
```
Now create a secret for kubernetes (or look into the file ./app/registry-key.yaml)

```
apiVersion: v1
kind: Secret
metadata:
  ...
  name: regcred
  ...
data:
  .dockerconfigjson: 
type: kubernetes.io/dockerconfigjson
```

Now pipe the /.docker/config.json into base64 encoded

```
$ cat .docker/config.json | base64
```
Copy the output and paste it in as value for .dockerconfigjson

```
Note:  create a NFS server and edit the the ./app/pv.yaml according to the NFS server.
```