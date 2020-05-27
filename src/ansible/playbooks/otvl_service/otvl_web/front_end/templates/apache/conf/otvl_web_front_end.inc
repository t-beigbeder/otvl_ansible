<VirtualHost _default_:443>
  ServerName {{ current_site_item.vars.server_name }}
  ServerAdmin webmaster@localhost
  ErrorLog ${APACHE_LOG_DIR}/{{ current_site_item.name }}_rp_error.log
  CustomLog ${APACHE_LOG_DIR}/{{ current_site_item.name }}_rp_access.log combined
  SSLEngine on
{% if 'auto_pki_path' in current_site_item.vars %}
  SSLCertificateFile    /etc/ssl/certs/{{ current_site_item.vars.server_name }}.crt
  SSLCertificateKeyFile /etc/ssl/private/{{ current_site_item.vars.server_name }}.key
{% endif %}
  ProxyRequests off
  ProxyPreserveHost on
  ProxyPass /api/ http://{{ current_site_item.vars.backend_server }}{{ combined_infra.networks.appli.host_suffix }}:{{ current_site_item.vars.api_port }}/api/ nocanon
  ProxyPassReverse /api/ http://{{ current_site_item.vars.backend_server }}{{ combined_infra.networks.appli.host_suffix }}:{{ current_site_item.vars.api_port }}/api/
  ProxyPass /sitemap.xml http://{{ current_site_item.vars.backend_server }}{{ combined_infra.networks.appli.host_suffix }}:{{ current_site_item.vars.api_port }}/api/sitemap.xml
  ProxyPassReverse /sitemap.xml http://{{ current_site_item.vars.backend_server }}{{ combined_infra.networks.appli.host_suffix }}:{{ current_site_item.vars.api_port }}/api/sitemap.xml
  ProxyPass / http://{{ current_site_item.vars.backend_server }}{{ combined_infra.networks.appli.host_suffix }}:{{ current_site_item.vars.web_port }}/
  ProxyPassReverse / http://{{ current_site_item.vars.backend_server }}{{ combined_infra.networks.appli.host_suffix }}:{{ current_site_item.vars.web_port }}/
{% if 'cert_bot' in current_site_item.vars and current_site_item.vars.cert_bot %}
  SSLCertificateFile /etc/letsencrypt/live/{{ current_site_item.vars.server_name }}/fullchain.pem
  SSLCertificateKeyFile /etc/letsencrypt/live/{{ current_site_item.vars.server_name }}/privkey.pem
Include /etc/letsencrypt/options-ssl-apache.conf
{% endif %}
</VirtualHost>
