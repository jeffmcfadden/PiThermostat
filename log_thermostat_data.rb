# Run these first:
# sudo modprobe w1-gpio
# sudo modprobe w1-therm
cmd = "curl -silent -X POST --data \"\" http://127.0.0.1/log_current_data"
system( cmd )
