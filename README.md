# README

## Do these things:


    sudo modprobe w1-gpio
    sudo modprobe w1-therm
    gpio mode 0 out
    gpio write 0 1
    gpio mode 1 out
    gpio write 1 1

## Unicorn

    bundle exec unicorn_rails -c config/unicorn.rb -E production -D