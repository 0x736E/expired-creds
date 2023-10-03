#!/bin/bash

declare -a FORMATS=(
  "RFC4716"
  "PKCS8"
  "PEM"
)

declare -a BITS=(
  "256"
  "512"
  "1024"
  "2048"
  "4096"
  "8192"
)


rm ./ssh_keygen_*


function sshkeygen_generate() {

	FORMAT="$1"

	ssh-keygen -N "" -m "${FORMAT}" -t dsa -b 1024 -f "./ssh_keygen_"${FORMAT}"_dsa_1024"

	ssh-keygen -N "" -m "${FORMAT}" -t ecdsa -b 256 -f "./ssh_keygen_"${FORMAT}"_ecdsa_256"
	ssh-keygen -N "" -m "${FORMAT}" -t ecdsa -b 384 -f "./ssh_keygen_"${FORMAT}"_ecdsa_384"
	ssh-keygen -N "" -m "${FORMAT}" -t ecdsa -b 521 -f "./ssh_keygen_"${FORMAT}"_ecdsa_521"

	ssh-keygen -N "" -m "${FORMAT}" -t ecdsa-sk -f "./ssh_keygen_"${FORMAT}"_ecdsa_sk"

	ssh-keygen -N "" -m "${FORMAT}" -t ed25519 -b 256 -f "./ssh_keygen_"${FORMAT}"_ed25519_256"
	ssh-keygen -N "" -m "${FORMAT}" -t ed25519 -b 512 -f "./ssh_keygen_"${FORMAT}"_ed25519_512"
	ssh-keygen -N "" -m "${FORMAT}" -t ed25519 -b 1024 -f "./ssh_keygen_"${FORMAT}"_ed25519_1024"
	ssh-keygen -N "" -m "${FORMAT}" -t ed25519 -b 2048 -f "./ssh_keygen_"${FORMAT}"_ed25519_2048"
	ssh-keygen -N "" -m "${FORMAT}" -t ed25519 -b 4096 -f "./ssh_keygen_"${FORMAT}"_ed25519_4096"

	ssh-keygen -N "" -m "${FORMAT}" -t ed255190-sk -f "./ssh_keygen_"${FORMAT}"_ed255190_sk"

	ssh-keygen -N "" -m "${FORMAT}" -t rsa -b 1024 -f "./ssh_keygen_"${FORMAT}"_rsa_1024"
	ssh-keygen -N "" -m "${FORMAT}" -t rsa -b 2048 -f "./ssh_keygen_"${FORMAT}"_rsa_2048"
	ssh-keygen -N "" -m "${FORMAT}" -t rsa -b 3072 -f "./ssh_keygen_"${FORMAT}"_rsa_3072"
	ssh-keygen -N "" -m "${FORMAT}" -t rsa -b 4096 -f "./ssh_keygen_"${FORMAT}"_rsa_4096"
}

for format in "${FORMATS[@]}"
do
 :
 sshkeygen_generate "${format}"
done

rm ./ssh_keygen_*.pub


rm ./openssl_*

declare -a BITS_RSA=(
  "512"
  "1024"
  "2048"
  "3072"
  "4096"
  "8192"
)

for rsa_bitsize in "${BITS_RSA[@]}"
do
 :
 openssl genrsa -out "./openssl_rsa_${rsa_bitsize}.pem" "${rsa_bitsize}"
done


declare -a BITS_DSA=(
  "1024"
  "2048"
  "4096"
)

for dsa_bitsize in "${BITS_DSA[@]}"
do
 :
	openssl dsaparam -out "./openssl_dsaparam_${dsa_bitsize}" "${dsa_bitsize}"
	openssl gendsa -out "./openssl_dsa_${dsa_bitsize}" "./openssl_dsaparam_${dsa_bitsize}"
done

declare -a CURVES=(
	"secp112r1"                                                                                                                                                                                                                                                                                                                                                            
	"secp112r2"
	"secp128r1"
	"secp128r2"
	"secp160k1"
	"secp160r1"
	"secp160r2"
	"secp192k1"
	"secp224k1"
	"secp224r1"
	"secp256k1"
	"secp384r1"
	"secp521r1"
	"prime192v1"
	"prime192v2"
	"prime192v3"
	"prime239v1"
	"prime239v2"
	"prime239v3"
	"prime256v1"
	"sect113r1"
	"sect113r2"
	"sect131r1"
	"sect131r2"
	"sect163k1"
	"sect163r1"
	"sect163r2"
	"sect193r1"
	"sect193r2"
	"sect233k1"
	"sect233r1"
	"sect239k1"
	"sect283k1"
	"sect283r1"
	"sect409k1"
	"sect409r1"
	"sect571k1"
	"sect571r1"
	"c2pnb163v1"
	"c2pnb163v2"
	"c2pnb163v3"
	"c2pnb176v1"
	"c2tnb191v1"
	"c2tnb191v2"
	"c2tnb191v3"
	"c2pnb208w1"
	"c2tnb239v1"
	"c2tnb239v2"
	"c2tnb239v3"
	"c2pnb272w1"
	"c2pnb304w1"
	"c2tnb359v1"
	"c2pnb368w1"
	"c2tnb431r1"
	"wap-wsg-idm-ecid-wtls1"
	"wap-wsg-idm-ecid-wtls3"
	"wap-wsg-idm-ecid-wtls4"
	"wap-wsg-idm-ecid-wtls5"
	"wap-wsg-idm-ecid-wtls6"
	"wap-wsg-idm-ecid-wtls7"
	"wap-wsg-idm-ecid-wtls8"
	"wap-wsg-idm-ecid-wtls9"
	"wap-wsg-idm-ecid-wtls10"
	"wap-wsg-idm-ecid-wtls11"
	"wap-wsg-idm-ecid-wtls12"
	"Oakley-EC2N-3"
	"Oakley-EC2N-4"
	"brainpoolP160r1"
	"brainpoolP160t1"
	"brainpoolP192r1"
	"brainpoolP192t1"
	"brainpoolP224r1"
	"brainpoolP224t1"
	"brainpoolP256r1"
	"brainpoolP256t1"
	"brainpoolP320r1"
	"brainpoolP320t1"
	"brainpoolP384r1"
	"brainpoolP384t1"
	"brainpoolP512r1"
	"brainpoolP512t1"
	"SM2"     
)

for curve in "${CURVES[@]}"
do
 :
	openssl ecparam -name "${curve}" -genkey -noout -out "./openssl_${curve}.pem"
done

# openssl ecparam -name ./openssl_ecparam -genkey -noout -out ./openssl_ec_secp256k1.pem

rm ./openssl_dsaparam*