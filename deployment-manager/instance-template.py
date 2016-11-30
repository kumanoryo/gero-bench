def GenerateConfig(context):
  startup_script = ''.join(['gs://',
                            context.properties['bucket_name'],
                            '/startup-script/start.sh'])
  resources = [{
      'name': context.env['deployment'],
      'type': 'compute.v1.instanceTemplate',
      'properties': {
          'machineType': context.properties['machineType'],
          'tags': {
              'items': ['gero-bench-client']
              },
          'scheduling': {
              'automaticRestart': true,
              'onHostMaintenance': "MIGRATE"
              },
          'disks': [{
              'source': context.properties['source'],
              'autoDelete': true,
              'boot': true
              }],
          'networkInterfaces': [{
              'network': context.properties['network']
              }],
          'serviceAccounts': [{
              'scopes': [
                  'https://www.googleapis.com/auth/devstorage.read_write',
                  'https://www.googleapis.com/auth/comput',
                  'https://www.googleapis.com/auth/sqlservice.admin'
                  ]
              }],
          'metadata': {
              'items': [{
                  'startup-script-url': startup_script
                  }]
              }
          }
    }]

  return {'resources': resources}