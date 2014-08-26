#!/bin/bash
echo "--- Updating packages list ---"
sudo apt-get update > /dev/null 2>&1

echo "--- setting MySQL variables ---"
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'

echo "--- Installing base packages ---"
sudo apt-get install -y vim curl python-software-properties git sshpass > /dev/null 2>&1

#echo "--- We want the bleeding edge of PHP ---"
#sudo add-apt-repository -y ppa:ondrej/php5 > /dev/null 2>&1

#echo "--- Updating packages list ---"
#sudo apt-get update > /dev/null 2>&1


echo "--- Installing PHP-specific packages ---"
sudo apt-get install -y php5 apache2 libapache2-mod-php5 php5-curl php5-gd php5-mcrypt mysql-server-5.5 php5-mysql git-core > /dev/null 2>&1


echo "--- Install phpmyadmin ---"
echo "phpmyadmin phpmyadmin/dbconfig-install boolean true" | debconf-set-selections
echo "phpmyadmin phpmyadmin/app-password-confirm password root" | debconf-set-selections
echo "phpmyadmin phpmyadmin/mysql/admin-pass password root" | debconf-set-selections
echo "phpmyadmin phpmyadmin/mysql/app-pass password root" | debconf-set-selections
echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect none" | debconf-set-selections
sudo apt-get -y install phpmyadmin > /dev/null 2>&1

echo "--- Installing and configuring Xdebug ---"
sudo apt-get install -y php5-xdebug > /dev/null 2>&1

cat << EOF | sudo tee -a /etc/php5/mods-available/xdebug.ini
xdebug.scream=0
xdebug.cli_color=1
xdebug.show_local_vars=1
EOF

echo "--- Enabling mod-rewrite ---"
sudo a2enmod rewrite

echo "--- Configure php ---"
sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php5/apache2/php.ini
sed -i "s/display_errors = .*/display_errors = On/" /etc/php5/apache2/php.ini
sed -i "s/memory_limit = .*/memory_limit = 256M/" /etc/php5/apache2/php.ini
sed -i "s/max_input_time = .*/max_input_time = 180/" /etc/php5/apache2/php.ini
sed -i "s/max_execution_time = .*/max_execution_time = 300/" /etc/php5/apache2/php.ini
sed -i "s/post_max_size = .*/post_max_size = 1024M/" /etc/php5/apache2/php.ini
sed -i "s/upload_max_filesize = .*/upload_max_filesize = 1024M/" /etc/php5/apache2/php.ini


echo "--- Configure MySQL ---" 
sed -i "s/max_allowed_packet = .*/max_allowed_packet = 1024M/" /etc/mysql/my.cnf
sed -i "s/skip-external-locking/skip-external-locking\\nskip-name-resolve/" /etc/mysql/my.cnf

echo "--- Configure Apache ---" 
sed -i 's/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf
echo "ServerName vamp:80" >> /etc/apache2/apache2.conf
echo "ServerAdmin lord-of-server@calibrate.be" >> /etc/apache2/apache2.conf
echo "IncludeOptional /vagrant/vhosts/*.conf" >> /etc/apache2/apache2.conf
sed -i "s/DocumentRoot \/var\/www\/html/DocumentRoot \/var\/www/" /etc/apache2/sites-available/000-default.conf


echo "--- Restarting Apache ---"
sudo service apache2 restart

echo "--- Install composer. ---"
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer

sed -i '1i export PATH="$HOME/.composer/vendor/bin:$PATH"' $HOME/.bashrc

source $HOME/.bashrc




