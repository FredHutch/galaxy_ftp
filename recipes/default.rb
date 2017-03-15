#
# Cookbook Name:: galaxy_ftp
# Recipe:: default
#
# Copyright (c) 2017 The Authors, All Rights Reserved.
#

include_recipe 'chef-vault::default'

db_uri = chef_vault_item(node['galaxy_ftp']['vault_name'], 'db')['uri']
db_user = chef_vault_item(node['galaxy_ftp']['vault_name'], 'db')['user']
db_user_pw = chef_vault_item(node['galaxy_ftp']['vault_name'], 'db')['user_pw']

galaxy_user = chef_vault_item(node['galaxy_ftp']['vault_name'], 'galaxy')['user']
galaxy_uid = chef_vault_item(node['galaxy_ftp']['vault_name'], 'galaxy')['uid']
galaxy_group = chef_vault_item(node['galaxy_ftp']['vault_name'], 'galaxy')['group']
galaxy_gid = chef_vault_item(node['galaxy_ftp']['vault_name'], 'galaxy')['gid']
galaxy_upload_dir = chef_vault_item(node['galaxy_ftp']['vault_name'], 'galaxy')['upload_dir']

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
    'db_user_pw' => db_user_pw,
    'galaxy_user' => galaxy_user,
    'galaxy_uid' => galaxy_uid,
    'galaxy_group' => galaxy_group,
    'galaxy_gid' => galaxy_gid,
    'galaxy_upload_dir' => galaxy_upload_dir
  )
  source 'vhost/galaxy-ftp.erb'
  notifies :create, "link[#{node['proftpd-ii']['conf_dir']}/sites-enabled/galaxy-ftp.conf]", :immediate
end

link "#{node['proftpd-ii']['conf_dir']}/sites-enabled/galaxy-ftp.conf" do
  to "#{node['proftpd-ii']['conf_dir']}/sites-available/galaxy-ftp.conf" 
  link_type :symbolic
  action :nothing
end
