#
# Cookbook Name:: freegeoip
# Attributes:: freegeoip
#
# Copyright 2014, NREL
#
# All rights reserved - Do Not Redistribute
#

default[:freegeoip][:version] = "3.0.4"
default[:freegeoip][:download_url] = "https://github.com/fiorix/freegeoip/releases/download/v#{node[:freegeoip][:version]}/freegeoip-#{node[:freegeoip][:version]}-linux-#{if(node[:kernel][:machine] == "x86_64") then "amd64" else "i386" end}.tar.gz"
default[:freegeoip][:download_checksum] = if(node[:kernel][:machine] == "x86_64") then "0d4f78cb731b435c71e2d3dcf0c42e482d36dbad244eb2c628f9b44966351655" else "0a4b17608f784cf183994cc1a84e0f7287f758510437a80f9c38dad591bfb377" end
default[:freegeoip][:addr] = ":8080"
default[:freegeoip][:user] = "www-data"
default[:freegeoip][:group] = "www-data"
default[:freegeoip][:log] = "/var/log/freegeoip.log"
default[:freegeoip][:log_rotate] = 30
