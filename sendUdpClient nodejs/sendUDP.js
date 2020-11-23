const dgram = require('dgram');
const message = Buffer.from('up');
const client = dgram.createSocket('udp4');
client.send(message, 8888, '192.168.1.17', (err) => {
  client.close();
});