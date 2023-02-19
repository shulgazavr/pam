Vagrant.configure(2) do |config|
    config.vm.box = "centos/7"
    config.vm.box_version = "2004.01"
  
  
   config.vm.provider "virtualbox" do |v|
      v.memory = 1024
      v.cpus = 1
  end
   config.vm.define "srv" do |srv|
      srv.vm.network "private_network", ip: "192.168.56.200", virtualbox__intnet: "net1"
      srv.vm.network :forwarded_port, guest: 22, host: 3000
      srv.vm.hostname = "srv"
      srv.vm.provision "shell", inline: <<-SHELL
            mkdir -p ~root/.ssh; cp ~vagrant/.ssh/auth* ~root/.ssh
            sed -i '65s/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
            systemctl restart sshd
          SHELL
  end
end