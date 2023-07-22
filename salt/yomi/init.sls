{% set filesystems = pillar['filesystems'] %}

{% set force_install = salt['pillar.get']('yomi_force_install', False) %}
{% set ns = namespace(installed=False) %}
{% for device, info in filesystems.items() %}
  {% if info.get('mountpoint') == '/' %}
    {% if salt.cmd.run('findmnt --list --noheadings --output SOURCE /') == device %}
      {% set ns.installed = True %}
    {% endif %}
  {% endif %}
{% endfor %}

{% if not ns.installed or force_install %}
include:
  - .storage
  - .software
  - .users
  - .bootloader
  - .services
  - .post_install
  - .reboot
{% endif %}
