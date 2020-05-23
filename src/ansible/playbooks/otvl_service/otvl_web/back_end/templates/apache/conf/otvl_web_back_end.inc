<VirtualHost {{ inventory_hostname }}{{ combined_infra.networks.appli.host_suffix }}:{{ current_site_item.vars.web_port }}>
        ServerName {{ current_site_item.vars.server_name }}
        ServerAdmin webmaster@localhost
        ErrorLog ${APACHE_LOG_DIR}/{{ current_site_item.name }}_static_error.log
        CustomLog ${APACHE_LOG_DIR}/{{ current_site_item.name }}_static_access.log combined
        DocumentRoot "{{ combined_otvl.apache.www }}/{{ current_site_item.name }}/web"
        <Directory {{ combined_otvl.apache.www }}/{{ current_site_item.name }}/web>
                Require all granted
                FallbackResource /index.html
        </Directory>
        <Directory {{ combined_otvl.apache.www }}/{{ current_site_item.name }}/web/assets>
                FallbackResource disabled
        </Directory>
        <Directory {{ combined_otvl.apache.www }}/{{ current_site_item.name }}/web/css>
                FallbackResource disabled
        </Directory>
        <Directory {{ combined_otvl.apache.www }}/{{ current_site_item.name }}/web/fonts>
                FallbackResource disabled
        </Directory>
        <Directory {{ combined_otvl.apache.www }}/{{ current_site_item.name }}/web/js>
                FallbackResource disabled
        </Directory>
        <Directory {{ combined_otvl.apache.www }}/{{ current_site_item.name }}/web/statics>
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
