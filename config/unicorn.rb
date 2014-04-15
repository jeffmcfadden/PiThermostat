# Set the working application directory
# working_directory "/path/to/your/app"
working_directory "/www/thermostat"

# Unicorn PID file location
# pid "/path/to/pids/unicorn.pid"
pid "/www/thermostat/pids/unicorn.pid"

# Path to logs
# stderr_path "/path/to/log/unicorn.log"
# stdout_path "/path/to/log/unicorn.log"
stderr_path "/www/thermostat/log/unicorn.log"
stdout_path "/www/thermostat/log/unicorn.log"

# Unicorn socket
#listen "/tmp/unicorn..sock"
listen "/tmp/unicorn.thermostat.sock"

# Number of processes
# worker_processes 4
worker_processes 2

# Time-out
timeout 30
