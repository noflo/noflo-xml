noflo = require "noflo"
xml2js = require "xml2js"

exports.getComponent = ->
  c = new noflo.Component
  c.description = 'Convert XML into a JavaScript object'
  c.icon = 'code'
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
    return unless input.hasData 'options', 'in'
    [options, data] = input.getData 'options', 'in'
    xml2js.parseString data, options, (err, parsed) ->
      return output.sendDone err if err
      output.sendDone
        out: parsed
