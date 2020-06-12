wget https://github.com/narayanshivansh49/edulyxLive/releases/download/v1.1/bigbluebutton-html5.tar.gz
wget https://github.com/narayanshivansh49/edulyxLive/releases/download/v1.1/default.pdf
wget https://github.com/narayanshivansh49/edulyxLive/releases/download/v1.1/fav.png
tar -xvf bigbluebutton-html5.tar.gz
rm bigbluebutton-html5.tar.gz
cp /usr/share/meteor/bundle/programs/server/assets/app/config/settings.yml settings.yml
cp /usr/share/meteor/bundle/mongo* .
cp /usr/share/meteor/bundle/systemd_start.sh .
rm -rf /usr/share/meteor/bundle
mv bundle /usr/share/meteor/
rm /usr/share/meteor/bundle/programs/server/assets/app/config/settings.yml
mv settings.yml /usr/share/meteor/bundle/programs/server/assets/app/config/settings.yml
mv mongo* /usr/share/meteor/bundle
mv systemd_start.sh /usr/share/meteor/bundle
npm --prefix /usr/share/meteor/bundle/programs/server install /usr/share/meteor/bundle/programs/server

TARGET=/usr/share/meteor/bundle/programs/server/assets/app/config/settings.yml

echo "Setting html5 client settings..."
yq w -i $TARGET public.app.clientTitle "Edulyx Live"
yq w -i $TARGET public.app.appName "Edulyx Live"
yq w -i $TARGET public.app.copyright "©2020 edulyx"
yq w -i $TARGET public.app.helpLink "https://live.edulyx.com/"
yq w -i $TARGET public.app.branding.displayBrandingArea true
yq w -i $TARGET public.app.preloadNextSlides 2
yq w -i $TARGET public.presentation.uploadSizeMax 200000000

#echo "Setting default messages..."
#sed -i "s@^defaultWelcomeMessage=.*@defaultWelcomeMessage=Benvenuto in <b>%%CONFNAME%%</b>!<br><br>Per unirti alla chiamata clicca sull'icona del telefono.@g" /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties
#sed -i "s@^defaultWelcomeMessageFooter=.*@defaultWelcomeMessageFooter=Questo servizio \&egrave; offerto da <a href=\"https://livemeeting.tech/\" target=\"_blank\"><u>LiveMeeting</u></a>.@g" /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties

chown meteor:meteor $TARGET

echo "Copying files..."
cp default.pdf /var/www/bigbluebutton-default/default.pdf
cp fav.png /var/www/bigbluebutton-default/fav.png

chmod +r /var/www/bigbluebutton-default/default.pdf
chmod +r /var/www/bigbluebutton-default/fav.png