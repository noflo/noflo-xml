noflo = require "noflo"
xml2js = require "xml2js"

exports.getComponent = ->
  c = new noflo.Component
  c.description = 'Convert XML into a JavaScript object'
  c.inPorts.add 'in',
    datatype: 'string'
  c.inPorts.add 'options',
    datatype: 'object'
    control: true
    default:
      normalize: false
      trim: false
      explicitRoot: true
      explicitArray: false
  c.outPorts.add 'out',
    datatype: 'object'
  c.outPorts.add 'error',
    datatype: 'object'

  c.process (input, output) ->
    return unless input.has 'options', 'in'
    [options, data] = input.get 'options', 'in'
    return unless data.type is 'data'

    xml2js.parseString data.data, options.data, (err, parsed) ->
      return output.sendDone err if err
      output.sendDone
        out: parsed
