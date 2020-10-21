var net = require('net');
var v = []
puppeteer = require('puppeteer');
JsonSocket = require('json-socket');
var port = process.argv[2];
var server = net.createServer();
server.listen(port);

server.on('connection', function(conn) {
    //console.log("Connnected")
    socket = new JsonSocket(conn);
    socket.on('message', function(msg) {
      (async () => {
        res = await process_message(msg);
        socket.sendEndMessage({result: res});
      })();
    });

    socket.on('end', function() {});

    // Don't forget to catch error, for your own sake.
    socket.on('error', function(err) {
      console.log(`Error: ${err}`);
    });
});

class ServerMain
{
  async launch(args){
    v['page'] = {}
    v['browser'] = await puppeteer.launch(args)
    var pages = await v['browser'].pages()
    pages.forEach(function(p){
      var id = Math.floor(Math.random() * 99999) + ""
      v['page'][id] = p
    })
    return Object.keys(v['page']);
  }

  async newPage(){
    var id = Math.floor(Math.random() * 99999) + ""
    page = await v['browser'].newPage()
    v['page'][id] = page
    return id;
  }
}

v['main'] = new ServerMain()

async function process_message(msg){
  var res = null;
  if(msg.eval){
    res = await eval("(async () => { return " + msg.eval + "})()")
  }
  else if(msg.page_id){
    [obj, method] = msg.method.split('.')
    res = await v[obj][msg.page_id][method](...(msg.args || []))
  }
  else{
    [obj, method] = msg.method.split('.')
    res = await v[obj][method](...(msg.args || []))
  }
  if(msg.store) v[msg.store] = res
  console.log("Message: " + JSON.stringify(msg))
  return msg.return ? res : null
}