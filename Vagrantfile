Vagrant.configure("2") do |config|
  # set image iso
  config.vm.box = "hashicorp-education/ubuntu-24-04"

  # Set some variables
  etcHosts = ""
  
  # set servers list and their parameters
  NODES = [
    {:hostname => "haproxy-1.k8s.xdevopps.local", :ip => "192.168.39.10", :cpus => "2", :mem => "2048", :type => "proxy"},
    {:hostname => "haproxy-2.k8s.xdevopps.local", :ip => "192.168.39.11", :cpus => "2", :mem => "2048", :type => "proxy"},
    {:hostname => "master-1.k8s.xdevopps.local", :ip => "192.168.39.12", :cpus => "2", :mem => "2048", :type => "master"},
    {:hostname => "master-2.k8s.xdevopps.local", :ip => "192.168.39.13", :cpus => "2", :mem => "2048", :type => "master"},
  ]

  # set /etc/hosts servername
  NODES.each do |node|
    etcHosts += "echo '" +node[:ip] + "  " +node[:hostname] +"' >> /etc/hosts" + "\n"
  end

  # run and installation
  NODES.each do |node|
    config.vm.define node[:hostname] do |machine|
      machine.vm.network "private_network", ip: node[:ip]

      machine.vm.provider "virtualbox" do |vbox|
        vbox.customize ["modifyvm", :id, "--memory", node[:mem]]
        vbox.customize ["modifyvm", :id, "--name", node[:hostname]] 
      end # end vbox

      machine.vm.provision :shell, :inline => etcHosts
      machine.vm.provision "shell" do |s|
        ssh_pub_key = File.readlines("#{Dir.home}/.ssh/id_ed25519.pub").first.strip
        s.inline = <<-SHELL
          echo #{ssh_pub_key} >> /home/vagrant/.ssh/authorized_keys
          echo #{ssh_pub_key} >> /root/.ssh/authorized_keys
        SHELL
      end # end provision

    end # end machine

  end # end node
end
