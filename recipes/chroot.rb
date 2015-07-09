name  = node[:docker2host][:name]

if File.exist?("/var/lib/container/#{name}/.dockerenv") == false
	include_recipe "docker2host::import"
end

# create the systemd template unit
template "/etc/init.d/docker2host-#{name}" do
	source "chroot-init.erb"
	mode "0755"
	owner "root"
	group "root"
	variables({
		"initcmd" => node[:docker2host][:initcmd],
		"name"    => node[:docker2host][:name],
		"binds"   => node[:docker2host][:extramounts],
		"user"    => node[:docker2host][:user]
	})
end

# create service
service "docker2host-#{name}" do
	action [:enable, :start]
	supports [:start, :stop, :restart, :status]
end
