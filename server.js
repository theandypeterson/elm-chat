var express = require('express');
var app = express();
var expressWs = require('express-ws')(app);

var count = 0;
var clients = [];

app.ws('/messages', function(ws,req) {
  console.log('hit echo');
  var id = count++;
  clients.push(ws);
  ws.send('Welcome!');

  ws.on('message', function(msg) {
    console.log('received message: %s', msg);
    for(var i in clients) {
      clients[i].send(msg);
    }
  });

  ws.on('close', function(r) {
    console.log((new Date()) + "=> " + ws  + " has disconnected.");
    delete clients[id];
  });
});

app.listen(1234, function() {
  console.log('Listening on port 1234');
});
