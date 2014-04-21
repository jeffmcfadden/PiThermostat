# Run these first:
# sudo modprobe w1-gpio
# sudo modprobe w1-therm
cmd = "curl -silent http://127.0.0.1/thermostats/1/log_current_data"
system( cmd )
