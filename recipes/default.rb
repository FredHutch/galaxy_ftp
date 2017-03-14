#
# Cookbook Name:: galaxy_ftp
# Recipe:: default
#
# Copyright (c) 2017 The Authors, All Rights Reserved.
#

include_recipe 'proftpd-ii'

# Add postgres support to proftpd
package 'proftpd-mod-pgsql'
proftpd_module 'pgsql'

