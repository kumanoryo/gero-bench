def GenerateConfig(context):
  resources = [{
      'name': context.env['deployment'],
      'type': 'storage.v1.bucket',
      'properties':  {
         'storageClass': context.properties['storageClass'],
         'location': context.properties['location']
      }
  }]
  return {'resources': resources}
