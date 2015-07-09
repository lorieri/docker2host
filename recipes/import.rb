include_recipe "docker"

name     = node[:docker2host][:name]
env	 = node[:docker2host][:env]
version  = node[:docker2host][:version]
registry = node[:docker2host][:registry] 
image    = node[:docker2host][:image]

directory "/var/lib/container/#{name}" do
	action :create
	mode "0755"
	owner "root"
	group "root"
	recursive  true  # <--- recursive
end

execute "create_container" do
	command "docker rm #{name} ;  docker create --name #{name} #{registry}#{image}:#{version}"
	action :run
end

execute "export_container" do
	command "docker export  #{name}  > /var/lib/container/#{name}/image.tar"
	action :run
end

# untar image
execute "untar_image" do
	command "cd /var/lib/container/#{name}/ && tar -xf image.tar"
	action :run
end

execute "get_core_vars" do
	command "docker inspect --format='{{.Config.Env}}' #{name} |
		sed 's/ /\\nexport /g' |sed 's/\\[/export /'|sed 's/\\]//' > \\
		/var/lib/container/#{name}/environment-core"
	action :run
end

# set a environment file for confs
template "/var/lib/container/#{name}/environment" do
	source "environment.erb"
	mode "0644"
	owner "root"
	group "root"
	variables({
		"env" => env
	})
end
