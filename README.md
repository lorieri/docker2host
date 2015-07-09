# docker2host

Simple cookbook to run an application from a Docker image *NOT* using the Docker daemon, chroot or systemd-nspawn instead.

## Usage

Create a recipe setting the attributes:

```
node.set[:docker2host][:registry] = "myregistry.local/" # leave empty for Docker Hub
node.set[:docker2host][:name] = "myhack"
node.set[:docker2host][:image] = "lorieri/myhack"
node.set[:docker2host][:version] = "v3"
node.set[:docker2host][:env] = [
            "PORT=5000",
            "HOME=/app",
            "MEMPORT=11211",
            "DBHOST=mydb.local",
            "DB=mydb",
            "DBPASS=pass",
            "DBUSER=root",
            "MEMHOST=mymemcached.local"
	]
node.set[:docker2host][:user] = "slug"
node.set[:docker2host][:initcmd] = "/bin/sh -c '. /environment-core ; . /environment ; /runner/init start web'"
node.set[:docker2host][:extramounts] = ["/dev","/sys"]
```

Then include the chroot or systemd-nspawn recipe (pick one, don't use both):

```
# for systemd-nspawn ...
include_recipe "docker2host::systemd"

# ... or chroot
include_recipe "docker2host::chroot"
```

## Settings

* **registry**: Docker registry repository url ending with /, or leave empty for Docker Hub
* **name**: a name for your 'service'
* **image**: Docker image name
* **version**: Docker image version
* **env**: list of the environment variables, ```docker inspect --format='{{.Config.Env}}'```
* **user**: user to run the 'initcmd', ```docker inspect --format='{{.Config.User}}'```
* **initcmd**: a command line combining WorkingDir, Entrypoint, CMD and the load of the environment files created by this cookbook in the root of your 'service' (/environment and /environment-core)
* **extramounts**: list of extra mounts necessary for your image to run, ie: ["/dev","/sys"]

## Systemd-nspawn 

To check the status of your systemd-nspawn container use:

```
$ sudo machinectl list
$ sudo machinectl show {name}
```

To start, stop or check the status using systemd:

```
$ sudo systemctl status docker2host-{name}
$ sudo systemctl stop docker2host-{name}
$ sudo systemctl start docker2host-{name}
```

## Chroot

For chroot the cookbook provides /etc/init.d script that suports start, stop and status

```
$ sudo /etc/init.d/docker2host-{name} status
$ sudo /etc/init.d/docker2host-{name} stop
$ sudo /etc/init.d/docker2host-{name} start
```

## To Do
* remove,update
