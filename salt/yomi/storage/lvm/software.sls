{% import 'macros.yml' as macros %}

{% set software = pillar['software'] %}
{% set software_config = software.get('config', {}) %}

{{ macros.log('pkg', 'install_lvm2') }}
install_lvm2:
  pkg.installed:
    - name: lvm2
  {% if software_config.get('minimal') %}
    - no_recommends: yes
  {% endif %}
  {% if not software_config.get('verify') %}
    - skip_verify: yes
  {% endif %}
    - root: /mnt
    - require:
      - mount: mount_/mnt
