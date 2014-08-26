echo "--- upgrade ruby ---"
curl -sSL https://get.rvm.io | bash -s stable
source /home/vagrant/.rvm/scripts/rvm

rvm install ruby-2.1.1
rvm use 2.1.1 --default 

echo "--- install bundler ---"
gem update --system
sudo gem install bundler