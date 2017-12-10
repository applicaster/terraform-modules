#cloud-config
write_files:
  - path: /etc/chef/first-boot.json
    content: |
         {"cloud_formation":"${cf_name}","mysql_server":{"reset_users":${applicaster2_reset_users},"reset_ingestion":${applicaster2_reset_ingestion}},"run_list":["recipe[cloud-formation]"]}
runcmd:
  - [ sudo, chef-solo, -j, /etc/chef/first-boot.json ]
