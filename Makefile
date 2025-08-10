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
.PHONY: all updating dep starting clean

all: starting

tor_setup:
	sudo systemctl enable tor && sudo systemctl start tor && sudo systemctl status tor && echo
	sudo mkdir -p /var/lib/tor/$(SERVICE_NAME)
	sudo chown -R debian-tor:debian-tor /var/lib/tor/$(SERVICE_NAME)
	sudo chmod 700 /var/lib/tor/$(SERVICE_NAME)

nginx_setup:
	sudo systemctl enable nginx && sudo systemctl start nginx && sudo systemctl status nginx && echo
	sudo cp ./index.html /var/www/html/index.html

updating:
	$(INFO) "$(COLOR_BLUE)Updating system packages...$(COLOR_RESET)"
	sudo apt-get update && sudo apt-get upgrade -y && \
	$(SUCCESS) "System packages updated successfully."

dep:
	$(INFO) "$(COLOR_BLUE)Installing dependencies...$(COLOR_RESET)"
	sudo apt install -y vim nginx tor && \
	$(SUCCESS) "Dependencies installed successfully."

starting: updating dep tor_setup nginx_setup
	$(INFO) "$(COLOR_BLUE)Starting Tor setup...$(COLOR_RESET)"	
	
	$(SUCCESS) "$(SERVICE_NAME) setup completed successfully."

clean:
	$(INFO) "$(COLOR_BLUE)Cleaning up...$(COLOR_RESET)"
	# Add cleanup commands here if needed
	$(SUCCESS) "Cleanup completed."