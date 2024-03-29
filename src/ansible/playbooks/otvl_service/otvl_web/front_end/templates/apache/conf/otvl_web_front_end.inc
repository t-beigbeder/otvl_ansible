<VirtualHost *:80>
  ServerName {{ current_site_item.vars.server_name }}
  Redirect / https://{{ current_site_item.vars.server_name }}/
</VirtualHost>

<VirtualHost _default_:443>
  ServerName {{ current_site_item.vars.server_name }}
  ServerAdmin webmaster@localhost
  ErrorLog ${APACHE_LOG_DIR}/{{ current_site_item.name }}_rp_error.log
  CustomLog ${APACHE_LOG_DIR}/{{ current_site_item.name }}_rp_access.log combined
  SSLEngine on

  RewriteEngine on

  RewriteCond "%{REQUEST_URI}"  "^/assets/" [OR]
  RewriteCond "%{REQUEST_URI}"  "^/css/" [OR]
  RewriteCond "%{REQUEST_URI}"  "^/fonts/" [OR]
  RewriteCond "%{REQUEST_URI}"  "^/js/" [OR]
  RewriteCond "%{REQUEST_URI}"  "^/statics/" [OR]
  RewriteCond "%{REQUEST_URI}"  "^/api/" [OR]
  RewriteCond "%{REQUEST_URI}"  "^/favicon.ico$" [OR]
  RewriteCond "%{REQUEST_URI}"  "^/robots.txt$" [OR]
  RewriteCond "%{REQUEST_URI}"  "^/sitemap.xml$"
  RewriteRule ^ - [L]

  RewriteCond "%{HTTP_USER_AGENT}"  "otvl_begin"  [OR]
  RewriteCond "%{HTTP_USER_AGENT}"  "Googlebot"  [OR]
  RewriteCond "%{HTTP_USER_AGENT}"  "Bingbot"  [OR]
  RewriteCond "%{HTTP_USER_AGENT}"  "bingbot"  [OR]
  RewriteCond "%{HTTP_USER_AGENT}"  "BingPreview"  [OR]
  RewriteCond "%{HTTP_USER_AGENT}"  "YandexWebmaster"  [OR]
  RewriteCond "%{HTTP_USER_AGENT}"  "YandexBot"  [OR]
  RewriteCond "%{HTTP_USER_AGENT}"  "LinkedInBot"  [OR]
  RewriteCond "%{HTTP_USER_AGENT}"  "PocketParser"  [OR]
  RewriteCond "%{HTTP_USER_AGENT}"  "Slurp"  [OR]
  RewriteCond "%{HTTP_USER_AGENT}"  "Baiduspider"  [OR]
  RewriteCond "%{HTTP_USER_AGENT}"  "YandexBot"  [OR]
  RewriteCond "%{HTTP_USER_AGENT}"  "Sogou"  [OR]
  RewriteCond "%{HTTP_USER_AGENT}"  "Exabot"  [OR]
  RewriteCond "%{HTTP_USER_AGENT}"  "facebot"  [OR]
  RewriteCond "%{HTTP_USER_AGENT}"  "facebookexternalhit"  [OR]
  RewriteCond "%{HTTP_USER_AGENT}"  "ia_archiver"  [OR]
  RewriteCond "%{HTTP_USER_AGENT}"  "DuckDuckBot"  [OR]
  RewriteCond "%{HTTP_USER_AGENT}"  "WhatsApp"  [OR]
  RewriteCond "%{HTTP_USER_AGENT}"  "Twitterbot"  [OR]
  RewriteCond "%{HTTP_USER_AGENT}"  "Applebot"  [OR]
  RewriteCond "%{HTTP_USER_AGENT}"  "AhrefsBot"  [OR]
  RewriteCond "%{HTTP_USER_AGENT}"  "PaperLiBot"  [OR]
  RewriteCond "%{HTTP_USER_AGENT}"  "otvl_end"
  RewriteRule "^/(.*)$"  "/api/html4/$1" [L,PT]

  ProxyRequests off
  ProxyPreserveHost on
  ProxyPass /api/ http://{{ current_site_item.vars.backend_server }}{{ combined_infra.networks.appli.host_suffix }}:{{ current_site_item.vars.api_port }}/api/ nocanon
  ProxyPassReverse /api/ http://{{ current_site_item.vars.backend_server }}{{ combined_infra.networks.appli.host_suffix }}:{{ current_site_item.vars.api_port }}/api/
  ProxyPass /sitemap.xml http://{{ current_site_item.vars.backend_server }}{{ combined_infra.networks.appli.host_suffix }}:{{ current_site_item.vars.api_port }}/api/sitemap.xml
  ProxyPassReverse /sitemap.xml http://{{ current_site_item.vars.backend_server }}{{ combined_infra.networks.appli.host_suffix }}:{{ current_site_item.vars.api_port }}/api/sitemap.xml
  ProxyPass / http://{{ current_site_item.vars.backend_server }}{{ combined_infra.networks.appli.host_suffix }}:{{ current_site_item.vars.web_port }}/
  ProxyPassReverse / http://{{ current_site_item.vars.backend_server }}{{ combined_infra.networks.appli.host_suffix }}:{{ current_site_item.vars.web_port }}/

{% if ((('auto_pki_path' in current_site_item.vars) or ('auto_pki_ansible' in current_site_item.vars and current_site_item.vars.auto_pki_ansible)) and (not letsencrypt_archive_dir.stat.exists)) %}
  SSLCertificateFile    /etc/ssl/certs/{{ current_site_item.vars.server_name }}.crt
  SSLCertificateKeyFile /etc/ssl/private/{{ current_site_item.vars.server_name }}.key
{% endif %}
{% if (('certbot' in current_site_item.vars and current_site_item.vars.certbot) and letsencrypt_archive_dir.stat.exists) %}
  SSLCertificateFile /etc/letsencrypt/live/{{ current_site_item.vars.server_name }}/fullchain.pem
  SSLCertificateKeyFile /etc/letsencrypt/live/{{ current_site_item.vars.server_name }}/privkey.pem
  Include /etc/letsencrypt/options-ssl-apache.conf
{% endif %}

{% if ('private_area_conf' in current_site_item.vars) %}
  Include /etc/apache2/otvl_conf/{{ current_site_item.name }}-private_area_conf.inc
{% endif %}

</VirtualHost>
