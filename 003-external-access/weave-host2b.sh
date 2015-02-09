#!/bin/bash

echo "starting a service on 127.0.0.1:8888..."
nohup python -c 'import BaseHTTPServer as bhs, SimpleHTTPServer as shs; bhs.HTTPServer(("127.0.0.1", 8888), shs.SimpleHTTPRequestHandler).serve_forever()' &
