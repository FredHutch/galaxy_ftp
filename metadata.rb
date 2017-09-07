name 'galaxy_ftp'
maintainer 'Michael Gutteridge, Scientific Computing, Fred Hutchinson CRC'
maintainer_email 'mrg@fredhutch.org'
license 'mit'
description 'Install an FTP server for uploading data into a galaxy server'
long_description ''
version '0.2.2'
chef_version '>= 12.1' if respond_to?(:chef_version)
supports 'ubuntu'
issues_url 'https://github.com/../galaxy_ftp/issues' if respond_to?(:issues_url)
source_url 'https://github.com/../galaxy_ftp' if respond_to?(:source_url)

depends 'chef-vault'
