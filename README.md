# development-self-signed-ca-and-cert
that allows you to generate a certificate authority and a certificate to work in the local environment quickly and easily.

#### Requirements

* openssl

#### How works?

1. The script request a name (the project name).
2. The script request a list of domains to sign (separated with ','), for example: acme.local, api.acme.local, *.acme.local
3. Create a certification authority using the project name
4. Create a server certificate using the project name (the same name)
5. Sign the server certificate usign the ca authority.


<p align="center">
    <img src="https://github.com/kb05/development-self-signed-ca-and-cert/main/images/development-self-signed-ca-and-cert.gif" width="560" height="280">
</p>
