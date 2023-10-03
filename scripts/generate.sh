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

	local TARGET_ROOT=""
	local TARGET_NAME=""
	local TARGET_PATH=""

	# NOTE: 
	# 			Minimum RSA and DSA key size requirements of ssh-keygen mean that
	# 			some particularly small sizes are not supported, and will cause error.

	# dsa
	for dsa_bitsize in "${BITS_RSA[@]}"
	do
		TARGET_ROOT="./ssh_keygen/dsa/${dsa_bitsize}/${FORMAT}"
		TARGET_NAME="dsa_${dsa_bitsize}_${SAMPLE_INDEX}"
		TARGET_PATH="${TARGET_ROOT}/${TARGET_NAME}"

		mkdir -p "${TARGET_ROOT}"
		ssh-keygen -N "" -m "${FORMAT}" -t dsa -b "${dsa_bitsize}" -C "" -f "${TARGET_PATH}"
	done

	# rsa
	for rsa_bitsize in "${BITS_RSA[@]}"
	do
		TARGET_ROOT="./ssh_keygen/rsa/${rsa_bitsize}/${FORMAT}"
		TARGET_NAME="rsa_${rsa_bitsize}_${SAMPLE_INDEX}"
		TARGET_PATH="${TARGET_ROOT}/${TARGET_NAME}"

		mkdir -p "${TARGET_ROOT}"
		ssh-keygen -N "" -m "${FORMAT}" -t rsa -b "${rsa_bitsize}" -C "" -f "${TARGET_PATH}"
	done

	# ecdsa
	for ecdsa_bitsize in "${BITS_ECDSA[@]}"
	do
		TARGET_ROOT="./ssh_keygen/ecdsa/${ecdsa_bitsize}/${FORMAT}"
		TARGET_NAME="ecdsa_${ecdsa_bitsize}_${SAMPLE_INDEX}"
		TARGET_PATH="${TARGET_ROOT}/${TARGET_NAME}"

		mkdir -p "${TARGET_ROOT}"
		ssh-keygen -N "" -m "${FORMAT}" -t ecdsa -b "${ecdsa_bitsize}" -C "" -f "${TARGET_PATH}"
	done

	ed25519
	TARGET_ROOT="./ssh_keygen/ecc/ed2551/${ecdsa_bitsize}/${FORMAT}"
	TARGET_NAME="ecdsa_${ecdsa_bitsize}_${SAMPLE_INDEX}"
	TARGET_PATH="${TARGET_ROOT}/${TARGET_NAME}"

	mkdir -p "${TARGET_ROOT}"
	ssh-keygen -N "" -m "${FORMAT}" -t ed25519 -C "" -f "${TARGET_PATH}"

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

	local TARGET_ROOT=""
	local TARGET_NAME=""
	local PEM_TARGET=""
	local PUB_TARGET=""

	# rsa
	for rsa_bitsize in "${BITS_RSA[@]}"
	do
		TARGET_ROOT="./openssl/rsa/${rsa_bitsize}/"
		TARGET_NAME="rsa_${rsa_bitsize}_${SAMPLE_INDEX}"
		PEM_TARGET="${TARGET_ROOT}/PEM/${TARGET_NAME}.pem"
		PUB_TARGET="${TARGET_ROOT}/PEM/${TARGET_NAME}.pub"
		PKCS8_TARGET="${TARGET_ROOT}/PKCS8/${TARGET_NAME}.key"

		mkdir -p "${TARGET_ROOT}/PEM/"
		mkdir -p "${TARGET_ROOT}/PKCS8/"

		openssl genrsa -out "${PEM_TARGET}" "${rsa_bitsize}"
		openssl rsa -in "${PEM_TARGET}" -pubout -out "${PUB_TARGET}"
		openssl pkcs8 -topk8 -inform PEM -outform PEM -nocrypt -in "${PEM_TARGET}" -out "${PKCS8_TARGET}"
	done


	# dsa
	for dsa_bitsize in "${BITS_DSA[@]}"
	do
		TARGET_ROOT="./openssl/dsa/${dsa_bitsize}/"
		TARGET_NAME="rsa_${dsa_bitsize}_${SAMPLE_INDEX}"
		PEM_TARGET="${TARGET_ROOT}/PEM/${TARGET_NAME}.pem"
		PUB_TARGET="${TARGET_ROOT}/PEM/${TARGET_NAME}.pub"
		PKCS8_TARGET="${TARGET_ROOT}/PKCS8/${TARGET_NAME}.key"

		mkdir -p "${TARGET_ROOT}/PEM/"
		mkdir -p "${TARGET_ROOT}/PKCS8/"

		openssl dsaparam -genkey -noout -out "${PEM_TARGET}" "${dsa_bitsize}"
		openssl dsa -in "${PEM_TARGET}" -pubout -out "${PUB_TARGET}"
		openssl pkcs8 -topk8 -inform PEM -outform PEM -nocrypt -in "${PEM_TARGET}" -out "${PKCS8_TARGET}"
	done


	# eliptic curve
	for curve in "${CURVES[@]}"
	do
		TARGET_ROOT="./openssl/ecc/${curve}/"
		TARGET_NAME="rsa_${curve}_${SAMPLE_INDEX}"
		PEM_TARGET="${TARGET_ROOT}/PEM/${TARGET_NAME}.pem"
		PUB_TARGET="${TARGET_ROOT}/PEM/${TARGET_NAME}.pub"
		PKCS8_TARGET="${TARGET_ROOT}/PKCS8/${TARGET_NAME}.key"

		mkdir -p "${TARGET_ROOT}/PEM/"
		mkdir -p "${TARGET_ROOT}/PKCS8/"

		openssl ecparam -name "${curve}" -genkey -noout -out "${PEM_TARGET}"
		openssl ec -in "${PEM_TARGET}" -pubout -out "${PUB_TARGET}"
		openssl pkcs8 -topk8 -inform PEM -outform PEM -nocrypt -in "${PEM_TARGET}" -out "${PKCS8_TARGET}"
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
}

# lets do it!
generate