#!/bin/bash
# Version: 1.0

#Check .env file
if 
    [ ! -f .env ]; then 
    echo -e "\e[31m[ERROR]: .env file missing\e[0m"
    echo -e "\e[31mCreating .env file from example...\e[0m"
    cp .env.example .env
    echo -e "\e[32m.env file created successfully. Please edit the .env file with your configuration before running the script again.\e[0m"
    exit 1
fi

#Pause prompt function
pause_prompt() {
    echo -e "\nPress Enter to continue..."
    read
}

#Discord Webhook URL for notifications
WEBHOOK_URL=$(grep WEBHOOK_URL .env | cut -d '=' -f2)

#File Directories
PTERODACTYL_LOG="/var/www/pterodactyl/storage/logs/laravel-$(date +%F).log"
PAYMENTER_LOG="/var/www/paymenter/storage/logs/laravel-$(date +%F).log"
WINGS_LOG="/var/log/pterodactyl/wings.log"

### Script Start ###

while true; do
    clear

figlet "Sentinel Dashboard" | lolcat
echo -e ""
echo "Welcome to Sentinel Dashboard, your all-in-one server management tool!" | lolcat
echo "This dashboard allows you to monitor and manage your server with ease." | lolcat
echo "Please select an option from the menu below to get started." | lolcat
echo -e ""
echo -e "Time: $(date '+%I:%M %p') | Date: $(date '+%d/%m/%Y')" | lolcat

#Main Menu
echo "---------------------------------------------------"
echo "  1) System Update & Maintenance"
echo "  2) Server Status"
echo "  3) Check Log Files (Pterodactyl & Paymenter)"
echo "  4) Check System Resources (CPU/RAM/Disk)"
echo "  5) Network Status"
echo "  6) Exit"
echo "---------------------------------------------------"
read -p "Command > " choice

case $choice in
    1)
        echo ""
        echo ">>> Starting System Update & Maintenance..." | lolcat
        sudo apt update -y
        sudo apt upgrade -y
        sudo apt full-upgrade -y

        echo ""
        
        echo ">>> Cleaning up..." | lolcat
        sudo apt autoremove -y
        sudo apt autoclean -y
        echo ""
        echo "System update and maintenance completed." | lolcat
        discord_message="Sentinel Dashboard: System update and maintenance completed successfully."
        curl -H "Content-Type: application/json" -X POST -d "{\"content\": \"$discord_message\"}" $WEBHOOK_URL
        pause_prompt
        ;;
    2)
        echo ""
        echo -e ">>> Checking Server Status..." | lolcat
        echo ""
        if systemctl is-active --quiet nginx; then
            echo -e "\e[32m[SUCCESS] Nginx is active and running.\e[0m"
            echo ""
        else
            echo -e "\e[31m[ERROR]Nginx is not active. Please investigate.\e[0m"
            echo ""
        fi
        if systemctl is-active --quiet mysql; then
            echo -e "\e[32m[SUCCESS] MySQL is active and running.\e[0m"
            echo ""
        else
            echo -e "\e[31m[ERROR] MySQL is not active. Please investigate.\e[0m"
            echo ""
        fi
        if systemctl is-active --quiet docker; then
            echo -e "\e[32m[SUCCESS] Docker is active and running.\e[0m"
            echo ""
        else
            echo -e "\e[31m[ERROR] Docker is not active. Please investigate.\e[0m"
            echo ""
        fi
        if systemctl is-active --quiet wings; then
            echo -e "\e[32m[SUCCESS] Wings is active and running.\e[0m"
            echo ""
        else
            echo -e "\e[31m[ERROR] Wings is not active. Please investigate.\e[0m"
            echo ""
        fi
        echo "All services checked. If any service is not active, please investigate further." | lolcat
        discord_message="Sentinel Dashboard: Server status check completed. Please review the output for any issues."
        curl -H "Content-Type: application/json" -X POST -d "{\"content\": \"$discord_message\"}" $WEBHOOK_URL
        pause_prompt
        ;;
    3)
        echo ""
        echo ">>> Checking Log Files..." | lolcat
        echo ""
        echo "Pterodactyl Logs:" | lolcat
        tail -n 100 $PTERODACTYL_LOG
        echo ""
        echo -e "\nPaymenter Logs:"
        tail -n 100 $PAYMENTER_LOG
        echo ""
        echo "Wings Logs:"
        tail -n 100 $WINGS_LOG
        echo ""
        echo "All log files checked. Please review the output for any issues." | lolcat
        discord_message="Sentinel Dashboard: Log file check completed. Please review the output for any issues."
        curl -H "Content-Type: application/json" -X POST -d "{\"content\": \"$discord_message\"}" $WEBHOOK_URL
        pause_prompt
        ;;
    4)
        echo ""
        echo ">>> Checking System Resources..." | lolcat
        echo ""
        echo "CPU Usage:" | lolcat
        top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1"%"}'
        echo ""
        echo "RAM Usage:" | lolcat
        free -h | grep "Mem" | awk '{print "Used: "$3" / Total: "$2}'
        echo ""
        echo "Disk Usage:" | lolcat
        df -h --total | grep "total" | awk '{print "Used: "$3" / Total: "$2}'
        echo ""
        discord_message="Sentinel Dashboard: System resource check completed. Please review the output for any issues."
        curl -H "Content-Type: application/json" -X POST -d "{\"content\": \"$discord_message\"}" $WEBHOOK_URL
        pause_prompt
        ;;

    5)
        echo ""
        echo ">>> Checking Network Status..." | lolcat
        echo ""
        echo "Currently listening on the following network interfaces:" | lolcat
        ss -tulpn
        echo ""
        echo "Firewall Status:" | lolcat
        sudo ufw status
        echo ""
        echo "Machine IP Address:" | lolcat
        ip address show | grep "inet " | grep -v "127.0.0.1/8" | awk '{print $2}' | cut -d '/' -f1
        echo ""
        echo "Network status check completed. Please review the output for any issues."
        discord_message="Sentinel Dashboard: Network status check completed. Please review the output for any issues."
        curl -H "Content-Type: application/json" -X POST -d "{\"content\": \"$discord_message\"}" $WEBHOOK_URL
        pause_prompt
        ;;

    6)  
        echo "Exiting Sentinel Dashboard. Goodbye!" | lolcat
        exit 0
        ;;    
    *)
        echo "Invalid option. Please try again."
        ;;
esac
done

### SCRIPT END ###