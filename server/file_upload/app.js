var express = require('express'),
    formidable = require('formidable'),
    util = require('util');

// create the server
var app = express.createServer();

// this is the post route for uploading files
app.post("/upload", function(req, res) {

  // track percent of file uploaded
  var percentDone = 0;

  //parse a file upload
  var form = new formidable.IncomingForm();

  // set the upload directory
  form.uploadDir = './files';

  // do not strip off file extensions
  form.keepExtensions = true;

  // set the name of the file that will be saved to disk
  form
    .on('fileBegin', function(name, file) {
      file.path = './files/' + file.name;
      console.log("Uploading '" + file.name + "'");
    })
    .on('progress', function(bytesReceived, bytesExpected) {
      var percent = Math.floor(bytesReceived / bytesExpected * 100);
      if( percent > percentDone ) {
        percentDone = percent;
        console.log(percentDone);
      }
    });

  // parse the form and return a success message
  form.parse(req, function(err, fields, files) {
    res.writeHead(200, {'content-type': 'text/plain'});
    res.write('received upload:\n\n');
    res.end(util.inspect({fields: fields, files: files}));
  });

  return;
});

// start the server
app.listen(8080);

