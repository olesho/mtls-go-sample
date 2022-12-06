openssl genrsa -out ca-key.pem 4096

cat <<EOF > ca_cert_config.txt     
[req]                       
distinguished_name = req_distinguished_name
x509_extensions    = v3_ca
prompt             = no

[req_distinguished_name]
countryName             = US
stateOrProvinceName     = California
localityName            = San Francisco
organizationName        = OrgNameHere
commonName              = OrgNameHere

[v3_ca]
basicConstraints        = critical,CA:TRUE
subjectKeyIdentifier    = hash
authorityKeyIdentifier  = keyid:always,issuer
EOF

openssl req -new -x509 -days 3650 \
-config ca_cert_config.txt \
-key ca-key.pem \
-out ca.pem

# Peer 1
openssl genrsa -out peer1-key.pem 4096

cat <<EOF > peer1-cert-config.txt
default_bit        = 4096
distinguished_name = req_distinguished_name
prompt             = no

[req_distinguished_name]
countryName             = US
stateOrProvinceName     = California
localityName            = San Francisco
organizationName        = OrgNameHere
commonName              = peer1
EOF

$ cat <<EOF > peer1-ext-config.txt
authorityKeyIdentifier = keyid,issuer
basicConstraints       = CA:FALSE
keyUsage               = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
extendedKeyUsage       = serverAuth, clientAuth
subjectAltName         = @alt_names

[alt_names]
DNS.1 = peer1
EOF

openssl req -new -key peer1-key.pem -out peer1-cert-csr.pem -config peer1-cert-config.txt

openssl x509 -req -in peer1-cert-csr.pem -out peer1-cert.pem \
-CA ca.pem -CAkey ca-key.pem -CAcreateserial \
-days 365 -sha512 -extfile peer1-ext-config.txt

# Peer 2

openssl genrsa -out peer2-key.pem 4096

cat <<EOF > peer2-cert-config.txt
default_bit        = 4096
distinguished_name = req_distinguished_name
prompt             = no

[req_distinguished_name]
countryName             = US
stateOrProvinceName     = California
localityName            = San Francisco
organizationName        = OrgNameHere
commonName              = peer2
EOF

cat <<EOF > peer2-ext-config.txt
authorityKeyIdentifier = keyid,issuer
basicConstraints       = CA:FALSE
keyUsage               = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
extendedKeyUsage       = serverAuth, clientAuth
subjectAltName         = @alt_names

[alt_names]
DNS.1 = peer2
EOF

openssl req -new -key peer2-key.pem -out peer2-cert-csr.pem -config peer2-cert-config.txt

openssl x509 -req -in peer2-cert-csr.pem -out peer2-cert.pem \
-CA ca.pem -CAkey ca-key.pem -CAcreateserial \
-days 365 -sha512 -extfile peer2-ext-config.txt
