def GenerateConfig(context):

  resources = [{
      'name': context.env['deployment'],
      'type': 'compute.v1.network',
      'properties': {
          'autoCreateSubnetworks': True
      }
  }]
  return {'resources': resources}
