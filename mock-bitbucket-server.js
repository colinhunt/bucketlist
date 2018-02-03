var http = require('http');
var url = require('url');
var fs = require('fs');

http.createServer(function (req, res) {
    var theUrl = url.parse(req.url, true);
    var path = theUrl.path;
    var query = theUrl.query;

  function notFound() {
      res.writeHead(404, {'Content-Type': 'text/html'});
      return res.end("404 Not Found");    
  }

  if (path == "/dashboard/pull-requests") {
    filename = "test-pull-requests.json";
  } else {
    return notFound();
  }

  fs.readFile(filename, function(err, data) {
    if (err) {
      return notFound();
    }  
    res.writeHead(200, {'Content-Type': 'application/json'});
    res.write(data);
    return res.end();
  });
}).listen(8080);
