#
# Cookbook Name:: wordpress_db
package 'mysql-server' do
  action :install
end

service 'mysqld' do
  action [:enable, :start]
end

template '/root/db-user.sql' do
  source "db-user.sql.erb"
  mode "0775"
end

#execute "/usr/bin/mysqladmin -u root password 'root123456'; mysql -u root -p 'root123456' < /root/db-user.sql"
execute "mysql < /root/db-user.sql ; /usr/bin/mysqladmin -u root password 'root123456'"

service 'mysqld' do
  action :restart
end
