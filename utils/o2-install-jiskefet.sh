#!/bin/bash

# Convenience script for deploying the flp-standalone role
# It expects the following arguments
# - the target hostname,
# - the connecting user,
# - the with-tests flag (optional)
#
# It takes care of the following:
# 1) It copies the local ssh key to set up passwordless root SSH
#
# 2) It creates the /tmp/ansible-flp-host inventory file
#
# 3) It executes the ansible-playbook command for the role
#
# The values of the ANSIBLE_HTTP_PROXY and ANSIBLE_HTTPS_PROXY 
# env vars will be passed to the relevant playbook 
#
hostname=$1
withtests=$3
application_name_default="Logbook ITS"
database_host_default="localhost"
database_username_default="jiskefet"
database_password_default="abd1516812"
database_database_default="jiskefetdb"
database_root_password_default="abd1516812"
oauth_client_id_default=""
oauth_client_secret_default=""
jwt_secret_key_default="0K52HEZrFCiA2wWAfjyt58wbLRe25yCU"
egroup_default=""
ssh_root_user_default="root"

SSH_PORT=22
HOSTFILE_PATH="hosts.txt"
ANSIBLEPATH="../"
TXT_RED='\033[0;31m'
TXT_BLUE='\033[0;34m'
TXT_ORANGE='\033[0;33m'
TXT_GREEN='\033[0;32m'
TXT_NC='\033[0m' # No Color

help() {
  echo -e "\nUsage:\n$0 (hostname) \n"
}

if [[ ( $1 == "--help" ) ||  ( $1 == "-h" ) ]] 
then 
  help
  exit 0
fi


echo "################################################################################";
echo "######################## Jiskefet Ansible Installation #########################";
echo "################################################################################";

echo -e "\n${TXT_BLUE}Server settings:${TXT_NC}"

if [ -z "$hostname" ]
then
    while [ -z "$hostname" ]
    do
        printf "\tHostname: ";
        read -r hostname

        if [ -z "$hostname" ]
        then
            echo -e "\t${TXT_RED}Please enter a hostname${TXT_NC}"
        fi
    done
else
    echo -e "\tHostname: $hostname... done ✅ ";
fi

echo -ne "\tTesting SSH connection to $hostname on port $SSH_PORT... ";

nc_output=$(nc -z $hostname $SSH_PORT 2>&1)

if [[ $nc_output != *"succeeded"* ]]
then
    echo "❌ ";
    echo -e "\t${TXT_RED}Connection failed, error: \"$nc_output\", script stopped.${TXT_NC}"
    exit
else
    echo " done ✅ ";
fi

printf "\tSSH root username [$ssh_root_user_default]: ";
read -r ssh_root_username
ssh_root_username=${ssh_root_username:-"$ssh_root_user_default"}

printf "\tSSH root password: ";
read -s ssh_root_password

echo -ne "\n\t${TXT_GREEN}Copying SSH keys... ${TXT_NC}";

# Automation of ssh-copy-id with root user and password, adds host to known_hosts and tries password
ssh_copy_output=$(/usr/bin/expect -c 'eval spawn ssh-copy-id '"$ssh_root_username"'@'"$hostname"'; expect "Are you sure you want to continue connecting (yes/no)?" {send "yes\r"}; expect "Password:" {send "'"$ssh_root_password"'\r"}; expect eof;' 2>&1)

if [[ $ssh_copy_output == *"already exist"* ]]
then
    echo -e " already added, done ✅ ";
elif [[ $ssh_copy_output == *"key(s) added"* ]]
then
    echo -e " done ✅ ";
else
    echo -e " error ❌ ";
    echo -e "\t${TXT_RED}Failed to copy ssh keys, error: \"$ssh_copy_output\", script stopped.${TXT_NC}"
    if [[ $ssh_copy_output == *"Password: " ]]
    then
        echo -e "⚠️   ️Most likely wrong username or password";
    fi
    exit
fi


echo -e "\n${TXT_BLUE}Database settings:${TXT_NC}";

printf "\tHost [$database_host_default]: ";
read -r database_host
database_host=${database_host:-"$database_host_default"}

printf "\tUsername [$database_username_default]: ";
read -r database_username
database_username=${database_username:-"$database_username_default"}

printf "\tPassword [$database_password_default]: ";
read -r database_password
database_password=${database_username:-"$database_password_default"}

printf "\tDatabase [$database_database_default]: ";
read -r database_database
database_database=${database_database:-"$database_database_default"}

printf "\tRoot password [$database_root_password_default]: ";
read -r database_root_password
database_root_password=${database_root_password:-"$database_root_password_default"}

echo -e "\n${TXT_BLUE}Website settings:${TXT_NC}";

