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


## Setup

Before proceeding you'll need a Raspberry Pi running a recent version of raspbian that also has these services set up:

* Ruby (2.5.x)
* PostgreSQL
* WiringPi
* Nginx

For instructions on setting up your Raspberry Pi and installing the necessary prerequisite software see [PiSetup](https://github.com/mcfadden/PiSetup).

If you use PiSetup, also run the "Rails Misc" option and configure it as shown below:

* Application Name: thermostat
* Environment: production
* Web Server: Unicorn
* Systemd Scripts:
  * Sidekiq
  * Unicorn
* Create Nginx Configuration: Yes
* System Gems:
  * bundler
* Setup Logrotate: Yes
* Reboot Raspberry Pi: Yes

At this point, you are ready to install PiThermostat:

    git clone https://github.com/jeffmcfadden/PiThermostat.git /www/thermostat
    cd /www/thermostat
    bundle install
    # setup your application.yml:
    cp config/application.yml.sample config/application.yml
    nano config/application.yml
    # Change it as necessary, then save it
    bundle exec rake db:create db:schema:load db:migrate
    # install the thermostat.conf nginx config
    sudo cp /www/thermostat/install_misc/thermostat.conf /etc/nginx/sites-available/thermostat.conf
    # If you didn't use PiSetup, you'll need to run these:
    #   sudo rm /etc/nginx/sites-enabled/default
    #   sudo ln -s /etc/nginx/sites-available/$safeAppName.conf /etc/nginx/sites-enabled
    # install the crontab
    (crontab -l ; cat /www/thermostat/install_misc/crontab; echo) | crontab -
    # Precompile your assets
    bundle exec rake assets:precompile
    # Set up the pids directory
    mkdir /www/thermostat/pids/
    # Enable the one wire bus on GPIO
    grep "dtoverlay=w1-gpio" /boot/config.txt || echo "dtoverlay=w1-gpio" | sudo tee --append /boot/config.txt
    # Install the setup_1_wire_bus systemd service
    sudo cp /www/thermostat/install_misc/setup_1_wire_bus.service /lib/systemd/system/setup_1_wire_bus.service
    # Install the unicorn systemd service if you didn't use PiSetup
    # sudo cp /www/thermostat/install_misc/unicorn.service /lib/systemd/system/unicorn.service
    # Enable both services:
    sudo systemctl enable setup_1_wire_bus.service
    sudo systemctl enable unicorn.service
    # Reboot your pi:
    sudo shutdown -r now

Once it boots back up you should be able to follow the web based setup process by visiting http://[your raspberry pi]/

### Wiring

  The OneWire bus data line is on pin 4. You can view a wiring diagram for One Wire [here](https://pinout.xyz/pinout/1_wire)

  The GPIO pins used by default are 0, 1, and 2. We using the WiringPi pinout. [Here is a diagram](https://pinout.xyz/pinout/wiringpi).

  You may use other GPIO pins as long as they don't interfere with the OneWire bus, and as long as you update the pins referenced in `setup_1_wire_bus.service`.

  You may select which GPIO pins connect to `cool`, `heat`, and `fan` via the settings interface, so the specifics there do not matter.

  **Note**
  If you are using your OneWire bus in parasitic power mode, you need to change this line in `/boot/config.txt`

  Change `dtoverlay=w1-gpio` to `dtoverlay=w1-gpio,pullup=on`

  You will need to reboot for this to take effect.

### Debugging

  If things aren't working right, here are some log files you might want to look into:

  Syslog: `/var/log/syslog`
  Unicorn log: `/www/thermostat/log/unicorn.log`
  Rails log: `/www/thermostat/log/production.log`

  If you need to, you can also open a rails console:

    cd /www/thermostat && bundle exec rails c

## Upgrading

Upgrading from a previous version may involve these steps:

    cd /www/thermostat
    git pull
    bundle install
    bundle exec rake db:migrate
    bundle exec rake assets:precompile
    sudo shutdown -r now

Be sure to upgrade the homebridge plugin to the latest version as well
