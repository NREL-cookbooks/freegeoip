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

ark "freegeoip" do
  action :install
  url node[:freegeoip][:download_url]
  checksum node[:freegeoip][:download_checksum]
  version node[:freegeoip][:version]
  has_binaries ["freegeoip"]
  notifies :start, "poise_service[freegeoip]"
  notifies :restart, "poise_service[freegeoip]"
end

execute "supervisorctl reread" do
  action :nothing
end

file "/etc/supervisor.d/freegeoip.conf" do
  action :delete
  notifies :run, "execute[supervisorctl reread]", :immediately
end

poise_service "freegeoip" do
  command "#{node[:ark][:prefix_bin]}/freegeoip -addr='#{node[:freegeoip][:addr]}'"
  user node[:freegeoip][:user]
  if(Chef::Platform::ServiceHelpers.service_resource_providers.include?(:systemd))
    provider :systemd
  else
    provider :sysvinit
  end
  action [:enable, :start]
end

logrotate_app "freegeoip" do
  path node[:freegeoip][:log]
  frequency "daily"
  rotate node[:freegeoip][:log_rotate]
  create "644 #{node[:freegeoip][:user]} #{node[:freegeoip][:group]}"
  options %w(missingok compress delaycompress copytruncate notifempty)
end
