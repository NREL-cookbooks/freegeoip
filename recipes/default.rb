#
# Cookbook Name:: freegeoip
# Recipe:: default
#
# Copyright 2014, NREL
#
# All rights reserved - Do Not Redistribute
#

include_recipe "ark"
include_recipe "logrotate"
include_recipe "supervisor"

ark "freegeoip" do
  action :install
  url node[:freegeoip][:download_url]
  checksum node[:freegeoip][:download_checksum]
  version node[:freegeoip][:version]
  has_binaries ["freegeoip"]
  notifies :start, "supervisor_service[freegeoip]"
  notifies :restart, "supervisor_service[freegeoip]"
end

supervisor_service "freegeoip" do
  command "#{node[:ark][:prefix_bin]}/freegeoip -addr='#{node[:freegeoip][:addr]}'"
  action :enable
  autostart true
  autorestart true
  startretries 25
  startsecs 3
  stdout_logfile node[:freegeoip][:log]
  stderr_logfile "NONE"
  stdout_logfile_maxbytes "0"
  redirect_stderr true
  user node[:freegeoip][:user]
end

logrotate_app "freegeoip" do
  path node[:freegeoip][:log]
  frequency "daily"
  rotate node[:freegeoip][:log_rotate]
  create "644 #{node[:freegeoip][:user]} #{node[:freegeoip][:group]}"
  options %w(missingok compress delaycompress copytruncate notifempty)
end
