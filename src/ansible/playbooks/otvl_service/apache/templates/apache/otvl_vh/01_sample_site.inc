{% for alias in current_virtual_host.value.aliases %}
Alias /{{ alias.name }}/ {{ alias.directory }}/
<Directory {{ alias.directory }}>
    Require all granted
</Directory>

{% endfor %}