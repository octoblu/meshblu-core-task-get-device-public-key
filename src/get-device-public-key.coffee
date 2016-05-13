http = require 'http'

class GetDevicePublicKey
  constructor: ({@datastore,@uuidAliasResolver}) ->

  do: (job, callback) =>
    {toUuid} = job.metadata

    @uuidAliasResolver.resolve toUuid, (error, uuid) =>
      return callback error if error?

      projection =
        uuid: true
        publicKey: true

      @datastore.findOne {uuid}, projection, (error, result) =>
        return callback error if error?
        return callback null, metadata: code: 404 unless result?

        response =
          metadata:
            code: 200
          data:
            uuid: result.uuid
            publicKey: result.publicKey

        return callback null, response

module.exports = GetDevicePublicKey
