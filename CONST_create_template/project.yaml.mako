---
project_folder: demo_geomapfish
project_package: demo
application_url: ${docker_web_protocol}://${docker_host}${docker_entry_point}
checker_url: ${docker_web_protocol}://${docker_host}${docker_entry_point}c2c/health_check?max_level=9
managed_files: []
template_vars:
  package: demo
  srid: 21781
  extent: 489246,78873,837119,296543
