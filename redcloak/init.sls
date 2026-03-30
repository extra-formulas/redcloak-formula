{%- set default_sources = {'module' : 'redcloak', 'pillar' : True, 'grains' : ['os_family']} %}
{%- from "./defaults/load_config.jinja" import config as redcloak with context %}

{% if redcloak.use is defined %}

{% if redcloak.use | to_bool %}

redcloak_installation:
  pkg.installed:
    - name: {{ redcloak.package_name }}
{%- if redcloak.package_file is defined %}
    - sources:
      - {{ redcloak.package_name }}: {{ redcloak.package_file }}
{%- endif %}

redcloak_service_running:  
  service.running:
    - name: {{ redcloak.service_name }}
    - enable: True
    - require:
      - redcloak_installation
    - watch:
      - redcloak_installation

{% else %}

redcloak_service_stopped:  
  service.dead:
    - name: {{ redcloak.service_name }}
    - enable: False

redcloak_removal:
  pkg.removed:
    - name: {{ redcloak.package_name }}
    - require:
      - redcloak_service_stopped

{% endif %}

{% endif %}