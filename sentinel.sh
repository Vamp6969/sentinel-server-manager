#!/bin/bash
# Version: 1.0

#Install Dependencies for Sentinel

#Pause prompt function
pause_prompt() {
    echo -e "\nPress Enter to continue..."
    read
}

#Discord Webhook URL for notifications (replace with your actual webhook URL)
WEBHOOK_URL=$(grep WEBHOOK_URL .env | cut -d '=' -f2)

### Script Start ###

clear

echo -e "\e[0;31m" # Red Color
figlet "Sentinel Dashboard" | lolcat
echo -e "\e[97m" # White Color
echo "Welcome to Sentinel Dashboard, your all-in-one server management tool!" | lolcat
echo "This dashboard allows you to monitor and manage your server with ease." | lolcat
echo "Please select an option from the menu below to get started." | lolcat
echo -e "Time: $(date '+%I:%M %p') | Date: $(date '+%d/%m/%Y')"

#Main Menu
echo "---------------------------------------------------"
echo "  1) System Update & Maintenance"
echo "  2) Server Status"
echo "  3) Check Log Files (Pterodactyl & Paymenter)"
echo "  4) Check System Resources (CPU/RAM/Disk)"
echo "---------------------------------------------------"
read -p "Command > " choice

case $choice in
    1)
        echo ""
        echo ">>> Starting System Update & Maintenance..."
        sudo apt update -y
        sudo apt upgrade -y
        sudo apt full-upgrade -y
        
        echo ">>> Cleaning up..."
        sudo apt autoremove -y
        sudo apt autoclean -y
        echo "System update and maintenance completed."
        discord_message="Sentinel Dashboard: System update and maintenance completed successfully."
        curl -H "Content-Type: application/json" -X POST -d "{\"content\": \"$discord_message\"}" $WEBHOOK_URL
        pause_prompt
        ;;
    2)
        echo ""
        echo ">>> Checking Server Status..."
        if systemctl is-active --quiet nginx; then
            echo "Nginx is active and running." | lolcat
        else
            echo "Nginx is not active. Please investigate." | lolcat
        fi
        if systemctl is-active --quiet mysql; then
            echo "MySQL is active and running." | lolcat
        else
            echo "MySQL is not active. Please investigate." | lolcat
        fi
        if systemctl is-active --quiet docker; then
            echo "Docker is active and running." | lolcat
        else
            echo "Docker is not active. Please investigate." | lolcat
        fi
        if systemctl is-active --quiet pterodactyl; then
            echo "Pterodactyl is active and running." | lolcat
        else
            echo "Pterodactyl is not active. Please investigate." | lolcat
        fi
        echo "All services checked. If any service is not active, please investigate further."
        discord_message="Sentinel Dashboard: Server status check completed. Please review the output for any issues."
        curl -H "Content-Type: application/json" -X POST -d "{\"content\": \"$discord_message\"}" $WEBHOOK_URL
        pause_prompt
        ;;
    3)
        echo ""
        echo ">>> Checking Log Files..."
        echo "Pterodactyl Logs:"
        tail -n 100 /var/www/pterodactyl/storage/logs/laravel-$(date +%F).log | lolcat
        echo ""
        echo -e "\nPaymenter Logs:"
        cd /var/www/paymenter && php artisan app:logs | lolcat
        echo "Wings Logs:"
        tail -n 100 /var/log/pterodactyl/wings.log | lolcat
        echo "All log files checked. Please review the output for any issues."
        discord_message="Sentinel Dashboard: Log file check completed. Please review the output for any issues."
        curl -H "Content-Type: application/json" -X POST -d "{\"content\": \"$discord_message\"}" $WEBHOOK_URL
        pause_prompt

        ;;
    4)
        echo ""
        echo ">>> Checking System Resources..."
        echo "CPU Usage:"
        top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1"%"}' | lolcat
        echo ""
        echo "RAM Usage:"
        free -h | grep "Mem" | awk '{print "Used: "$3" / Total: "$2}' | lolcat
        echo "System resources checked. Please review the output for any issues."
        echo "Disk Usage:"
        df -h | grep -E '^/dev/sd' | awk '{print $1": Used "$3" / Total "$2" ("$5" used)"}' | lolcat
        discord_message="Sentinel Dashboard: System resource check completed. Please review the output for any issues."
        curl -H "Content-Type: application/json" -X POST -d "{\"content\": \"$discord_message\"}" $WEBHOOK_URL
        pause_prompt
        ;;
    *)
        echo "Invalid option. Please try again."
        ;;
esac
