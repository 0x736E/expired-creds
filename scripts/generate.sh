#!/bin/bash

declare -a FORMATS=(
  "RFC4716"
  "PKCS8"
  "PEM"
)

declare -a BITS_RSA=(
  "512"
  "1024"
  "2048"
  "3072"
  "4096"
  "8192"
)

declare -a BITS_DSA=(
  "1024"
  "2048"
  "4096"
)

declare -a BITS_ECDSA=(
	"256"
	"384"
	"521"
)

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

function sshkeygen_generate() {

	local FORMAT="$1"
	local SAMPLE_INDEX="$2"

	# NOTE: 
	# 			Minimum RSA and DSA key size requirements of ssh-keygen mean that
	# 			some particularly small sizes are not supported, and will cause error.

	# dsa
	mkdir -p "./ssh_keygen/dsa/${FORMAT}/"
	for dsa_bitsize in "${BITS_RSA[@]}"
	do
		ssh-keygen -N "" -m "${FORMAT}" -t dsa -b "${dsa_bitsize}" -C "" -f "./ssh_keygen/dsa/${FORMAT}/dsa_${dsa_bitsize}_${SAMPLE_INDEX}"
	done

	# rsa
	mkdir -p "./ssh_keygen/rsa/${FORMAT}/"
	for rsa_bitsize in "${BITS_RSA[@]}"
	do
		ssh-keygen -N "" -m "${FORMAT}" -t rsa -b "${rsa_bitsize}" -C "" -f "./ssh_keygen/rsa/${FORMAT}/rsa_${rsa_bitsize}_${SAMPLE_INDEX}"
	done

	# ecdsa
	mkdir -p "./ssh_keygen/ecdsa/${FORMAT}/"
	for ecdsa_bitsize in "${BITS_ECDSA[@]}"
	do
		ssh-keygen -N "" -m "${FORMAT}" -t ecdsa -b "${ecdsa_bitsize}" -C "" -f "./ssh_keygen/ecdsa/${FORMAT}/ecdsa_${ecdsa_bitsize}_${SAMPLE_INDEX}"
	done

	# ed25519
	ssh-keygen -N "" -m "${FORMAT}" -t ed25519 -C "" -f "./ssh_keygen/ecc/${FORMAT}/ed25519_${SAMPLE_INDEX}"

}

function generate_sshkeygen_samples() {

	local SAMPLE_INDEX="${1}"

	for format in "${FORMATS[@]}"
	do
		sshkeygen_generate "${format}" "${SAMPLE_INDEX}"
	done

}

function generate_openssl_samples() {

	local SAMPLE_INDEX="${1}"

	# rsa
	mkdir -p "./openssl/rsa/PEM/"
	mkdir -p "./openssl/rsa/PKCS8/"
	for rsa_bitsize in "${BITS_RSA[@]}"
	do
		openssl genrsa -out "./openssl/rsa/PEM/rsa_${rsa_bitsize}_${SAMPLE_INDEX}.pem" "${rsa_bitsize}"
		openssl rsa -in "./openssl/rsa/PEM/rsa_${rsa_bitsize}_${SAMPLE_INDEX}.pem" -pubout -out "./openssl/rsa/PEM/rsa_${rsa_bitsize}_${SAMPLE_INDEX}.pub"
		openssl pkcs8 -topk8 -inform PEM -outform PEM -nocrypt -in "./openssl/rsa/PEM/rsa_${rsa_bitsize}_${SAMPLE_INDEX}.pem" -out "./openssl/rsa/PKCS8/rsa_${rsa_bitsize}_${SAMPLE_INDEX}.key"
	done


	# dsa
	mkdir -p "./openssl/dsa/PEM/"
	mkdir -p "./openssl/dsa/PKCS8/"
	for dsa_bitsize in "${BITS_DSA[@]}"
	do
		openssl dsaparam -out "./openssl_dsaparam_${dsa_bitsize}" "${dsa_bitsize}"
		openssl gendsa -out "./openssl/dsa/PEM/dsa_${dsa_bitsize}_${SAMPLE_INDEX}.pem" "./openssl_dsaparam_${dsa_bitsize}"
		openssl dsa -in "./openssl/dsa/PEM/dsa_${dsa_bitsize}_${SAMPLE_INDEX}.pem" -pubout -out "./openssl/dsa/PEM/dsa_${dsa_bitsize}_${SAMPLE_INDEX}.pub"
		openssl pkcs8 -topk8 -inform PEM -outform PEM -nocrypt -in "./openssl/dsa/PEM/dsa_${dsa_bitsize}_${SAMPLE_INDEX}.pem" -out "./openssl/dsa/PKCS8/dsa_${dsa_bitsize}_${SAMPLE_INDEX}.key"
	done


	# eliptic curve
	for curve in "${CURVES[@]}"
	do
		mkdir -p "./openssl/ecc/${curve}/PEM/"
		mkdir -p "./openssl/ecc/${curve}/PKCS8/"
		openssl ecparam -name "${curve}" -genkey -noout -out "./openssl/ecc/${curve}/PEM/${curve}_${SAMPLE_INDEX}.pem"
		openssl ec -in "./openssl/ecc/${curve}/PEM/${curve}_${SAMPLE_INDEX}.pem" -pubout -out "./openssl/ecc/${curve}/PEM/${curve}_${SAMPLE_INDEX}.pub"
		openssl pkcs8 -topk8 -inform PEM -outform PEM -nocrypt -in "./openssl/ecc/${curve}/PEM/${curve}_${SAMPLE_INDEX}.pem" -out "./openssl/ecc/${curve}/PKCS8/${curve}_${SAMPLE_INDEX}.key"
	done

}

# generate samples
function generate() {



	for SINDEX in {1..10}
	do
		echo "Generating sample ${SINDEX}..."
		generate_sshkeygen_samples "${SINDEX}"
		generate_openssl_samples "${SINDEX}"
	done

	rm openssl_dsaparam*
}

# lets do it!
generate