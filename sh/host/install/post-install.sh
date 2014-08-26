
echo "--- Install drush ---"
git clone https://github.com/drush-ops/drush.git /home/vagrant/drush
chmod u+x /home/vagrant/drush/drush
sudo ln -s /home/vagrant/drush/drush /usr/bin/drush
cd /home/vagrant/drush
composer install
cd ~

echo "--- add aliasses ---"
echo "# Add the vagrant .profile file" >> /home/vagrant/.profile
echo "source /vagrant/.profile" >> /home/vagrant/.profile

echo "--- Install vamp drush ---"
git clone https://github.com/stevenvdhout/Vamp-Drush.git /home/vagrant/drush/vamp
drush cc drush