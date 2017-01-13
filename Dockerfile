

FROM  ruby:2.3-alpine

MAINTAINER takayamaki

RUN   apk add --no-cache --virtual deps wget gcc musl-dev make &&\
      apk add --no-cache apache2 logrotate &&\
      sed -i -e 's%/var/log/messages%#/var/log/messages%' /etc/logrotate.conf &&\
      mkdir /run/apache2 &&\
      ls /work || mkdir /work && cd /work &&\
      wget -q -O dodontof.zip https://www.dropbox.com/s/hd26rf4pkbi1oci/DodontoF_Ver.1.48.00_sugar_chocolate_waffle.zip?dl=1 &&\
      unzip -q dodontof.zip && rm dodontof.zip && cd DodontoF_WebSet/public_html &&\
      chmod 705 ../saveData \
                imageUploadSpace \
                imageUploadSpace/smallImages \
                DodontoF \
                DodontoF/DodontoFServer.rb \
                DodontoF/saveDataTempSpace \
                DodontoF/fileUploadSpace \
                DodontoF/replayDataUploadSpace &&\
      chmod 600 DodontoF/log.txt \
                DodontoF/log.txt.0  &&\
      mv ../saveData /var/www/localhost/ &&\
      mv ./* /var/www/localhost/htdocs/ &&\
      cd / &&\
      rm -rf /work &&\
      chown apache:apache -R /var/www/localhost/saveData /var/www/localhost/htdocs/* &&\
      sed -i -e 's%#LoadModule cgi_module modules/mod_cgi.so%LoadModule cgi_module modules/mod_cgi.so%' /etc/apache2/httpd.conf&&\
      echo \<Directory "/var/www/localhost/htdocs/DodontoF"\> >> /etc/apache2/httpd.conf &&\
      echo Options FollowSymLinks ExecCGI >> /etc/apache2/httpd.conf &&\
      echo AddHandler cgi-script .rb .pl >> /etc/apache2/httpd.conf &&\
      echo AddHandler application/x-shockwave-flash .swf >> /etc/apache2/httpd.conf &&\
      echo \</Directory\> >> /etc/apache2/httpd.conf &&\
      echo RedirectMatch permanent ^/$ /DodontoF/  >> /etc/apache2/httpd.conf &&\
      rm -f ~/.ash_history ~/.wget-hsts &&\
      apk del --purge deps
EXPOSE 80
CMD httpd -D FOREGROUND
