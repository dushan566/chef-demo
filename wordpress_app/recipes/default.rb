########## Install Packages #################
package "httpd" do
  action :install
end

package "php" do
  action :install
end

package "php-mysql" do
  action :install
end

package "wget" do
  action :install
end

########## Download wordpress ###############
remote_file '/root/wordpress-4.4.2.tar.gz' do
  source 'http://wordpress.org/latest.tar.gz'
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

########## Create Document Root ##############
directory '/var/www/html/wordpress.example.com' do
  owner 'apache'
  group 'apache'
  mode '0774'
  action :create
end

#### Extract and copy files to Document Root #####
execute 'cd /root; tar -xzf wordpress-4.4.2.tar.gz; cp -rf /root/wordpress/* /var/www/html/wordpress.example.com'

#### Create Vhost for wordpress with custom port ###
template '/etc/httpd/conf.d/wordpress.conf' do
  source 'wordpress.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
end

############### Copy DB config file ###############
pool_members = search("node","role:wordpress_lb_role")
template '/var/www/html/wordpress.example.com/wp-config.php' do
  source 'wp-config.php.erb'
  owner 'root'
  group 'root'
  mode '0644'
  variables :pool_members => pool_members.uniq
end

template "/etc/hosts" do
  source "hosts.erb"
  owner "root"
  group "root"
  mode "0644"
end


########## Create media files upload directory ##############
directory '/var/www/html/wordpress.example.com/wp-content/uploads' do
  owner 'apache'
  group 'apache'
  mode '0774'
  action :create
end

service "httpd" do
  action [:enable, :start]
  supports :reload => true
end
