# This script changes the code-server config file to allow access via 8080

if [ -e ~/.config/code-server/config.yaml ]
then
    echo "Code-server installation detected, proceeding"
else
    echo "config.yaml file not found, please install and enable code-server"
    exit
fi


echo -e "\e[31mWhat password would you like to set for access to code-server?\e[0m"

read -s password

cp ~/.config/code-server/config.yaml ~/.config/code-server/config.yaml.orig
echo "auth: password" > ~/.config/code-server/config.yaml
echo "bind-addr: 0.0.0.0:8080" >> ~/.config/code-server/config.yaml
echo "cert: true" >> ~/.config/code-server/config.yaml

salt=$(openssl rand -base64 12)

hashpassword=$(echo -n $password | argon2 $salt -e)

echo "hashed-password: $hashpassword" >> ~/.config/code-server/config.yaml
echo "Now restarting code-server to activate new settings. The config file can be edited at ~/config/code-server/config.yaml"
sudo systemctl restart code-server@$USER

echo "Configuring the firewall to allow port 8080"

sudo apt-get install ufw
sudo ufw allow 8080
