#!/bin/bash

dnf -y module reset php
dnf -y module enable php:7.4
dnf -y install httpd php php-mysqlnd php-gd php-xml mariadb-server mariadb php-mbstring php-json wget
systemctl start mariadb

if [ $( dnf list installed expect 2>/dev/null | grep -c "expect") -eq 0 ]; then
    echo "Can't find expect. Trying install it..."
	dnf -y install expect
fi

ECURE_MYSQL=$(expect -c "
set timeout 3
spawn mysql_secure_installation
expect \"Enter current password for root (enter for none):\"
send \"\r\"
expect \"root password?\"
send \"y\r\"
expect \"New password:\"
send \"${db_root_pwd}\r\"
expect \"Re-enter new password:\"
send \"${db_root_pwd}\r\"
expect \"Remove anonymous users?\"
send \"Y\r\"
expect \"Disallow root login remotely?\"
send \"Y\r\"
expect \"Remove test database and access to it?\"
send \"Y\r\"
expect \"Reload privilege tables now?\"
send \"Y\r\"
expect eof
")

echo "$SECURE_MYSQL"
dnf -y remove expect


cat <<EOF > steps.sql
CREATE USER '${wiki_db_user}'@'localhost' IDENTIFIED BY '${wiki_db_pwd}';
CREATE DATABASE ${wiki_db}; 
GRANT ALL PRIVILEGES ON ${wiki_db}.* TO '${wiki_db_user}'@'localhost';
FLUSH PRIVILEGES;
SHOW DATABASES;
SHOW GRANTS FOR '${wiki_db_user}'@'localhost';
exit
EOF

mysql -u "root" "-p${db_root_pwd}" < "steps.sql"

systemctl enable mariadb
systemctl enable httpd
useradd wikiuser
cd /home/wikiuser
wget https://releases.wikimedia.org/mediawiki/1.35/mediawiki-1.35.1.tar.gz
gpg --fetch-keys "https://www.mediawiki.org/keys/keys.txt"
wget https://releases.wikimedia.org/mediawiki/1.35/mediawiki-1.35.1.tar.gz.sig
gpg --verify mediawiki-1.35.1.tar.gz.sig mediawiki-1.35.1.tar.gz
cd /var/www
tar -zxf /home/wikiuser/mediawiki-1.35.1.tar.gz
ln -s mediawiki-1.35.1/ mediawiki
curl https://www.python.org/static/apple-touch-icon-144x144-precomposed.png --output /var/www/mediawiki/resources/assets/wiki.png
chown -R apache:apache /var/www/mediawiki
echo "U2VydmVyUm9vdCAiL2V0Yy9odHRwZCINCkxpc3RlbiA4MA0KSW5jbHVkZSBjb25mLm1vZHVsZXMuZC8qLmNvbmYNClVzZXIgYXBhY2hlDQpHcm91cCBhcGFjaGUNClNlcnZlckFkbWluIHJvb3RAbG9jYWxob3N0DQo8RGlyZWN0b3J5IC8+DQogICAgQWxsb3dPdmVycmlkZSBub25lDQogICAgUmVxdWlyZSBhbGwgZGVuaWVkDQo8L0RpcmVjdG9yeT4NCkRvY3VtZW50Um9vdCAiL3Zhci93d3ciDQo8RGlyZWN0b3J5ICIvdmFyL3d3dyI+DQogICAgQWxsb3dPdmVycmlkZSBOb25lDQogICAgIyBBbGxvdyBvcGVuIGFjY2VzczoNCiAgICBSZXF1aXJlIGFsbCBncmFudGVkDQo8L0RpcmVjdG9yeT4NCjxEaXJlY3RvcnkgIi92YXIvd3d3Ij4NCiAgICBPcHRpb25zIEluZGV4ZXMgRm9sbG93U3ltTGlua3MNCglBbGxvd092ZXJyaWRlIE5vbmUNCjwvRGlyZWN0b3J5Pg0KPElmTW9kdWxlIGRpcl9tb2R1bGU+DQogICAgRGlyZWN0b3J5SW5kZXggaW5kZXguaHRtbCBpbmRleC5odG1sLnZhciBpbmRleC5waHANCjwvSWZNb2R1bGU+DQo8RmlsZXMgIi5odCoiPg0KICAgIFJlcXVpcmUgYWxsIGRlbmllZA0KPC9GaWxlcz4NCkVycm9yTG9nICJsb2dzL2Vycm9yX2xvZyINCkxvZ0xldmVsIHdhcm4NCjxJZk1vZHVsZSBsb2dfY29uZmlnX21vZHVsZT4NCiAgICBMb2dGb3JtYXQgIiVoICVsICV1ICV0IFwiJXJcIiAlPnMgJWIgXCIle1JlZmVyZXJ9aVwiIFwiJXtVc2VyLUFnZW50fWlcIiIgY29tYmluZWQNCiAgICBMb2dGb3JtYXQgIiVoICVsICV1ICV0IFwiJXJcIiAlPnMgJWIiIGNvbW1vbg0KDQogICAgPElmTW9kdWxlIGxvZ2lvX21vZHVsZT4NCiAgICAgICMgWW91IG5lZWQgdG8gZW5hYmxlIG1vZF9sb2dpby5jIHRvIHVzZSAlSSBhbmQgJU8NCiAgICAgIExvZ0Zvcm1hdCAiJWggJWwgJXUgJXQgXCIlclwiICU+cyAlYiBcIiV7UmVmZXJlcn1pXCIgXCIle1VzZXItQWdlbnR9aVwiICVJICVPIiBjb21iaW5lZGlvDQogICAgPC9JZk1vZHVsZT4NCiAgICBDdXN0b21Mb2cgImxvZ3MvYWNjZXNzX2xvZyIgY29tYmluZWQNCjwvSWZNb2R1bGU+DQoNCjxJZk1vZHVsZSBhbGlhc19tb2R1bGU+DQoNCiAgICBTY3JpcHRBbGlhcyAvY2dpLWJpbi8gIi92YXIvd3d3L2NnaS1iaW4vIg0KDQo8L0lmTW9kdWxlPg0KPERpcmVjdG9yeSAiL3Zhci93d3cvY2dpLWJpbiI+DQogICAgQWxsb3dPdmVycmlkZSBOb25lDQogICAgT3B0aW9ucyBOb25lDQogICAgUmVxdWlyZSBhbGwgZ3JhbnRlZA0KPC9EaXJlY3Rvcnk+DQo8SWZNb2R1bGUgbWltZV9tb2R1bGU+DQogICAgVHlwZXNDb25maWcgL2V0Yy9taW1lLnR5cGVzDQogICAgQWRkVHlwZSBhcHBsaWNhdGlvbi94LWNvbXByZXNzIC5aDQogICAgQWRkVHlwZSBhcHBsaWNhdGlvbi94LWd6aXAgLmd6IC50Z3oNCiAgICBBZGRUeXBlIHRleHQvaHRtbCAuc2h0bWwNCiAgICBBZGRPdXRwdXRGaWx0ZXIgSU5DTFVERVMgLnNodG1sDQo8L0lmTW9kdWxlPg0KDQpBZGREZWZhdWx0Q2hhcnNldCBVVEYtOA0KDQo8SWZNb2R1bGUgbWltZV9tYWdpY19tb2R1bGU+DQogICAgTUlNRU1hZ2ljRmlsZSBjb25mL21hZ2ljDQo8L0lmTW9kdWxlPg0KRW5hYmxlU2VuZGZpbGUgb24NCkluY2x1ZGVPcHRpb25hbCBjb25mLmQvKi5jb25mDQo=" | base64 -d  > /etc/httpd/conf/httpd.conf
service httpd restart
cd /var/www/mediawiki
public_ip=$(curl http://169.254.169.254/latest/meta-data/public-ipv4)
php maintenance/install.php --dbserver localhost --dbname "${wiki_db}" --dbuser "${wiki_db_user}" --dbpass "${wiki_db_pwd}" --server "http://$public_ip"  --scriptpath "/mediawiki" --installdbuser ${wiki_db_user} --installdbpass ${wiki_db_pwd} --pass ${wiki_pwd} ${wiki_name} ${wiki_user}
service httpd restart



