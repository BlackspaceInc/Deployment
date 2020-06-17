#!/usr/bin/env bash
# Use 'localhost' for the 'Common name'
openssl req -x509 -sha256 -nodes -newkey rsa:2048 -days 365 -keyout localhost.key -out localhost.crt -subj '/CN=localhostsubj '/CN=localhost

sudo security add-trusted-cert -p ssl -d -r trustRoot -k ~/Library/Keychains/login.keychain localhost.crt 

# Add the cert to your keychain
open localhost.crt