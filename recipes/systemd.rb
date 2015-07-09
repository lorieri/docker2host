name  = node[:docker2host][:name]

if File.exist?("/var/lib/container/#{name}/.dockerenv") == false
        include_recipe "docker2host::import"
end

binds = ""
node[:docker2host][:extramounts].each do |bind|
	binds += " --bind=#{bind}:#{bind} "
end

# create the systemd template unit
template "/usr/lib/systemd/system/docker2host-#{name}.service" do
	source "systemd.erb"
	mode "0755"
	owner "root"
	group "root"
	variables({
		"initcmd" => node[:docker2host][:initcmd],
		"name"    => node[:docker2host][:name],
		"user"    => node[:docker2host][:user],
		"binds"   => binds
	})
end

# create service
execute "systemctl enable docker2host-#{name}" do
	action :run
end

execute "systemctl start docker2host-#{name}" do
	action :run
end

# how to enter the container:
# machinectl show #{name} 
# nsenter -m -u -i -n -p -t $PID
