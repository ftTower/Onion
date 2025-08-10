.SILENT:

SERVICE_NAME = Oignon
COLOR_RED = \033[0;31m
COLOR_GREEN = \033[0;32m
COLOR_BLUE = \033[0;34m
COLOR_RESET = \033[0m

init:
	echo "🟨 $(COLOR_BLUE) Updating for Tor setup... $(COLOR_RESET)"
	sudo apt-get update && sudo apt-get upgrade -y && sudo apt install vim nginx tor -y 

	echo "🟩 $(COLOR_BLUE) Starting Tor setup... $(COLOR_RESET)"