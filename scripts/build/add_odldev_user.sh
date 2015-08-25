#!/bin/bash
# Add the odldev user and add to sudoers.

addgroup odldev

# http://askubuntu.com/questions/94060/run-adduser-non-interactively
adduser --gecos "" --disabled-login --shell /bin/bash --ingroup odldev odldev

# http://serverfault.com/questions/336298/can-i-change-a-user-password-in-linux-from-the-command-line-with-no-interactivit
echo "odldev:ODLDEV" | sudo chpasswd

# http://askubuntu.com/questions/7477/how-can-i-add-a-new-user-as-sudoer-using-the-command-line
usermod -a -G sudo odldev

# Age out passwd to force a change on first login
# chage -d 0 odldev
