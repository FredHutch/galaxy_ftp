#
# Cookbook Name:: galaxy_ftp
# Recipe:: default
#
# Copyright (c) 2017 The Authors, All Rights Reserved.
#

package [
  'proftpd',
  'proftpd-mod-pgsql',
  'samba-common',
  'samba-common-bin',
  'samba-libs',
  'cifs-utils'
]

include_recipe 'chef-vault::default'

db_uri = chef_vault_item(node['galaxy_ftp']['vault_name'], 'db')['uri']
db_user = chef_vault_item(node['galaxy_ftp']['vault_name'], 'db')['user']
db_user_pw = \
  chef_vault_item(node['galaxy_ftp']['vault_name'], 'db')['user_pw']
galaxy_user = \
  chef_vault_item(node['galaxy_ftp']['vault_name'], 'galaxy')['user']
galaxy_uid = chef_vault_item(node['galaxy_ftp']['vault_name'], 'galaxy')['uid']
galaxy_group = \
  chef_vault_item(node['galaxy_ftp']['vault_name'], 'galaxy')['group']
galaxy_gid = \
  chef_vault_item(node['galaxy_ftp']['vault_name'], 'galaxy')['gid']
galaxy_upload_dir = \
  chef_vault_item(node['galaxy_ftp']['vault_name'], 'galaxy')['upload_dir']

# Add configuration from template

template '/etc/proftpd/proftpd.conf' do
  owner 'proftpd'
  group 'root'
  mode 0o0440
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
  source 'galaxy-ftp.erb'
end

# mount galaxy upload directory via smbmount
#
# `mount_config` contains the remote file system device name, username, domain,
# and password
#

mount_config = chef_vault_item(
  node['galaxy_ftp']['vault_name'],
  'mount_config'
)

template "/etc/samba/.credentials.#{mount_config['username']}" do
  owner 'root'
  group 'root'
  mode '0600'
  variables(
    'username' => mount_config['username'],
    'password' => mount_config['password'],
    'domain' => mount_config['domain']
  )
  source 'credentials.erb'
end

option_list = [
  "credentials=/etc/samba/.credentials.#{mount_config['username']}",
  "uid=#{galaxy_uid}",
  "gid=#{galaxy_gid}",
  'file_mode=0644',
  'dir_mode=0755'
]

mount galaxy_upload_dir do
  device mount_config['device']
  fstype 'cifs'
  options option_list.join(',')
  action [:enable]
end
