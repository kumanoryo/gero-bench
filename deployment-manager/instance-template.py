def GenerateConfig(context):
  startup_script = ''.join(['gs://',
                            context.properties['bucket_name'],
                            '/startup-script/start.sh'])
  network_name = ''.join(['https://www.googleapis.com/compute/v1/projects/',
                          context.env['project'],
                          '/global/networks/',
                          context.properties['network']])
  resources = [{
      'name': context.env['deployment'],
      'type': 'compute.v1.instanceTemplate',
      'properties': {
          'properties': {
              'machineType': context.properties['machineType'],
              'tags': {
                  'items': ['gero-bench-client']
                  },
              'scheduling': {
                  'automaticRestart': True,
                  'onHostMaintenance': "MIGRATE"
                  },
              'disks': [{
                  'source': context.properties['source'],
                  'autoDelete': True,
                  'boot': True
                  }],
              'networkInterfaces': [{
                  'network': network_name
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
          }
    }]

  return {'resources': resources}
