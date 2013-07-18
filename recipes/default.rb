#
# Cookbook Name:: chef_solo
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

puts <<-HERE

  .oooooo.   ooooo   ooooo oooooooooooo oooooooooooo       .oooooo..o   .oooooo.   ooooo          .oooooo.   
 d8P'  `Y8b  `888'   `888' `888'     `8 `888'     `8      d8P'    `Y8  d8P'  `Y8b  `888'         d8P'  `Y8b  
888           888     888   888          888              Y88bo.      888      888  888         888      888 
888           888ooooo888   888oooo8     888oooo8          `"Y8888o.  888      888  888         888      888 
888           888     888   888    "     888    "              `"Y88b 888      888  888         888      888 
`88b    ooo   888     888   888       o  888              oo     .d8P `88b    d88'  888       o `88b    d88' 
 `Y8bood8P'  o888o   o888o o888ooooood8 o888o             8""88888P'   `Y8bood8P'  o888ooooood8  `Y8bood8P'

This recipe must be run first.  It adds the databag mixin. FYI: You are a databag.

HERE

Directory "/root/.ssh" do
  action :create
  mode 0700
end

File "/root/.ssh/config" do
  action :create
  content "Host *\nStrictHostKeyChecking no"
  mode 0600
end

ruby_block "Give root access to the forwarded ssh agent" do
  block do
    # find a parent process' ssh agent socket
    agents = {}
    ppid = Process.ppid
    Dir.glob('/tmp/ssh*/agent*').each do |fn|
      agents[fn.match(/agent\.(\d+)$/)[1]] = fn
    end
    while ppid != '1'
      if (agent = agents[ppid])
        ENV['SSH_AUTH_SOCK'] = agent
        break
      end
      File.open("/proc/#{ppid}/status", "r") do |file|
        ppid = file.read().match(/PPid:\s+(\d+)/)[1]
      end
    end
    # Uncomment to require that an ssh-agent be available
    # fail "Could not find running ssh agent - Is config.ssh.forward_agent enabled in Vagrantfile?" unless ENV['SSH_AUTH_SOCK']
  end
  action :create
end
