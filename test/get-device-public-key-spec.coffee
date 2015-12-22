mongojs = require 'mongojs'
Datastore = require 'meshblu-core-datastore'
GetDevicePublicKey = require '../'

describe 'GetDevicePublicKey', ->
  beforeEach (done) ->
    @datastore = new Datastore
      database: mongojs('meshblu-core-task-update-device')
      collection: 'devices'

    @datastore.remove done

  beforeEach ->
    @uuidAliasResolver = resolve: (uuid, callback) => callback(null, uuid)
    @sut = new GetDevicePublicKey {@datastore, @uuidAliasResolver}

  describe '->do', ->
    describe 'when the device does not exist in the datastore', ->
      beforeEach (done) ->
        request =
          metadata:
            responseId: 'used-as-biofuel'
            auth:
              uuid: 'thank-you-for-considering'
              token: 'the-environment'
            toUuid: 'thank-you-for-considering'

        @sut.do request, (error, @response) => done error

      it 'should respond with a 404', ->
        expect(@response.metadata.code).to.equal 404

    describe 'when the device does exists in the datastore', ->
      beforeEach (done) ->
        record =
          uuid: 'thank-you-for-considering'
          token: 'never-gonna-guess-me'
          publicKey: 'this-is-my-public-key'
          meshblu:
            tokens:
              'GpJaXFa3XlPf657YgIpc20STnKf2j+DcTA1iRP5JJcg=': {}
        @datastore.insert record, done

      describe 'when called', ->
        beforeEach (done) ->
          request =
            metadata:
              responseId: 'used-as-biofuel'
              auth:
                uuid: 'thank-you-for-considering'
                token: 'the-environment'
              toUuid: 'thank-you-for-considering'

          @sut.do request, (error, @response) => done error

        it 'should respond with a 200', ->
          expect(@response.metadata.code).to.equal 200

        it 'should return the data', ->
          expect(@response.data).to.contain publicKey: 'this-is-my-public-key'
