#!/bin/bash

SSH_OPTS=""



if [ "$1" =~ \d{1-3}\.\d{1-3}\.\d{1-3}\.\d{1-3}\]; then
    echo "good parameter"
else
    help
fi

echo "Starting bootstrap on server ip address $1"


echo "STEP1 : Copying pub keys on root user"
ssh-copy-id root@$1
testRet

echo "STEP2 : Preparing Motd"
scp $(dirname $0)/myMotd.sh root@$1:/usr/local/bin/myMotd.sh
ssh root@$1 $SSH_OPTS "chmod +x /usr/local/bin/myMotd.sh"
ssh root@$1 $SSH_OPTS "echo /usr/local/bin/myMotd.sh" >> /etc/profile

echo "STEP3 : Root not needed anymore."
echo "Do you want to secure root access ?"



function help
{
    echo "Bad ip address."
    echo "Exiting"
    exit 1
}


function testRet
{
    if [ $? -ne 0]; then
        echo "ERROR : Last command has an error"
        echo "Exiting"
        exit 1
    fi
}
