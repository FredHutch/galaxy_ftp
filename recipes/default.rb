#
# Cookbook Name:: galaxy_ftp
# Recipe:: default
#
# Copyright (c) 2017 The Authors, All Rights Reserved.
#

include_recipe 'proftpd-ii'

package 'proftpd-mod-mysql'

proftpd_module 'mysql'

proftpd_vhost 'galaxy' do
  default_server true
  enable true
end
