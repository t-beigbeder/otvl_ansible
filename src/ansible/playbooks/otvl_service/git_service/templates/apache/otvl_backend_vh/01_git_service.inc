
    SetEnv combined_otvl.git_service.project_root {{ combined_otvl.apache.www }}/{{ combined_otvl.git_service.project_root }}
    SetEnv GIT_HTTP_EXPORT_ALL

    Alias /{{ combined_otvl.git_service.apache_location }}/ /usr/lib/git-core/git-http-backend/
    <Location "/{{ combined_otvl.git_service.apache_location }}/">
        SetHandler cgi-script
        Options ExecCGI
        Require all granted
    </Location>
    <LocationMatch "^/{{ combined_otvl.git_service.apache_location }}/.*/git-receive-pack$">
        AuthBasicProvider otvl_backend_vh
        AuthType Basic
        AuthName "Git Access"
        Require valid-user
    </LocationMatch>
{% if combined_otvl.git_service.apache_location_rw != combined_otvl.git_service.apache_location %}
    Alias /{{ combined_otvl.git_service.apache_location_rw }}/ /usr/lib/git-core/git-http-backend/
    <Location "/{{ combined_otvl.git_service.apache_location_rw }}/">
        SetHandler cgi-script
        Options ExecCGI
        AuthBasicProvider otvl_backend_vh
        AuthType Basic
        AuthName "Git Access"
        Require valid-user
    </Location>
{% endif %}
    Alias /{{ combined_otvl.git_service.apache_artifacts_location }}/ "{{ combined_otvl.apache.www }}/artifacts/"
    <Location "/{{ combined_otvl.git_service.apache_artifacts_location }}/">
        Require all granted
    </Location>
