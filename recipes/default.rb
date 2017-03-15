#
# Cookbook Name:: galaxy_ftp
# Recipe:: default
#
# Copyright (c) 2017 The Authors, All Rights Reserved.
#

include_recipe 'chef-vault::default'
db_uri = chef_vault_item(node['galaxy_ftp']['vault'], 'db')['uri']
db_user = chef_vault_item(node['galaxy_ftp']['vault'], 'db')['user']
db_user_pw = chef_vault_item(node['galaxy_ftp']['vault'], 'db')['user_pw']

include_recipe 'proftpd-ii'

# Add postgres support to proftpd
package 'proftpd-mod-pgsql'

proftpd_module 'sql'
proftpd_module 'sql_passwd'
proftpd_module 'sql_postgres'
#
# Add vhost configuration from template

template "#{node['proftpd-ii']['conf_dir']}/sites-available/galaxy-ftp.conf" do
  owner node['proftpd-ii']['user']
  group node['proftpd-ii']['group']
  mode 0640
  variables(
    'db_uri' => db_uri,
    'db_user' => db_user,
    'db_user_pw' => db_user_pw
  )
  source 'vhost/galaxy-ftp.erb'
  notifies :create, "link[#{node['proftpd-ii']['conf_dir']}/sites-enabled/galaxy-ftp.conf]", :immediate
end

link "#{node['proftpd-ii']['conf_dir']}/sites-enabled/galaxy-ftp.conf" do
  to "#{node['proftpd-ii']['conf_dir']}/sites-available/galaxy-ftp.conf" 
  link_type :symbolic
  action :nothing
end
