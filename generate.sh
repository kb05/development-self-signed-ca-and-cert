#!/bin/bash
set -e;
scripPath=$(dirname $(readlink -f "$0"));


requireValue() {
	while [ -z "$value" ]; 
	do
		read -p "$*: " value;
	done
	echo $value;
}


echo -e ;

projectName=$(requireValue "Introduce the project name");

echo -e ;

domainsAltNames=$(requireValue "Introduce the domain names (alt_names,for example: *.local), separated with ','")

echo -e ;

v3CertificateContent=$(
	echo \
		"authorityKeyIdentifier=keyid,issuer\n"\
		"basicConstraints=CA:FALSE\n"\
		"keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment\n"\
		"subjectAltName = @alt_names\n\n"\
		"[alt_names]"\
)
index=0;
for i in $(echo $domainsAltNames | tr ";" "\n")
do
	index=$((index+1))
	v3CertificateContent="$v3CertificateContent\nDNS.$index = $i"  
done



## -----------------
cd workspaces;

if [ -d "$projectName" ]; then
    echo "The project already exists. ";
    read -p "do you want to overwrite it? (y/n)" 
	if [[ ! $REPLY =~ ^[Yy]$ ]]
	then
		exit;
	else
		echo '... removing $projectName';
    	rm -r $projectName;
	fi

fi

echo -e;

# Create project dir and paths
mkdir  $projectName;
cd $projectName;

mkdir  ca;
caPath=$(pwd)/ca;

mkdir  certificates;
certificatePath=$(pwd)/ca;


# CA variables
caKeyFileName="$projectName"CA.key;
caPemFileName="$projectName"CACert.pem;
firstPorjectLetters=${projectName:0:2}

# Cert variables
certCSRFileName="$projectName".csr;
certCRTFileName="$projectName".crt;
certCSRKeyFileName="$projectName"CSR.key;



# Generate the certification authority
cd ca;
openssl genrsa -out $caKeyFileName 3072
openssl req -new -key $caKeyFileName -subj "/C=$firstPorjectLetters/ST=$projectName/L=$projectName/O=$projectName/CN=$projectName" -x509 -days 365 -out $caPemFileName
cd ..;


# Generate the server cert
pwd;
cd certificates;
openssl req -new -nodes -out $certCSRFileName -newkey rsa:2048 -keyout $certCSRKeyFileName -subj "/C=$firstPorjectLetters/ST=$projectName/L=$projectName/O=$projectName/CN=$projectName" 


# Sign the server cert with the certification authority
echo -e $v3CertificateContent > v3.ext;
openssl x509 -req -in $certCSRFileName -CA $caPath/$caPemFileName -CAkey $caPath/$caKeyFileName -CAcreateserial -out $certCRTFileName -days 365 -sha256 -extfile v3.ext

echo -e "\n\nCongratulations !!!";
echo -e "You have generated the certificates correctly, you can find them in the following paths:\n";
echo -e "Certification Authority: $caPath \n"
echo -e "Server Certificate: $certificatePath \n"

echo -e "Usage:"
echo -e "import the file \"$caPath/$caPemFileName\" in your system (os,browser...) as a certification authority"
echo -e "Use the certification server file on your app: \"$certificatePath/$certCRTFileName\""
