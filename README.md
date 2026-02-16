#  Sentinel Server Manager

Sentinel is a lightweight, modular Bash-based dashboard designed for Systems Engineers and Game Server Admins. It streamlines server maintenance, monitors critical services (Nginx, Docker, Pterodactyl), and provides real-time system resource tracking—all with integrated Discord notifications.

##  Features

-   **System Maintenance:** Automates `apt` updates, upgrades, and cleanup.
-   **Service Monitoring:** One-click status checks for Nginx, MySQL, Docker, and Pterodactyl/Wings.
-   **Log Analysis:** Quickly view the latest logs for Pterodactyl, Paymenter, and Wings.
-   **Resource Tracking:** Real-time CPU, RAM, and Disk usage statistics.
-   **Discord Integration:** Sends status reports and maintenance alerts directly to your Discord channel via Webhooks.
-   **Visual Interface:** Clean, color-coded terminal UI using `figlet` and `lolcat`.

##  Prerequisites

-   **OS:** Ubuntu/Debian-based Linux distribution.
-   **Permissions:** Root or sudo access required for system maintenance and service checks.

##  Installation

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/Vamp6969/sentinel-server-manager.git
    cd sentinel-server-manager
    ```

2.  **Run the Setup Script:**
    This will install necessary dependencies like `figlet`, `lolcat`, and `htop`.
    ```bash
    chmod +x setup.sh
    sudo ./setup.sh
    ```

3.  **Configure Environment Variables:**
    Create a `.env` file to store your Discord Webhook URL securely.
    ```bash
    echo "WEBHOOK_URL=your_discord_webhook_here" > .env
    ```

##  Usage

Make the main script executable and run it:

```bash
chmod +x sentinel.sh
./sentinel.sh
```

##  Security

This project uses a `.env` file to manage sensitive data. The `.gitignore` file is configured to prevent your webhook URLs from being leaked to public repositories. **Never commit your `.env` file.**

##  Contributing

Contributions, issues, and feature requests are welcome! Feel free to check the [issues page](https://github.com/Vamp6969/sentinel-server-manager/issues).

---
*Built with ❤️ by Tushar A. (Vamp)*
