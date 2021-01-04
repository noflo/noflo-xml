const noflo = require('noflo');
const xml2js = require('xml2js');

exports.getComponent = () => {
  const c = new noflo.Component();
  c.description = 'Convert XML into a JavaScript object';
  c.icon = 'code';
  c.inPorts.add('in', {
    datatype: 'string',
  });
  c.inPorts.add('options', {
    datatype: 'object',
    control: true,
    default: {
      normalize: false,
      trim: false,
      explicitRoot: true,
      explicitArray: false,
    },
  });
  c.outPorts.add('out', {
    datatype: 'object',
  });
  c.outPorts.add('error', {
    datatype: 'object',
  });

  return c.process((input, output) => {
    let options = {
      normalize: false,
      trim: false,
      explicitRoot: true,
      explicitArray: false,
    };
    if (input.attached('options').length) {
      if (!input.hasData('options')) {
        return;
      }
      options = input.getData('options');
    }
    if (!input.hasData('in')) {
      output.done();
      return;
    }
    const data = input.getData('in');
    xml2js.parseString(data, options, (err, parsed) => {
      if (err) {
        output.done(err);
        return;
      }
      output.sendDone({ out: parsed });
    });
  });
};
