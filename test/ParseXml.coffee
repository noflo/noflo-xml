readenv = require "../components/ParseXml"
socket = require('noflo').internalSocket

setupComponent = ->
  c = readenv.getComponent()
  ins = socket.createSocket()
  out = socket.createSocket()
  c.inPorts.in.attach ins
  c.outPorts.out.attach out
  [c, ins, out]

exports['test reading simple XML string'] = (test) ->
  test.expect 3
  [c, ins, out] = setupComponent()

  xml = """
    <foo>
      <bar>Baz</bar>
    </foo>
  """

  out.once 'data', (data) ->
    test.equal typeof data.foo, 'object'
    test.equal typeof data.foo.bar, 'object'
    test.equal data.foo.bar, 'Baz'
    test.done()
  ins.send xml
  do ins.disconnect
