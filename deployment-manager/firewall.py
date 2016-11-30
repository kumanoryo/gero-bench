def GenerateConfig(context):
  resources = [{
      'name': context.env['deployment'] + '-allow-ssh',
      'type': 'compute.v1.firewall',
      'properties':  {
        'allowed': [{
          'IPProtocol': 'TCP',
          'ports': ['22']
        }],
        'sourceRanges': ['0.0.0.0/0'],
        'network': 'projects/' + context.env['project'] + '/global/networks/' + context.properties['network']
      }
  }]
  return {'resources': resources}
