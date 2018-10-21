Vagrant.configure("2") do |config|
  config.vm.box = "centos-7.4-x86_64-minimal"
  config.vm.define "web" do |web|
    web.vm.hostname = "web"
    web.vm.network "private_network", ip: "192.168.1.2"
    web.vm.provision 'shell', path: "scriptweb.sh"
    web.vm.provider "virtualbox" do |vb|
      vb.name = "web"
      vb.memory = "1024"
    end
  end
  
  config.vm.define "node1" do |node|
    node.vm.hostname = "node1"
    node.vm.network "private_network", ip: "192.168.1.3"
    node.vm.provision 'shell', path: "scriptnode1.sh"
    node.vm.provider "virtualbox" do |vb|
      vb.name = "node1"
      vb.memory = "2048"
    end
  end
  
  config.vm.define "node2" do |node|
    node.vm.hostname = "node2"
    node.vm.network "private_network", ip: "192.168.1.4"
    node.vm.provision 'shell', path: "scriptnode2.sh"
    node.vm.provider "virtualbox" do |vb|
      vb.name = "node2"
      vb.memory = "2048"
    end
  end 
end
