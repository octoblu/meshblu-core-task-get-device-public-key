http          = require 'http'
DeviceManager = require 'meshblu-core-manager-device'

class GetDevicePublicKey
  constructor: ({datastore,uuidAliasResolver}) ->
    @deviceManager = new DeviceManager {datastore, uuidAliasResolver}

  do: (job, callback) =>
    { toUuid } = job.metadata

    projection =
      uuid: true
      publicKey: true

    @deviceManager.findOne { uuid: toUuid, projection }, (error, device) =>
      return callback error if error?
      return callback null, metadata: code: 404 unless device?

      response =
        metadata:
          code: 200
        data:
          uuid: device.uuid
          publicKey: device.publicKey

      return callback null, response

module.exports = GetDevicePublicKey
