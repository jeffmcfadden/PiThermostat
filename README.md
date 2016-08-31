README
======
The software to use a RaspberryPi as a Thermostat for just about any HVAC unit or component. Works great for window A/C units and space heaters as well as Central HVAC Units. If you can get access to the power or control wires for your device, you can probably wire it up.

## Equipment ##

*  Raspberry Pi (v2): http://amzn.to/1IvY1WU
*  Case: http://amzn.to/1IbG2Ic
*  Power Adapter: http://amzn.to/1IbG3Mw
*  SD Card: http://amzn.to/1JXDUlF
*  Relay Board: http://amzn.to/1M3HMaE
*  Temperature Sensors: http://amzn.to/1JDZhg1 (Any DS18B20 sensor will work)


## Do these things after boot:

    sudo modprobe w1-gpio
    sudo modprobe w1-therm
    gpio mode 0 out
    gpio write 0 1
    gpio mode 1 out
    gpio write 1 1
    gpio mode 2 out
    gpio write 2 1
    gpio mode 3 out
    gpio write 3 1

## Unicorn


    Start:

    bundle exec unicorn_rails -c config/unicorn.rb -E production -D

    Restart:

    sudo kill -HUP `cat /www/thermostat/pids/unicorn.pid`

    OR

    sudo restart unicorn # If you're using upstart


## Setting up the Pi:

    sudo apt-get update

    mkdir installs
    cd installs
    sudo apt-get install git
    git clone https://github.com/ruby/ruby.git
    cd ruby
    git checkout tags/v2_1_3
    sudo apt-get install autoconf
    autoconf
    sudo apt-get install gcc g++ make ruby1.9.1 bison libyaml-dev libssl-dev libffi-dev zlib1g-dev libxslt-dev libxml2-dev libpq-dev zip nodejs vim libreadline-dev
    ./configure && make clean && make && sudo make install

    sudo apt-get install postgresql postgresql-contrib libpq-dev

    # Install WiringPi: http://wiringpi.com/download-and-install/

    sudo -i -u postgres
    createuser -s -P rails
    exit

    sudo vim /etc/postgresql/9.4/main/pg_hba.conf

    # change all the 'peer' to 'md5' NOT THE LOCAL ONE, LEAVE TO TRUST OR EVERYTHING BREAKS

    sudo service postgresql restart

    sudo mkdir /www
    sudo chown pi:pi /www
    cd /www
    sudo git clone https://github.com/jeffmcfadden/PiThermostat.git
    mv PiThermostat thermostat
    cd thermostat
    echo "install: --no-rdoc --no-ri" >> ~/.gemrc
    echo "update:  --no-rdoc --no-ri" >> ~/.gemrc
    sudo gem install bundler
    bundle install
    RAILS_ENV=production bundle exec rake db:create
    RAILS_ENV=production bundle exec rake db:migrate

    sudo apt-get install nginx

    # install the thermostat.conf
    # install the crontab

    sudo nginx
    # After this I had to remove 'default' from /etc/init/nginx/sites-enabled

    # this should work now:
    rails c production

    # Setup your thermostat on the console.

    # setup your application.yml - see config/application.yml.sample for a sample

    RAILS_ENV=production bundle exec rake assets:precompile

    mkdir /www/thermostat/pids/

    # RPi 2 (or any kernel 3.18.8 and higer)
    # You have to edit your /boot/config.txt file and add this at the bottom:
    # dtoverlay=w1-gpio

    # reboot
    sudo shutdown -r now

    # If you want to run everything now:
    bundle exec unicorn_rails -c config/unicorn.rb -E production -D

    # Upstart

    sudo apt-get install upstart # Yes, it's okay, even given the warning.

    # Copy the unicorn.conf file to /etc/init
    # Copy the setup_1_wire_bus.conf file to /etc/init

    # Reboot for Upstart to take effect.
    sudo shutdown -r now

    # Once Running, follow the web based setup process.

## Upgrading

Upgrading from a previous version may involve these steps:

    cd /www/thermostat
    git pull
    RAILS_ENV=production bundle install
    RAILS_ENV=production bundle exec rake db:migrate
    sudo shutdown -r now

Be sure to upgrade the homebridge plugin to the latest version as well