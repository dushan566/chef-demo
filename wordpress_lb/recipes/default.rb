#
# Cookbook Name:: wordpress_LB
package "haproxy" do
  action :install
end

pool_app_members = search("node","role:wordpress_app_role")
pool_db_members = search("node","role:wordpress_db_role")

template "/etc/haproxy/haproxy.cfg" do
  source "wordpress_lb.cfg.erb"
  owner "root"
  group "root"
  mode "0644"
  variables ({
    :pool_app_members => pool_app_members.uniq,
    :pool_db_members => pool_db_members.uniq
    })

end

service "haproxy" do
  action [:enable, :start]
end
