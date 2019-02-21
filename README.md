# akamai-docker

Docker container with all tools for Akamai

## Pull container

```shell
docker pull apiheat/akamai-docker
```

## Run container

```shell
docker run -it -rm -v $HOME/.edgerc:/root/.edgerc apiheat/akamai-docker
```

### Run CPS

```shell
akamai cps setup --section <SECTION_NAME if not cps>
...
# and then any command you want, for example:
akamai cps list --section <SECTION_NAME if not cps>
```

* Published Akamai Network lists 5.0.2