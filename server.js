var express = require('express');
var app = express();
var expressWs = require('express-ws')(app);

var count = 0;
var clients = [];
var id = -1;

app.ws('/messages', function(ws,req) {
  id = count++;
  clients.push(ws);
  console.log('connected');

  ws.on('message', function(msg) {
    for(var i in clients) {
      clients[i].send(msg);
    }
  });

  ws.on('close', function(r) {
    delete clients[id];
    console.log('A client disconnected');
  });
});

app.listen(1234, function() {
  console.log('Listening on port 1234');
});
