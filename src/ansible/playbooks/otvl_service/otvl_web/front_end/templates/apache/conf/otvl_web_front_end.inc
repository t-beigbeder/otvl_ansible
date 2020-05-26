<VirtualHost _default_:443>
  ServerName {{ current_site_item.vars.server_name }}
  ServerAdmin webmaster@localhost
  ErrorLog ${APACHE_LOG_DIR}/{{ current_site_item.name }}_rp_error.log
  CustomLog ${APACHE_LOG_DIR}/{{ current_site_item.name }}_rp_access.log combined
  SSLEngine on
  SSLCertificateFile    /etc/ssl/certs/{{ current_site_item.vars.server_name }}.crt
  SSLCertificateKeyFile /etc/ssl/private/{{ current_site_item.vars.server_name }}.key
  ProxyRequests off
  ProxyPreserveHost on
  ProxyPass /api/ http://{{ current_site_item.vars.backend_server }}{{ combined_infra.networks.appli.host_suffix }}:{{ current_site_item.vars.api_port }}/api/ nocanon
  ProxyPassReverse /api/ http://{{ current_site_item.vars.backend_server }}{{ combined_infra.networks.appli.host_suffix }}:{{ current_site_item.vars.api_port }}/api/
  ProxyPass / http://{{ current_site_item.vars.backend_server }}{{ combined_infra.networks.appli.host_suffix }}:{{ current_site_item.vars.web_port }}/
  ProxyPassReverse / http://{{ current_site_item.vars.backend_server }}{{ combined_infra.networks.appli.host_suffix }}:{{ current_site_item.vars.web_port }}/
</VirtualHost>