printf "\tApplication name [$application_name_default]: ";
read -r application_name
application_name=${application_name:-"$application_name_default"}

printf "\tUse CERN SSO [Y/n]: ";
read -r use_cern_sso
use_cern_sso=${use_cern_sso:-"Y"}

shopt -s nocasematch # Ignore cAsE
if [[ "$use_cern_sso" == "Y" ]]
then
    use_cern_sso="True"
else
    use_cern_sso="False"
fi
shopt -u nocasematch # stop ignoring cAsE


if [[ "$use_cern_sso" == "True" ]]
then

    printf "\toAuth client id: ";
    read -r oauth_client_id

    printf "\toAuth client secret: ";
    read -r oauth_client_secret

    printf "\tLimit egroup [$egroup_default]: ";
    read -r egroup
    egroup=${egroup:-"$egroup_default"}
fi

printf "\tJWT secret key [$jwt_secret_key_default]: ";
read -r jwt_secret_key
jwt_secret_key=${jwt_secret_key:-"$jwt_secret_key_default"}

printf "\tAnonymous login [Y/n]: ";
read -r anonymous_login
anonymous_login=${anonymous_login:-"Y"}

shopt -s nocasematch # Ignore cAsE
if [[ "$anonymous_login" == "Y" ]]
then
    anonymous_login="True"
else
    anonymous_login="False"
fi
shopt -u nocasematch # stop ignoring cAsE



echo -e "\n${TXT_GREEN}Processing...${TXT_NC}";

echo -ne "\tChecking hosts file... ";
if [ -f "$HOSTFILE_PATH" ]; then
    host_file_size=$(du -k "$HOSTFILE_PATH" | cut -f1) # get size of hosts file

    # If the file has content, warn the user
    if (( host_file_size > 0 )); then
        echo -ne "${TXT_ORANGE}EXISTING BUT NOT EMPTY, PRESS ANY KEY TO TRUNCATE... ${TXT_NC}";
        read -n 1 -s -r -p ""
    fi

    echo -n "" > "$HOSTFILE_PATH" # clear hosts file (just making sure it is empty, even when file size is 0)
    echo "cleared ✅ ";
else
    touch $HOSTFILE_PATH
    echo "✅ ";
fi

echo -ne "\tWriting hosts file... ";

FRONTEND_VARS=" \
API_URL=http://$hostname/ \
ALLOW_ANONYMOUS=$anonymous_login \
APPLICATION_NAME=\"$application_name\""
printf "[jiskefet_frontend]\n" >> $HOSTFILE_PATH
printf "$hostname$FRONTEND_VARS\n" >> $HOSTFILE_PATH

printf "\n" >> $HOSTFILE_PATH

BACKEND_VARS=" \
remote_privileged_user=$ssh_root_username \
TYPEORM_HOST=$database_host \
TYPEORM_USERNAME=$database_username \
TYPEORM_PASSWORD=$database_password \
TYPEORM_DATABASE=$database_database \
DATABASE_ROOT_PASSWORD=$database_root_password \
JWT_SECRET_KEY=$jwt_secret_key \
USE_CERN_SSO=$use_cern_sso \
ALLOW_ANONYMOUS=$anonymous_login"

# If oauth_client_id is not empty, append to BACKEND_VARS
if [ -n "$oauth_client_id" ]
then
    BACKEND_VARS="$BACKEND_VARS OAUTH_CLIENT_ID=$oauth_client_id"
fi

# If oauth_client_secret is not empty, append to BACKEND_VARS
if [ -n "$oauth_client_secret" ]
then
    BACKEND_VARS="$BACKEND_VARS OAUTH_CLIENT_SECRET=$oauth_client_secret"
fi

# If egroup is not empty, append to BACKEND_VARS
if [ -n "$egroup" ]
then
    BACKEND_VARS="$BACKEND_VARS EGROUP=$egroup"
fi

printf "[jiskefet_backend]\n" >> $HOSTFILE_PATH
printf "$hostname$BACKEND_VARS\n" >> $HOSTFILE_PATH


echo "done ✅ ";


echo -ne "\t${TXT_ORANGE}Press any key to run Ansible recipe... ${TXT_NC}";
read -n 1 -s -r -p ""
echo "OK ✅ ";

echo -ne "\tRunning Ansible playbook... ";

ansible-playbook $ANSIBLEPATH/site.yml -i $HOSTFILE_PATH --user $ssh_root_username
ansible_return_code=$?

if [[ $ansible_return_code == 0 ]]
then
    echo "done ✅ ";
    echo -e "The ansible recipe has finished."

    # Reboot target
    echo "Target may need a reboot for changes to take effect."
fi


exit $ansible_return_code