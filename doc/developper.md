# otvl ansible developper documentation
## Development environment
### system setup (debian)
  apt install virtualenv python3-dev python-crypto gcc
### setup
    git clone URL_FOR_otvl_ansible.git
    cd otvl_ansible
    cp ansible_sample.cfg ansible.cfg
    vi ansible.cfg
        #
        [defaults]
        deprecation_warnings = False
        roles_path = :/path/to/otvl_ansible/src/ansible/playbooks:
        allow_world_readable_tmpfiles = True

        [inventory]
        enable_plugins = ini, yaml, openstack

    # in a virtualenv
    pip install -r src/python/requirements-dev.txt
### cloud
    vi ~/.config/openstack/clouds.yaml
        #
        clouds:
          ovh:
            region_name: GRA5
            auth:
              username: OVH_USER
              password: OVH_PASSWORD
              project_name: OVH_PROJECT
              auth_url: 'https://auth.cloud.ovh.net/'
          cloudwatt: etc

    eval `ssh-agent`
    ssh-add ~/.ssh/id_rsa
    ssh localhost id
    # in a virtualenv, eg ~/tools/venv/otvl_ansible
    cd otvl_ansible
    ansible all -i dev/oan/ansible/inventories -m ping
    ansible-playbook \
    -i dev/oan/ansible/inventories \
    -e @dev/oan/ansible/playbooks/extra_vars/ovh.yml \
    dev/oan/ansible/playbooks/os_facts.yml
    ansible-playbook \
        -i src/ansible/inventories/ovh/sample \
        src/ansible/playbooks/iaas.yml

    # see allocated @IP in cloud console, eg 51.68.78.22
    ssh -i ~/.ssh/id_rsa_4k debian@51.68.78.22

You can control ansible execution with tags:

- otvl_iaas_init: will only handle openstack IAAS creation/destruction
- otvl_iaas_configure: will only handle created VMs configuration
- otvl_iaas_network_setup: will only handle IAAS network setup

for instance:

    ansible-playbook -t otvl_iaas_init ...

in the end you will...

    # destroy infrastructure when you're done
    ansible-playbook \
            -i src/ansible/inventories/ovh_sample \
            src/ansible/playbooks/iaas_destroy.yml

### configure cloud VMs
    ssh-add ~/.ssh/YOUR_PRIV_KEY_FILE
    ansible-playbook \
        --vault-password-file /tmp/vpf \
        -i src/ansible/inventories/ovh_sample \
        src/ansible/playbooks/bastion.yml

## References

- [ansible documentation](https://docs.ansible.com/ansible/latest/index.html)
- [cloud-init documentation](https://cloudinit.readthedocs.io/en/latest/)
- [ansible example](https://github.com/ansible/ansible-examples/tree/master/lamp_haproxy)
- [jinja2 documentation](https://palletsprojects.com/p/jinja/)

#
