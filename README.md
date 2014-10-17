# README

## Do these things:


    sudo modprobe w1-gpio
    sudo modprobe w1-therm
    gpio mode 0 out
    gpio mode 1 out

## Unicorn

    bundle exec unicorn_rails -c config/unicorn.rb -E production -D