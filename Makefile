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
	clear

tor_setup:
	$(INFO) "$(COLOR_BLUE)Setting up Tor...$(COLOR_RESET)"
	sudo systemctl enable tor && sudo systemctl start tor
	sudo mkdir -p /var/lib/tor/$(SERVICE_NAME)
	sudo chown -R debian-tor:debian-tor /var/lib/tor/$(SERVICE_NAME)
	sudo chmod 700 /var/lib/tor/$(SERVICE_NAME)
	if [ -f ./files/torrc ]; then \
		sudo cp ./files/torrc /etc/tor/torrc; \
	else \
		$(ERROR) "torrc file not found. Skipping Tor configuration."; \
	fi
	if [ -f ./files/sshd_config ]; then \
		sudo cp ./files/sshd_config /etc/ssh/sshd_config; \
	else \
		$(ERROR) "sshd_config file not found. Skipping SSH configuration."; \
	fi
	sudo systemctl restart tor
	$(SUCCESS) "Tor setup completed."

nginx_setup:
	$(INFO) "$(COLOR_BLUE)Setting up Nginx...$(COLOR_RESET)"
	sudo systemctl enable nginx && sudo systemctl start nginx
	if [ -f ./files/index.html ]; then \
		sudo cp ./files/index.html /var/www/html/index.html; \
		$(SUCCESS) "Nginx setup completed."; \
	else \
		$(ERROR) "index.html not found. Skipping Nginx setup."; \
	fi

update:
	$(INFO) "$(COLOR_BLUE)Updating system packages...$(COLOR_RESET)"
	sudo apt-get update && sudo apt-get upgrade -y
	$(SUCCESS) "System packages updated successfully."

deps:
	$(INFO) "$(COLOR_BLUE)Installing dependencies...$(COLOR_RESET)"
	sudo apt install -y vim nginx tor
	$(SUCCESS) "Dependencies installed successfully."

start: clear update deps tor_setup nginx_setup
	$(INFO) "$(COLOR_BLUE)Starting $(SERVICE_NAME) setup...$(COLOR_RESET)"
	$(SUCCESS) "$(SERVICE_NAME) setup completed successfully."

clean:
	$(INFO) "$(COLOR_BLUE)Cleaning up...$(COLOR_RESET)"
	# Add cleanup commands here if needed
	$(SUCCESS) "Cleanup completed."