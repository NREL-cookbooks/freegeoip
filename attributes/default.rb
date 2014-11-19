#
# Cookbook Name:: freegeoip
# Attributes:: freegeoip
#
# Copyright 2014, NREL
#
# All rights reserved - Do Not Redistribute
#

node.default[:freegeoip][:path] = "/opt/freegeoip"
node.default[:freegeoip][:addr] = ":8080"
node.default[:freegeoip][:user] = "www-data"
node.default[:freegeoip][:group] = "www-data"
node.default[:freegeoip][:log] = "/var/log/freegeoip.log"
node.default[:freegeoip][:log_rotate] = 30
