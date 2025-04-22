Vagrant.configure("2") do |config|
  config.vm.box = "hashicorp-education/ubuntu-24-04"

  # Provisionnement de base commun
  config.vm.provision "shell", path: "script/1-ip-forward-install.sh"
  config.vm.provision "shell", path: "script/2-modules-overlay-bridge.sh"
  config.vm.provision "shell", path: "script/3-containerd-install.sh"

  NODES = {
    "control-plane" => {
      "private_network" => "192.168.56.3",
      "public_network"  => "192.168.1.250"
    },
    "worker1" => {
      "private_network" => "192.168.56.4",
      "public_network"  => "192.168.1.251"
    },
    "worker2" => {
      "private_network" => "192.168.56.5",
      "public_network"  => "192.168.1.252"
    }
  }

  NODES.each do |name, network|
    config.vm.define name do |node|
      node.vm.hostname = name
      node.vm.network "private_network", ip: network["private_network"], auto_config: true
      node.vm.network "public_network", bridge: "enp4s0", ip: network["public_network"]

      node.vm.provision "shell", path: "script/4-kubeadm-kubelet-kubectl-install.sh"
      node.vm.provision "shell", inline: "sudo usermod -aG docker $USER"

      # Création de l'utilisateur avec mot de passe
      node.vm.provision "shell", inline: <<-SHELL
        useradd -m -s /bin/bash #{name}
        echo '#{name}:2025' | chpasswd
        usermod -aG sudo #{name}
        sed -i 's/^#\\?PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
        systemctl restart ssh
      SHELL

      node.vm.provider "virtualbox" do |v|
        v.name = name
        v.memory = 2048
        v.cpus = 2

        # Supprimer interface NAT si souhaité
        v.customize ["modifyvm", :id, "--nic1", "none"]
      end

      # Connexion SSH avec l'utilisateur personnalisé
      node.ssh.username = name
      node.ssh.password = "2025"
    end
  end
end

