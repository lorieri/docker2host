node.set[:docker2host][:registry] = "myregistry.local/"
node.set[:docker2host][:name] = "myhack"
node.set[:docker2host][:version] = "v3"
node.set[:docker2host][:env] = [
            "PORT=5000",
            "HOME=/app",
            "MEMPORT=11211",
            "DBHOST=mydb.local",
            "DB=mydb",
            "DBPASS=pass",
            "DEIS_APP=myhack",
            "DBUSER=root",
            "MEMHOST=mymemcached.local"
	]
node.set[:docker2host][:user] = "slug"

# you must load the automatic generated environment-core file and run the command with the right user
# sometimes images has no sudo
node.set[:docker2host][:initcmd] = "/bin/sh -c '. /environment-core ; . /environment ; /runner/init start web'"

# include /dev and /sys if necessary
node.set[:docker2host][:extramounts] = ["/dev","/sys"]

include_recipe "docker2host::systemd"

# to check status use: machinectl list, machinectl show {name}
# to start/stop use: systemctl start docker2host-{name}
