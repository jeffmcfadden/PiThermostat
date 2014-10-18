# README

## Do these things:


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

    sudo -i -u postgres
    createuser rails -s -P
    exit

    sudo vim /etc/postgresql/9.1/main/pg_hba.conf

    # change all the 'peer' to 'md5'

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

    # this should work now:
    rails c production

    # setup your application.yml

    RAILS_ENV=production bundle exec rake assets:precompile

    bundle exec unicorn_rails -c config/unicorn.rb -E production -D