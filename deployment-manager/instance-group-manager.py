def GenerateConfig(context):
    resources = [{
        'name': context.env['deployment'],
        'type': 'compute.v1.instanceGroupManager',
        'properties': {
            'zone': context.properties['zone'],
            'targetSize': 0,
            'baseInstanceName': context.properties['baseInstanceName'],
            'instanceTemplate': '$(ref.' + context.properties['instanceTemplate'] + '.selfLink)'
            }
      }]

    return {'resources': resources}
