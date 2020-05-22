<VirtualHost localhost:9982>
        ServerName site2.dxpydk
        ServerAdmin webmaster@localhost
        ErrorLog ${APACHE_LOG_DIR}/site2_static_error.log
        CustomLog ${APACHE_LOG_DIR}/site2_static_access.log combined
        DocumentRoot "/srv/www/site2/web"
        <Directory /srv/www/site2/web>
                Require all granted
                FallbackResource /index.html
        </Directory>
        <Directory /srv/www/site2/web/assets>
                FallbackResource disabled
        </Directory>
        <Directory /srv/www/site2/web/css>
                FallbackResource disabled
        </Directory>
        <Directory /srv/www/site2/web/fonts>
                FallbackResource disabled
        </Directory>
        <Directory /srv/www/site2/web/js>
                FallbackResource disabled
        </Directory>
        <Directory /srv/www/site2/web/statics>
                FallbackResource disabled
        </Directory>
        ErrorDocument 400 /statics/error/technical_error.html
        ErrorDocument 401 /statics/error/technical_error.html
        ErrorDocument 403 /statics/error/technical_error.html
        ErrorDocument 404 /statics/error/page_not_found.html
        ErrorDocument 405 /statics/error/technical_error.html
        ErrorDocument 408 /statics/error/technical_error.html
        ErrorDocument 410 /statics/error/technical_error.html
        ErrorDocument 411 /statics/error/technical_error.html
        ErrorDocument 412 /statics/error/technical_error.html
        ErrorDocument 413 /statics/error/technical_error.html
        ErrorDocument 414 /statics/error/technical_error.html
        ErrorDocument 415 /statics/error/technical_error.html
        ErrorDocument 500 /statics/error/technical_error.html
        ErrorDocument 501 /statics/error/technical_error.html
        ErrorDocument 502 /statics/error/technical_error.html
        ErrorDocument 503 /statics/error/technical_error.html
        ErrorDocument 506 /statics/error/technical_error.html
</VirtualHost>
