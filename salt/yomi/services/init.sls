{% import 'macros.yml' as macros %}

{% set services = pillar.get('services', {}) %}

include:
  - .network
{% if pillar.get('salt-minion') %}
  - .salt-minion
{% endif %}

{% for service in services.get('enabled', []) %}
# We execute the systemctl call inside the chroot, so we can guarantee
# that will work on containers
{{ macros.log('module', 'enable_service_' ~ service) }}
enable_service_{{ service }}:
  module.run:
    - service.enable:
      - root: /mnt
      - name: {{ service }}
    - unless: systemctl --root=/mnt --quiet is-enabled {{ service }} 2> /dev/null
{% endfor %}

{% for service in services.get('disabled', []) %}
{{ macros.log('module', 'disable_service_' ~ service) }}
disable_service_{{ service }}:
  module.run:
    - service.disable:
      - root: /mnt
      - name: {{ service }}
    - onlyif: systemctl --root=/mnt --quiet is-enabled {{ service }} 2> /dev/null
{% endfor %}
