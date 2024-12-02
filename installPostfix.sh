#!/bin/bash

# Update and install required packages
sudo apt update && sudo apt install -y mailutils postfix libsasl2-modules

# Update Postfix configuration
echo "Updating Postfix configuration..."
POSTFIX_MAIN_CF="/etc/postfix/main.cf"
sudo chmod 777 $POSTFIX_MAIN_CF

# Remove all occurrences of smtp_tls_security_level
sudo sed -i '/^smtp_tls_security_level =/d' $POSTFIX_MAIN_CF

# Add necessary configuration
cat <<EOL | sudo tee -a $POSTFIX_MAIN_CF
relayhost = [smtp.gmail.com]:587
smtp_sasl_password_maps = hash:/etc/postfix/sasl/sasl_passwd
smtp_sasl_auth_enable = yes
smtp_tls_security_level = encrypt
smtp_sasl_security_options = noanonymous
EOL

# Create sasl directory and sasl_passwd file
SASL_DIR="/etc/postfix/sasl"
sudo mkdir -p $SASL_DIR
SASL_PASSWD_FILE="$SASL_DIR/sasl_passwd"

echo "Creating sasl_passwd file..."
read -p "Enter your email address: " EMAIL
read -sp "Enter your app password: " APP_PASSWORD
printf "\n[smtp.gmail.com]:587 $EMAIL:$APP_PASSWORD\n" | sudo tee $SASL_PASSWD_FILE

# Convert sasl_passwd to a .db file
sudo postmap $SASL_PASSWD_FILE

# Set proper permissions
sudo chmod 600 $SASL_PASSWD_FILE $SASL_PASSWD_FILE.db
sudo chmod 644 $POSTFIX_MAIN_CF

# Restart Postfix service
sudo systemctl restart postfix

# Check Postfix status
sudo systemctl status postfix

# Completion message
echo "Postfix setup completed successfully."
