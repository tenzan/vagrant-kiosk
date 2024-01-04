Vagrant.configure("2") do |config|
  config.vm.box = "bento/ubuntu-18.04"

  # Provisioning script for setting up the environment
  config.vm.provision "shell", path: "scripts/setup.sh"

  config.vm.synced_folder "./scripts", "/vagrant/scripts"

  # Enable VirtualBox GUI
  config.vm.provider "virtualbox" do |vb|
    vb.cpus = 2
    vb.gui = true
    vb.memory = "1024"
  end
end
