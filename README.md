# development-self-signed-ca-and-cert
that allows you to generate a certificate authority and a certificate to work in the local environment quickly and easily.

#### Requirements

* openssl

#### How works?

1. The script request a name (the project name).
2. The script request a list of domains to sign (separated with ','), for example: acme.local, api.acme.local, *.acme.local
3. The script will be create a certification authority and a server certificate using the project name, after that, will be sign the server certificate usign the ca authority.
5. The script will be open a new window in the location of the generated files.
6. Import the generate caCert.pem in your os or browser.
7. Use the generated .cert in your app (nginx,apache ...).


<p align="center">
  <img src="https://raw.githubusercontent.com/kb05/development-self-signed-ca-and-cert/main/images/project.gif" width="560" height="280">
</p></p>
