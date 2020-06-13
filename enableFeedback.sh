HOST=$(cat /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties | grep -v '#' | sed -n '/^bigbluebutton.web.serverURL/{s/.*\///;p}')
HTML5_CONFIG=/usr/share/meteor/bundle/programs/server/assets/app/config/settings.yml

apt-get install -y nginx-full

yq w -i $HTML5_CONFIG public.clientLog.external.enabled true
yq w -i $HTML5_CONFIG public.clientLog.external.url     "$PROTOCOL://$HOST/html5log"
yq w -i $HTML5_CONFIG public.app.askForFeedbackOnLogout true
chown meteor:meteor $HTML5_CONFIG

cat > /etc/bigbluebutton/nginx/html5-client-log.nginx << HERE
location /html5log {
        access_log /var/log/nginx/html5-client.log postdata;
        echo_read_request_body;
}

cat > /etc/nginx/conf.d/html5-client-log.conf << HERE
log_format postdata '\$remote_addr [\$time_iso8601] \$request_body';
HERE

# We need nginx-full to enable postdata log_format
if ! dpkg -l | grep -q nginx-full; then
  apt-get install -y nginx-full
fi

touch /var/log/nginx/html5-client.log
chown bigbluebutton:bigbluebutton /var/log/nginx/html5-client.log