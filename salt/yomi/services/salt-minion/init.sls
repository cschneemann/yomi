{% import 'macros.yml' as macros %}

{% set salt_minion = pillar['salt-minion'] %}

{% if salt['file.directory_exists']('/var/cache/venv-salt-minion') %}
{% set src_cache_path = "/var/cache/venv-salt-minion" %}
{% else %}
{% set src_cache_path = "/var/cache/salt/minion" %}
{% endif %}

{% if salt['file.directory_exists']('/mnt/var/cache/venv-salt-minion') %}
{% set dst_cache_path = "/mnt/var/cache/venv-salt-minion" %}
{% else %}
{% set dst_cache_path = "/mnt/var/cache/salt/minion" %}
{% endif %}

{% if salt['file.directory_exists']('/etc/venv-salt-minion') %}
{% set src_etc_path = "/etc/venv-salt-minion" %}
{% else %}
{% set src_etc_path = "/etc/salt" %}
{% endif %}
{% if salt['file.directory_exists']('/mnt/etc/venv-salt-minion') %}
{% set dst_etc_path = "/mnt/etc/venv-salt-minion" %}
{% else %}
{% set dst_etc_path = "/mnt/etc/salt" %}
{% endif %}



{% if salt_minion.get('config') %}
{{ macros.log('module', 'synchronize_salt-minion_etc') }}
synchronize_salt-minion_etc:
  module.run:
    - file.copy:
      - src: {{ src_etc_path }}
      - dst: {{ dst_etc_path }}
      - recurse: yes
      - remove_existing: yes
    - unless: "[ -e {{ dst_etc_path }}/pki/minion/minion.pem ]"

{{ macros.log('module', 'synchronize_salt-minion_var') }}
synchronize_salt-minion_var:
  module.run:
    - file.copy:
      - src: {{ src_cache_path }}
      - dst: {{ dst_cache_path }}
      - recurse: yes
      - remove_existing: yes
    - unless: "[ -e {{ dst_cache_path }}/extmods ]"

{{ macros.log('file', 'clean_salt-minion_var') }}
clean_salt-minion_var:
  file.tidied:
    - name: {{ dst_cache_path }}
    - matches:
      - ".*\\.pyc"
      - "\\d+"
{% endif %}
