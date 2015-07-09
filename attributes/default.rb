default[:docker2host][:name] = "myapp"
default[:docker2host][:registry] = "mylocalregistry.local/" # leave empty for dockerhub,
							    # put a / in the end for private registry
default[:docker2host][:image] = "image"
default[:docker2host][:version] = "v2"
default[:docker2host][:env] = ["VAR1=1","VAR2=2","DB=mysql://mydb:3316"]
default[:docker2host][:user] = "root" # user to run initcmd inside the 'container'
default[:docker2host][:initcmd] = "/bin/sh -c 'cd /apps; ./boot'"
default[:docker2host][:extramounts] = [] # extra mounts than /proc and /tmp ["/dev","/sys"] 
