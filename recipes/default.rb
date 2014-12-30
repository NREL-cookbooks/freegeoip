#
# Cookbook Name:: freegeoip
# Recipe:: default
#
# Copyright 2014, NREL
#
# All rights reserved - Do Not Redistribute
#

include_recipe "golang"
include_recipe "logrotate"
include_recipe "supervisor"

bash "install_freegeoip" do
  code <<-EOS
    export PATH=#{node[:go][:install_dir]}/go/bin:$PATH
    export GOPATH=#{node[:freegeoip][:path]}
    mkdir -p #{node[:freegeoip][:path]}
    cd #{node[:freegeoip][:path]}
    go get github.com/fiorix/freegeoip
    go get github.com/fiorix/freegeoip/cmd/freegeoip
  EOS
  notifies :restart, "supervisor_service[freegeoip]"
  not_if { File.exists?(File.join(node[:freegeoip][:path], "bin/freegeoip")) }
end

supervisor_service "freegeoip" do
  command "#{node[:freegeoip][:path]}/bin/freegeoip -addr='#{node[:freegeoip][:addr]}'"
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
