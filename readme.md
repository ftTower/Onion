# 🧅 Onion Web Server

A web server configured to run on the Tor network, allowing you to host web and SSH services accessible via `.onion` addresses.

## 📋 Table of Contents

- [Prerequisites](#prerequisites)
- [Server Installation](#server-installation)
- [Client Installation](#client-installation)
- [Usage](#usage)
- [Architecture](#architecture)
- [Security](#security)
- [Troubleshooting](#troubleshooting)

## 🔧 Prerequisites

### Recommended Operating System
- **Debian 13.0.0** (amd64-netinst)
- Download: [Debian ISO](https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-13.0.0-amd64-netinst.iso)

### Initial Configuration
For optimal functionality (such as shared clipboard in VMs), install your hypervisor's guest additions.

### User Permissions
Before starting, ensure your user has sudo privileges:

```bash
su -
usermod -aG sudo <your_username>
```

Log out and log back in to apply the changes.

## 🚀 Server Installation

### Quick Installation

```bash
apt-get install git -y && \
git clone https://github.com/ftTower/Onion.git Onion && \
cd Onion && \
make start
```

### What the Installation Does

The `make start` script automatically performs:

1. **System Update**: `apt-get update && upgrade`
2. **Dependencies Installation**: `vim`, `nginx`, `tor`, `wget`, `curl`, `torsocks`
3. **Tor Configuration**:
   - Enables and starts the Tor service
   - Creates the service directory `/var/lib/tor/Oignon`
   - Configures appropriate permissions
   - Copies the custom `torrc` configuration
4. **Nginx Configuration**:
   - Enables and starts the web server
   - Deploys the custom web page
5. **SSH Configuration**:
   - Configures SSH to work via Tor
   - Applies security settings

### Retrieving Your .onion Address

![Ouput](https://github.com/ftTower/ftTower/blob/main/assets/Oignon/server-output.png)
At the end of the installation, your `.onion` address will be displayed. You can also retrieve it at any time:

```bash
sudo cat /var/lib/tor/Oignon/hostname
```

## 💻 Client Installation

To test and access Onion services from another machine:

```bash
apt-get install git -y && \
git clone https://github.com/ftTower/Onion.git Onion && \
cd Onion && \
make client
```

### What the Client Installation Does

1. Updates the system and installs dependencies
2. Configures and starts the Tor service
3. Downloads and installs Tor Browser (version 14.5.5)
4. Automatically launches Tor Browser

## 📖 Usage

### Accessing the Website via Tor Browser

1. Install the Tor client (see above)
2. Launch Tor Browser
3. Enter your server's `.onion` address in the address bar

![tor](https://github.com/ftTower/ftTower/blob/main/assets/Oignon/oignon-site.png)

### SSH Connection via Tor

To connect to your server via SSH over the Tor network:

```bash
torsocks ssh username@your-address.onion
```

Replace:
- `username` with your username on the server
- `your-address.onion` with the address obtained during installation

## 🏗️ Architecture

### Project Structure

```
Onion/
├── Makefile           # Automation scripts
├── readme.md          # Documentation
└── files/
    ├── index.html     # Default web page
    ├── sshd_config    # SSH configuration
    ├── tor.service    # Systemd service for Tor
    └── torrc          # Tor configuration
```

### Deployed Services

- **Nginx**: Web server on port 80 (local)
- **Tor**: Anonymous routing service
- **SSH**: Secure remote access via Tor

## 🔒 Security

### Best Practices

1. **Keep the system updated**:
   ```bash
   make update
   ```

2. **Use strong passwords** for SSH accounts

3. **Monitor the logs**:
   ```bash
   sudo journalctl -u tor -f
   sudo journalctl -u nginx -f
   ```

4. **Backup your Tor private key**:
   ```bash
   sudo cp -r /var/lib/tor/Oignon ~/backup-tor-keys
   ```

### Warning

This project is for educational and demonstration purposes. Make sure you understand the legal and security implications of hosting services on the Tor network in your jurisdiction.

## 🔍 Troubleshooting

### Tor Won't Start

```bash
sudo systemctl status tor
sudo journalctl -u tor -n 50
```

Check that the `/etc/tor/torrc` file is correctly configured.

### .onion Address Not Generated

```bash
# Check permissions
sudo ls -la /var/lib/tor/Oignon

# Restart Tor
sudo systemctl restart tor

# Wait a few seconds and check
sudo cat /var/lib/tor/Oignon/hostname
```

### Nginx Not Serving the Page

```bash
sudo systemctl status nginx
sudo nginx -t  # Test configuration
```

### Unable to Connect via SSH

1. Check that the SSH service is active:
   ```bash
   sudo systemctl status ssh
   ```

2. Verify that Tor is correctly routing SSH traffic (see `/etc/tor/torrc`)

## 📝 Available Make Commands

- `make start`: Complete server installation
- `make client`: Tor Browser client installation
- `make update`: System update
- `make deps`: Dependencies installation only
- `make tor_setup`: Tor configuration only
- `make nginx_setup`: Nginx configuration only
- `make clear`: Clear the terminal

## 📄 License

This project is distributed for educational purposes.

## 👤 Author

**ftTower**
- GitHub: [@ftTower](https://github.com/ftTower)
