.SILENT:

# Variables
SERVICE_NAME = Oignon
COLOR_RED = \033[0;31m
COLOR_GREEN = \033[0;32m
COLOR_BLUE = \033[0;34m
COLOR_YELLOW = \033[0;33m
COLOR_RESET = \033[0m

# Messages
INFO = echo "$(COLOR_YELLOW)[INFO]$(COLOR_RESET)"
SUCCESS = echo "$(COLOR_GREEN)[SUCCESS]$(COLOR_RESET)"
ERROR = echo "$(COLOR_RED)[ERROR]$(COLOR_RESET)"

# Targets
.PHONY: all clear tor_setup nginx_setup update deps start clean

all: start

clear:
	$(INFO) "Clearing the terminal..."
	clear
	$(SUCCESS) "Terminal cleared."

tor_setup:
	$(INFO) "$(COLOR_BLUE)Starting Tor setup...$(COLOR_RESET)"
	$(INFO) "Enabling and starting Tor service..."
	sudo systemctl enable tor && sudo systemctl start tor
	$(INFO) "Creating Tor service directory..."
	sudo mkdir -p /var/lib/tor/$(SERVICE_NAME)
	sudo chown -R debian-tor:debian-tor /var/lib/tor/$(SERVICE_NAME)
	sudo chmod 700 /var/lib/tor/$(SERVICE_NAME)
	$(INFO) "Checking for torrc configuration file..."
	if [ -f ./files/torrc ]; then \
		$(INFO) "Copying torrc to /etc/tor/torrc..."; \
		sudo cp ./files/torrc /etc/tor/torrc; \
	else \
		$(ERROR) "torrc file not found. Skipping Tor configuration."; \
	fi
	$(INFO) "Checking for sshd_config file..."
	if [ -f ./files/sshd_config ]; then \
		$(INFO) "Copying sshd_config to /etc/ssh/sshd_config..."; \
		sudo cp ./files/sshd_config /etc/ssh/sshd_config; \
	else \
		$(ERROR) "sshd_config file not found. Skipping SSH configuration."; \
	fi
	$(INFO) "Restarting Tor service..."
	sudo systemctl restart tor
	$(SUCCESS) "Tor setup completed."

nginx_setup:
	$(INFO) "$(COLOR_BLUE)Starting Nginx setup...$(COLOR_RESET)"
	$(INFO) "Enabling and starting Nginx service..."
	sudo systemctl enable nginx && sudo systemctl start nginx
	$(INFO) "Checking for index.html file..."
	if [ -f ./files/index.html ]; then \
		$(INFO) "Copying index.html to /var/www/html/index.html..."; \
		sudo cp ./files/index.html /var/www/html/index.html; \
		$(SUCCESS) "Nginx setup completed."; \
	else \
		$(ERROR) "index.html not found. Skipping Nginx setup."; \
	fi

update:
	$(INFO) "$(COLOR_BLUE)Updating system packages...$(COLOR_RESET)"
	$(INFO) "Running apt-get update and upgrade..."
	sudo apt-get update && sudo apt-get upgrade -y
	$(SUCCESS) "System packages updated successfully."

deps:
	$(INFO) "$(COLOR_BLUE)Installing dependencies...$(COLOR_RESET)"
	$(INFO) "Installing vim, nginx, and tor..."
	sudo apt install -y vim nginx tor
	$(SUCCESS) "Dependencies installed successfully."

start: clear update deps tor_setup nginx_setup
	$(INFO) "$(COLOR_BLUE)Starting $(SERVICE_NAME) setup...$(COLOR_RESET)"
	$(SUCCESS) "$(SERVICE_NAME) setup completed successfully."

clean:
	$(INFO) "$(COLOR_BLUE)Cleaning up...$(COLOR_RESET)"
	$(INFO) "Performing cleanup tasks..."
	# Add cleanup commands here if needed
	$(SUCCESS) "Cleanup completed."