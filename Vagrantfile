Vagrant.configure("2") do |config|
  # Set base box
  config.vm.box = "hashicorp-education/ubuntu-24-04"

  # Hosts entries to be provisioned later
  etcHosts = ""

  # Define the node configuration
  NODES = [
    {:hostname => "haproxy-1.k8s.xdevopps.local", :ip => "192.168.39.10", :cpus => "1", :mem => "1024", :type => "proxy", :state => "MASTER"},
    {:hostname => "haproxy-2.k8s.xdevopps.local", :ip => "192.168.39.11", :cpus => "1", :mem => "1024", :type => "proxy", :state => "BACKUP"},
  ]

  # Prepare /etc/hosts content
  NODES.each do |node|
    if node[:type] != "proxy"
      etcHosts += "echo '#{node[:ip]}  #{node[:hostname]}' >> /etc/hosts\n"
    else
      etcHosts += "echo '#{node[:ip]}  #{node[:hostname]} autoelb.kub' >> /etc/hosts\n"
    end
  end

  # VM configuration loop
  NODES.each do |node|
    config.vm.define node[:hostname] do |machine|
      machine.vm.network "private_network", ip: node[:ip]
      machine.vm.hostname = node[:hostname]

      machine.vm.provider "virtualbox" do |vbox|
        vbox.customize ["modifyvm", :id, "--memory", node[:mem]]
        vbox.customize ["modifyvm", :id, "--name", node[:hostname]]
      end

      # Configuration spécifique pour les noeuds proxy
      if node[:type] == "proxy"
        # Installation des paquets
        machine.vm.provision "install_keepalived_haproxy", type: "shell", inline: <<-SHELL
          sudo apt update
          sudo apt install -y keepalived haproxy
        SHELL

        # Copier les fichiers de configuration vers /tmp
        machine.vm.provision "file", source: "configs/keepalived.conf", destination: "/tmp/keepalived.conf"
        machine.vm.provision "file", source: "configs/http-haproxy.cfg", destination: "/tmp/haproxy.cfg"

        # Déplacement vers les bons emplacements
        machine.vm.provision "move_configs", type: "shell", inline: <<-SHELL
          sudo mv /tmp/keepalived.conf /etc/keepalived/keepalived.conf
          sudo mv /tmp/haproxy.cfg /etc/haproxy/haproxy.cfg
        SHELL

        # Adapter la configuration pour BACKUP
        if node[:state] != "MASTER"
          machine.vm.provision "set_backup_state", type: "shell", inline: <<-SHELL
            sudo sed -i 's/^ *state MASTER/state BACKUP/' /etc/keepalived/keepalived.conf
            sudo sed -i 's/^ *priority 100/priority 90/' /etc/keepalived/keepalived.conf
          SHELL
        end
      end

      # Activer les services
      machine.vm.provision "enable_services_keepalived", type: "shell", inline: <<-SHELL
        sudo systemctl enable keepalived
        sudo systemctl start keepalived
        sudo systemctl enable haproxy
        sudo systemctl start haproxy
      SHELL
      # Ajouter les lignes /etc/hosts
      machine.vm.provision "hosts_update", type: "shell", inline: etcHosts

      # Ajout de la clé SSH
      machine.vm.provision "add_ssh_key", type: "shell" do |s|
        ssh_pub_key = File.readlines("#{Dir.home}/.ssh/id_ed25519.pub").first.strip
        s.inline = <<-SHELL
          echo '#{ssh_pub_key}' >> /home/vagrant/.ssh/authorized_keys
          echo '#{ssh_pub_key}' >> /root/.ssh/authorized_keys
        SHELL
      end
    end
  end
end
