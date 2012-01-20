var app;
var http = require('http');
var https = require('https');

var url = require('url');
var fs = require('fs');

var port = process.env.PORT || 3000;
var redir = "http://localhost:" + port + "/token";
var properties = new Array();
var propfile = fs.readFile('../build.properties', 'utf8', function (err, data) {
	propArray = data.split('\n');
	for(x = 0; x < propArray.length; x++) {
		props = propArray[x].split('=');
		properties[props[0]] = props[1];
	}
	init();
});

function init() {
	app = http.createServer(function(req, res) {

	if(req.url.indexOf('/login') >= 0) {
		res.writeHead(302, {'Location' : properties['serverurl']+ '/services/oauth2/authorize?response_type=code&client_id='+properties['consumerkey']+'&redirect_uri='+redir});
		res.end("Login Redirected\n");
	}

	if(req.url.indexOf('/token') >= 0) {
		getAccessToken(url.parse(req.url,true).query.code,res);	
	}
	
	
	});
	
	app.listen(port);
	console.log("listening on port " + port);
}

function getAccessToken(token,clientResponse) {
	console.log('Getting Access Token');
	var post_data = 'code='+token+'&grant_type=authorization_code&client_id='+properties['consumerkey']+'&redirect_uri='+escape(redir)+'&client_secret='+properties['privatekey'];
	
	var options = {
		host: 'login.salesforce.com',
		path: '/services/oauth2/token',
		method: 'POST',
		headers: {
			'host': 'login.salesforce.com',
			'Content-Length': post_data.length,
			'Content-Type': 'application/x-www-form-urlencoded',
			'Accept':'application/jsonrequest',
			'Cache-Control':'no-cache,no-store,must-revalidate'
		}
	};

	var req = https.request(options, function(res) {
		  res.on('data', function(data) {
			session = JSON.parse(data).access_token;
		    fs.writeFileSync('../.session',session);
			console.log('Session written');
			});

		  res.on('end', function(d) {
		  	clientResponse.writeHead(200, {"Content-Type": "text/plain"});
			clientResponse.end("Session written, closing server.  You may close this window now.\n");
			setTimeout(process.exit(),100);
			});

		}).on('error', function(e) {
		   console.error(e);
		});

	req.write(post_data);
	req.end();

	}