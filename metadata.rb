name 'galaxy_ftp'
maintainer 'Michael Gutteridge, Scientific Computing, Fred Hutchinson CRC'
maintainer_email 'mrg@fredhutch.org'
license 'mit'
description 'Install an FTP server for uploading data into a galaxy server'
long_description ''
version '0.1.4'

issues_url 'https://github.com/../galaxy_ftp/issues' if respond_to?(:issues_url)
source_url 'https://github.com/../galaxy_ftp' if respond_to?(:source_url)

depends 'proftpd-ii', '~> 0.5.3'
depends 'chef-vault'
