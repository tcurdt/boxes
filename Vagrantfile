Vagrant.configure("2") do |config|
    config.vm.box = "ubuntu-14.04-server"
    config.vm.box_url = "/Users/tcurdt/VMs/vagrant/trusty-server-cloudimg-amd64-vagrant-disk1.box"
    config.vm.hostname = 'vserver'
    config.ssh.forward_agent = true

    # config.ssh.username = 'root'
    # config.ssh.password = 'vagrant'
    # config.ssh.insert_key = 'true'

    # config.vm.network :public_network, bridge: "en0: Wi-Fi (AirPort)"
    # config.vm.network :forwarded_port, guest: 5000, host: 5000
    config.vm.network :private_network, type: "dhcp"

    # config.hosts.aliases = [
    #   'www.yourdailygeekery.com',
    #   'www.nursingthetravelbug.com',
    # ]

    config.vm.provider "virtualbox" do |v|
      v.name = "vserver"
      # config.vm.network :private_network, type: "dhcp", name: "vboxnet0", adapter: 2
    end

    config.vm.provision "ansible" do |ansible|
        ansible.playbook = "vserver.yml"
        # ansible.tags = [ 'test' ]
        # ansible.verbose = "v"
    end
end