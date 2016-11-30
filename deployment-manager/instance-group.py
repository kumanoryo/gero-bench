def GenerateConfig(context):
  startup_script = ''.join(['gs://',
                            context.properties['bucket_name'],
                            '/startup-script/start.sh'])
  network_name = ''.join(['https://www.googleapis.com/compute/v1/projects/',
                          context.env['project'],
                          '/global/networks/',
                          context.properties['network']])
  image = ''.join(['https://www.googleapis.com/compute/v1/',
                    'projects/',
                    context.env['project'],
                    '/global/images/',
                    context.properties['source']])
  resources = [{
      'name': context.properties['instanceTemplate'],
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
                  'initializeParams': {'sourceImage': image},
                  'autoDelete': True,
                  'boot': True
                  }],
              'networkInterfaces': [{
                   'accessConfigs': [{
                      'name': 'external-nat',
                      'type': 'ONE_TO_ONE_NAT'
                      }],
                   'network': network_name
                  }],
              'serviceAccounts': [{
                  'scopes': [
                      'https://www.googleapis.com/auth/devstorage.read_write',
                      'https://www.googleapis.com/auth/compute',
                      'https://www.googleapis.com/auth/sqlservice.admin'
                      ]
                  }],
              'metadata': {
                  'items': [{
                      'key': 'startup-script-url',
                      'value': startup_script
                      }]
                  }
              }
          }
    }, {
        'name': context.properties['instanceGroupManager'],
        'type': 'compute.v1.instanceGroupManager',
        'properties': {
            'zone': context.properties['zone'],
            'targetSize': 0,
            'baseInstanceName': context.properties['baseInstanceName'],
            'instanceTemplate': '$(ref.' + context.properties['instanceTemplate'] + '.selfLink)'
            }
   }]

  return {'resources': resources}
