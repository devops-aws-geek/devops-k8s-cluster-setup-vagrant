VAGRANTFILE_API_VERSION = "2"

$k8s_master = <<ENDSCRIPT
  echo -e "100.0.0.4 master.ethans.com master\n100.0.0.5 worker.ethans.com worker" | sudo tee -a /etc/hosts
  sudo apt-get update
  sudo apt install docker.io -y
  sudo systemctl enable docker
  sudo systemctl start  docker
  sudo systemctl status docker
  sudo ufw disable
  sudo swapoff -a
  sudo apt-get install -y apt-transport-https ca-certificates curl gpg 
  mkdir -p /etc/apt/keyrings/
  curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
  echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
  sudo apt update 
  sudo apt install -y kubelet kubeadm kubectl
  sudo systemctl enable kubelet
  sudo systemctl start kubelet
  sudo kubeadm init --apiserver-advertise-address=100.0.0.4 --pod-network-cidr=100.244.0.0/16 > $HOME/kubeadm_init.log 2>&1
  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config
  wget https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml -O $HOME/kube-flannel.yml
ENDSCRIPT

$k8s_worker = <<SCRIPT
  echo -e "100.0.0.4 master.ethans.com master\n100.0.0.5 worker.ethans.com worker" | sudo tee -a /etc/hosts
  sudo apt-get update
  sudo apt install docker.io -y
  sudo systemctl enable docker
  sudo systemctl start  docker
  sudo systemctl status docker
  sudo ufw disable
  sudo swapoff -a
  sudo apt-get install -y apt-transport-https ca-certificates curl gpg 
  mkdir -p /etc/apt/keyrings/
  curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
  echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
  sudo apt update 
  sudo apt install -y kubelet kubeadm kubectl
  sudo systemctl enable kubelet
  sudo systemctl start kubelet
SCRIPT

Vagrant.configure("2") do |config|
    config.vm.define "master" do |master|
      master.vm.box_download_insecure = true    
      master.vm.box = "bento/ubuntu-24.04"        ## For ubuntu 18.04 use - hashicorp/bionic64
      master.vm.box_version = "202404.26.0"
      master.vm.network "private_network", ip: "100.0.0.4"
      master.vm.hostname = "master"
      master.vm.provider "virtualbox" do |v|
        v.name = "master"
        v.memory = 2048
        v.cpus = 2
        v.customize ["modifyvm", :id, "--uart1", "0x3F8", "4"]
        v.customize ["modifyvm", :id, "--uartmode1", "file", File::NULL]
      end
      master.vm.provision "shell", inline: $k8s_master
    end
  
    config.vm.define "worker" do |worker|
      worker.vm.box_download_insecure = true 
      worker.vm.box = "bento/ubuntu-24.04"        ## For ubuntu 18.04 use - hashicorp/bionic64
      worker.vm.box_version = "202404.26.0"
      worker.vm.network "private_network", ip: "100.0.0.5"
      worker.vm.hostname = "worker"
      worker.vm.provider "virtualbox" do |v|
        v.name = "worker"
        v.memory = 1024
        v.cpus = 1
        v.customize ["modifyvm", :id, "--uart1", "0x3F8", "4"]
        v.customize ["modifyvm", :id, "--uartmode1", "file", File::NULL]
      end
      worker.vm.provision "shell", inline: $k8s_worker
    end
  
  end
  
