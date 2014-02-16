; ########################################## Documentation ########################################
;- ################## Documentation
; 
; PolarSSL 1.1.4
; 
; PolarSSL Include  V0.900     Created 31.08.2012
;
; Version History:
;   - V0.900  31.08.2012
;     - Created everything
;
;   - V0.910  02.09.2012
;     - Fixed byte alignment in structures
;                   
; 
; Converted by David Vogel (Dadido3, Xaardas)
; 
; Contains:
;   - aes.h
;   - asn1.h
;   - bignum.h
;   - config.h
;   - ctr_drbg.h
;   - dhm.h
;   - entropy.h
;   - error.h
;   - havege.h
;   - rsa.h
;   - sha2.h
;   - sha4.h
;   - version.h
;   - x509.h
; 
; 
; ########################################## Constants ############################################
;- ################## Constants

; #### Version
#POLARSSL_VERSION_MAJOR = 1
#POLARSSL_VERSION_MINOR = 1
#POLARSSL_VERSION_PATCH = 4

#POLARSSL_VERSION_NUMBER        = $01010400
#POLARSSL_VERSION_STRING        = "1.1.4"
#POLARSSL_VERSION_STRING_FULL   = "PolarSSL 1.1.4"

; #### Config
#POLARSSL_HAVE_ASM        = #True
#POLARSSL_CIPHER_MODE_CFB = #True
#POLARSSL_CIPHER_MODE_CTR = #True
#POLARSSL_DEBUG_MSG       = #True
#POLARSSL_GENPRIME        = #True
#POLARSSL_FS_IO           = #True
#POLARSSL_PKCS1_V21       = #True
#POLARSSL_SELF_TEST       = #True
#POLARSSL_AES_C           = #True
#POLARSSL_ARC4_C          = #True
#POLARSSL_ASN1_PARSE_C    = #True
#POLARSSL_BASE64_C        = #True
#POLARSSL_BIGNUM_C        = #True
#POLARSSL_CAMELLIA_C      = #True
#POLARSSL_CERTS_C         = #True
#POLARSSL_CIPHER_C        = #True
#POLARSSL_CTR_DRBG_C      = #True
#POLARSSL_DEBUG_C         = #True
#POLARSSL_DES_C           = #True
#POLARSSL_DHM_C           = #True
#POLARSSL_ENTROPY_C       = #True
#POLARSSL_ERROR_C         = #True
#POLARSSL_HAVEGE_C        = #True
#POLARSSL_MD_C            = #True
#POLARSSL_MD5_C           = #True
#POLARSSL_NET_C           = #True
#POLARSSL_PADLOCK_C       = #True
#POLARSSL_PEM_C           = #True
#POLARSSL_RSA_C           = #True
#POLARSSL_SHA1_C          = #True
#POLARSSL_SHA2_C          = #True
#POLARSSL_SHA4_C          = #True
#POLARSSL_SSL_CLI_C       = #True
#POLARSSL_SSL_SRV_C       = #True
#POLARSSL_SSL_TLS_C       = #True
#POLARSSL_TIMING_C        = #True
#POLARSSL_VERSION_C       = #True
#POLARSSL_X509_PARSE_C    = #True
#POLARSSL_XTEA_C          = #True

; #### AES
#AES_ENCRYPT = 1
#AES_DECRYPT = 0

#POLARSSL_ERR_AES_INVALID_KEY_LENGTH    = -$0020 ;/**< Invalid key length. */
#POLARSSL_ERR_AES_INVALID_INPUT_LENGTH  = -$0022 ;/**< Invalid Data input length. */

; #### ASN.1 parsing
#POLARSSL_ERR_ASN1_OUT_OF_DATA                     = -$0014 ; /**< Out of Data when parsing an ASN1 Data Structure. */
#POLARSSL_ERR_ASN1_UNEXPECTED_TAG                  = -$0016 ; /**< ASN1 tag was of an unexpected value. */
#POLARSSL_ERR_ASN1_INVALID_LENGTH                  = -$0018 ; /**< Error when trying To determine the length Or invalid length. */
#POLARSSL_ERR_ASN1_LENGTH_MISMATCH                 = -$001A ; /**< Actual length differs from expected length. */
#POLARSSL_ERR_ASN1_INVALID_DATA                    = -$001C ; /**< Data is invalid. (Not used) */
#POLARSSL_ERR_ASN1_MALLOC_FAILED                   = -$001E ; /**< Memory allocation failed */

#ASN1_BOOLEAN                = $01
#ASN1_INTEGER                = $02
#ASN1_BIT_STRING             = $03
#ASN1_OCTET_STRING           = $04
#ASN1_NULL                   = $05
#ASN1_OID                    = $06
#ASN1_UTF8_STRING            = $0C
#ASN1_SEQUENCE               = $10
#ASN1_SET                    = $11
#ASN1_PRINTABLE_STRING       = $13
#ASN1_T61_STRING             = $14
#ASN1_IA5_STRING             = $16
#ASN1_UTC_TIME               = $17
#ASN1_GENERALIZED_TIME       = $18
#ASN1_UNIVERSAL_STRING       = $1C
#ASN1_BMP_STRING             = $1E
#ASN1_PRIMITIVE              = $00
#ASN1_CONSTRUCTED            = $20
#ASN1_CONTEXT_SPECIFIC       = $80

; #### CTR_DRBG based on AES-256 (NIST SP 800-90)
#POLARSSL_ERR_CTR_DRBG_ENTROPY_SOURCE_FAILED       = -$0034 ; /**< The entropy source failed. */
#POLARSSL_ERR_CTR_DRBG_REQUEST_TOO_BIG             = -$0036 ; /**< Too many random requested in single call. */
#POLARSSL_ERR_CTR_DRBG_INPUT_TOO_BIG               = -$0038 ; /**< Input too large (Entropy + additional). */
#POLARSSL_ERR_CTR_DRBG_FILE_IO_ERROR               = -$003A ; /**< Read/write error in file. */

#CTR_DRBG_BLOCKSIZE         = 16     ; /**< Block size used by the cipher                  */
#CTR_DRBG_KEYSIZE           = 32     ; /**< Key size used by the cipher                    */
#CTR_DRBG_KEYBITS           = ( #CTR_DRBG_KEYSIZE * 8 )
#CTR_DRBG_SEEDLEN           = ( #CTR_DRBG_KEYSIZE + #CTR_DRBG_BLOCKSIZE ) ; /**< The seed length (counter + AES key)            */
#CTR_DRBG_ENTROPY_LEN       = 48     ; /**< Amount of entropy used per seed by Default     */
#CTR_DRBG_RESEED_INTERVAL   = 10000  ; /**< Interval before reseed is performed by Default */
#CTR_DRBG_MAX_INPUT         = 256    ; /**< Maximum number of additional input bytes       */
#CTR_DRBG_MAX_REQUEST       = 1024   ; /**< Maximum number of requested bytes per call     */
#CTR_DRBG_MAX_SEED_INPUT    = 384    ; /**< Maximum size of (re)seed buffer                */

#CTR_DRBG_PR_OFF            = 0      ; /**< No prediction resistance       */
#CTR_DRBG_PR_ON             = 1      ; /**< Prediction resistance enabled  */

; #### Diffie-Hellman-Merkle key exchange
#POLARSSL_ERR_DHM_BAD_INPUT_DATA                   = -$3080 ; /**< Bad input parameters To function. */
#POLARSSL_ERR_DHM_READ_PARAMS_FAILED               = -$3100 ; /**< Reading of the DHM parameters failed. */
#POLARSSL_ERR_DHM_MAKE_PARAMS_FAILED               = -$3180 ; /**< Making of the DHM parameters failed. */
#POLARSSL_ERR_DHM_READ_PUBLIC_FAILED               = -$3200 ; /**< Reading of the public values failed. */
#POLARSSL_ERR_DHM_MAKE_PUBLIC_FAILED               = -$3280 ; /**< Making of the public value failed. */
#POLARSSL_ERR_DHM_CALC_SECRET_FAILED               = -$3300 ; /**< Calculation of the DHM secret failed. */

; #### Entropy accumulator implementation
#POLARSSL_ERR_ENTROPY_SOURCE_FAILED       = -$003C ; /**< Critical entropy source failure. */
#POLARSSL_ERR_ENTROPY_MAX_SOURCES         = -$003E ; /**< No more sources can be added. */
#POLARSSL_ERR_ENTROPY_NO_SOURCES_DEFINED  = -$0040 ; /**< No sources have been added To poll. */

#ENTROPY_MAX_SOURCES    = 20     ; /**< Maximum number of sources supported */
#ENTROPY_MAX_GATHER     = 128    ; /**< Maximum amount requested from entropy sources */
#ENTROPY_BLOCK_SIZE     = 64     ; /**< Block size of entropy accumulator (SHA-512) */

#ENTROPY_SOURCE_MANUAL  = #ENTROPY_MAX_SOURCES

; #### HAVEGE: HArdware Volatile Entropy Gathering and Expansion
#COLLECT_SIZE = 1024

; #### Multi-precision integer library
#POLARSSL_ERR_MPI_FILE_IO_ERROR                    = -$0002 ; /**< An error occurred While reading from Or writing To a file. */
#POLARSSL_ERR_MPI_BAD_INPUT_DATA                   = -$0004 ; /**< Bad input parameters To function. */
#POLARSSL_ERR_MPI_INVALID_CHARACTER                = -$0006 ; /**< There is an invalid character in the digit string. */
#POLARSSL_ERR_MPI_BUFFER_TOO_SMALL                 = -$0008 ; /**< The buffer is too small To write To. */
#POLARSSL_ERR_MPI_NEGATIVE_VALUE                   = -$000A ; /**< The input arguments are negative Or result in illegal output. */
#POLARSSL_ERR_MPI_DIVISION_BY_ZERO                 = -$000C ; /**< The input argument For division is zero, which is Not allowed. */
#POLARSSL_ERR_MPI_NOT_ACCEPTABLE                   = -$000E ; /**< The input arguments are Not acceptable. */
#POLARSSL_ERR_MPI_MALLOC_FAILED                    = -$0010 ; /**< Memory allocation failed. */

#POLARSSL_MPI_MAX_LIMBS                            = 10000

#POLARSSL_MPI_WINDOW_SIZE                          = 6       ; /**< Maximum windows size used. */

#POLARSSL_MPI_MAX_SIZE                             = 512     ; /**< Maximum number of bytes For usable MPIs. */
#POLARSSL_MPI_MAX_BITS                             = ( 8 * #POLARSSL_MPI_MAX_SIZE ) ; /**< Maximum number of bits For usable MPIs. */

#POLARSSL_MPI_READ_BUFFER_SIZE                      = 1250

; #### RSA: Error codes
#POLARSSL_ERR_RSA_BAD_INPUT_DATA    = -$4080  ;/**< Bad input parameters To function. */
#POLARSSL_ERR_RSA_INVALID_PADDING   = -$4100  ;/**< Input Data contains invalid padding And is rejected. */
#POLARSSL_ERR_RSA_KEY_GEN_FAILED    = -$4180  ;/**< Something failed during generation of a key. */
#POLARSSL_ERR_RSA_KEY_CHECK_FAILED  = -$4200  ;/**< Key failed To pass the libraries validity check. */
#POLARSSL_ERR_RSA_PUBLIC_FAILED     = -$4280  ;/**< The public key operation failed. */
#POLARSSL_ERR_RSA_PRIVATE_FAILED    = -$4300  ;/**< The private key operation failed. */
#POLARSSL_ERR_RSA_VERIFY_FAILED     = -$4380  ;/**< The PKCS#1 verification failed. */
#POLARSSL_ERR_RSA_OUTPUT_TOO_LARGE  = -$4400  ;/**< The output buffer For decryption is Not large enough. */
#POLARSSL_ERR_RSA_RNG_FAILED        = -$4480  ;/**< The random generator failed To generate non-zeros. */

; #### RSA: PKCS#1 constants
#SIG_RSA_RAW    =  0
#SIG_RSA_MD2    =  2
#SIG_RSA_MD4    =  3
#SIG_RSA_MD5    =  4
#SIG_RSA_SHA1   =  5
#SIG_RSA_SHA224 = 14
#SIG_RSA_SHA256 = 11
#SIG_RSA_SHA384 = 12
#SIG_RSA_SHA512 = 13

#RSA_PUBLIC     = 0
#RSA_PRIVATE    = 1

#RSA_PKCS_V15   = 0
#RSA_PKCS_V21   = 1

#RSA_SIGN       = 1
#RSA_CRYPT      = 2

#ASN1_STR_CONSTRUCTED_SEQUENCE  = "\x30"
#ASN1_STR_NULL                  = "\x05"
#ASN1_STR_OID                   = "\x06"
#ASN1_STR_OCTET_STRING          = "\x04"

#OID_DIGEST_ALG_MDX             = "\x2A\x86\x48\x86\xF7\x0D\x02\x00"
#OID_HASH_ALG_SHA1              = "\x2b\x0e\x03\x02\x1a"
#OID_HASH_ALG_SHA2X             = "\x60\x86\x48\x01\x65\x03\x04\x02\x00"

#OID_ISO_MEMBER_BODIES          = "\x2a"
#OID_ISO_IDENTIFIED_ORG         = "\x2b"

; #### RSA: ISO Member bodies OID parts
#OID_COUNTRY_US                 = "\x86\x48"
#OID_RSA_DATA_SECURITY          = "\x86\xf7\x0d"

; #### RSA: ISO Identified organization OID parts
#OID_OIW_SECSIG_SHA1            = "\x0e\x03\x02\x1a"

; /*
;  * DigestInfo ::= SEQUENCE {
;  *   digestAlgorithm DigestAlgorithmIdentifier,
;  *   digest Digest }
;  *
;  * DigestAlgorithmIdentifier ::= AlgorithmIdentifier
;  *
;  * Digest ::= OCTET STRING
;  */
#ASN1_HASH_MDX    = #ASN1_STR_CONSTRUCTED_SEQUENCE+Chr($20)+#ASN1_STR_CONSTRUCTED_SEQUENCE+Chr($0C)+#ASN1_STR_OID+Chr($08)+#OID_DIGEST_ALG_MDX+#ASN1_STR_NULL+Chr($00)+#ASN1_STR_OCTET_STRING+Chr($10)

#ASN1_HASH_SHA1   = #ASN1_STR_CONSTRUCTED_SEQUENCE+Chr($21)+#ASN1_STR_CONSTRUCTED_SEQUENCE+Chr($09)+#ASN1_STR_OID+Chr($05)+#OID_HASH_ALG_SHA1+#ASN1_STR_NULL+Chr($00)+#ASN1_STR_OCTET_STRING+Chr($14)

#ASN1_HASH_SHA2X  = #ASN1_STR_CONSTRUCTED_SEQUENCE+Chr($11)+#ASN1_STR_CONSTRUCTED_SEQUENCE+Chr($0d)+#ASN1_STR_OID+Chr($09)+#OID_HASH_ALG_SHA2X+#ASN1_STR_NULL+Chr($00)+#ASN1_STR_OCTET_STRING+Chr($00)

; #### SHA-224 and SHA-256 cryptographic hash function
#POLARSSL_ERR_SHA2_FILE_IO_ERROR      = -$0078 ; /**< Read/write error in file. */

; #### SHA-384 and SHA-512 cryptographic hash function
#POLARSSL_ERR_SHA4_FILE_IO_ERROR      = -$007A ; /**< Read/write error in file. */

; #### X.509 certificate and private key decoding
#POLARSSL_ERR_X509_FEATURE_UNAVAILABLE             = -$2080 ; /**< Unavailable feature, e.g. RSA hashing/encryption combination. */
#POLARSSL_ERR_X509_CERT_INVALID_PEM                = -$2100 ; /**< The PEM-encoded certificate contains invalid elements, e.g. invalid character. */ 
#POLARSSL_ERR_X509_CERT_INVALID_FORMAT             = -$2180 ; /**< The certificate format is invalid, e.g. different type expected. */
#POLARSSL_ERR_X509_CERT_INVALID_VERSION            = -$2200 ; /**< The certificate version element is invalid. */
#POLARSSL_ERR_X509_CERT_INVALID_SERIAL             = -$2280 ; /**< The serial tag Or value is invalid. */
#POLARSSL_ERR_X509_CERT_INVALID_ALG                = -$2300 ; /**< The algorithm tag Or value is invalid. */
#POLARSSL_ERR_X509_CERT_INVALID_NAME               = -$2380 ; /**< The name tag Or value is invalid. */
#POLARSSL_ERR_X509_CERT_INVALID_DATE               = -$2400 ; /**< The date tag Or value is invalid. */
#POLARSSL_ERR_X509_CERT_INVALID_PUBKEY             = -$2480 ; /**< The pubkey tag Or value is invalid (only RSA is supported). */
#POLARSSL_ERR_X509_CERT_INVALID_SIGNATURE          = -$2500 ; /**< The signature tag Or value invalid. */
#POLARSSL_ERR_X509_CERT_INVALID_EXTENSIONS         = -$2580 ; /**< The extension tag Or value is invalid. */
#POLARSSL_ERR_X509_CERT_UNKNOWN_VERSION            = -$2600 ; /**< Certificate Or CRL has an unsupported version number. */
#POLARSSL_ERR_X509_CERT_UNKNOWN_SIG_ALG            = -$2680 ; /**< Signature algorithm (oid) is unsupported. */
#POLARSSL_ERR_X509_UNKNOWN_PK_ALG                  = -$2700 ; /**< Key algorithm is unsupported (only RSA is supported). */
#POLARSSL_ERR_X509_CERT_SIG_MISMATCH               = -$2780 ; /**< Certificate signature algorithms do Not match. (see \c ::x509_cert sig_oid) */
#POLARSSL_ERR_X509_CERT_VERIFY_FAILED              = -$2800 ; /**< Certificate verification failed, e.g. CRL, CA Or signature check failed. */
#POLARSSL_ERR_X509_KEY_INVALID_VERSION             = -$2880 ; /**< Unsupported RSA key version */
#POLARSSL_ERR_X509_KEY_INVALID_FORMAT              = -$2900 ; /**< Invalid RSA key tag Or value. */
#POLARSSL_ERR_X509_CERT_UNKNOWN_FORMAT             = -$2980 ; /**< Format Not recognized As DER Or PEM. */
#POLARSSL_ERR_X509_INVALID_INPUT                   = -$2A00 ; /**< Input invalid. */
#POLARSSL_ERR_X509_MALLOC_FAILED                   = -$2A80 ; /**< Allocation of memory failed. */
#POLARSSL_ERR_X509_FILE_IO_ERROR                   = -$2B00 ; /**< Read/write of file failed. */

#BADCERT_EXPIRED            = $01 ; /**< The certificate validity has expired. */
#BADCERT_REVOKED            = $02 ; /**< The certificate has been revoked (is on a CRL). */
#BADCERT_CN_MISMATCH        = $04 ; /**< The certificate Common Name (CN) does Not match With the expected CN. */
#BADCERT_NOT_TRUSTED        = $08 ; /**< The certificate is Not correctly signed by the trusted CA. */
#BADCRL_NOT_TRUSTED         = $10 ; /**< CRL is Not correctly signed by the trusted CA. */
#BADCRL_EXPIRED             = $20 ; /**< CRL is expired. */
#BADCERT_MISSING            = $40 ; /**< Certificate was missing. */
#BADCERT_SKIP_VERIFY        = $80 ; /**< Certificate verification was skipped. */

#X520_COMMON_NAME           =     3
#X520_COUNTRY               =     6
#X520_LOCALITY              =     7
#X520_STATE                 =     8
#X520_ORGANIZATION          =    10
#X520_ORG_UNIT              =    11
#PKCS9_EMAIL                =     1

#X509_OUTPUT_DER            =  $01
#X509_OUTPUT_PEM            =  $02
#PEM_LINE_LENGTH            =    72
#X509_ISSUER                =  $01
#X509_SUBJECT               =  $02

#OID_X520               = Chr($55) + Chr($04)
#OID_CN                 = #OID_X520 + Chr($03)

#OID_PKCS1              = Chr($2A)+Chr($86)+Chr($48)+Chr($86)+Chr($F7)+Chr($0D)+Chr($01)+Chr($01)
#OID_PKCS1_RSA          = #OID_PKCS1 + Chr($01)

#OID_RSA_SHA_OBS        = Chr($2B)+Chr($0E)+Chr($03)+Chr($02)+Chr($1D)

#OID_PKCS9              = Chr($2A)+Chr($86)+Chr($48)+Chr($86)+Chr($F7)+Chr($0D)+Chr($01)+Chr($09)
#OID_PKCS9_EMAIL        = #OID_PKCS9 + Chr($01)

;/** ISO arc For standard certificate And CRL extensions */
#OID_ID_CE              = Chr($55)+Chr($1D); /**< id-ce OBJECT IDENTIFIER  ::=  {joint-iso-ccitt(2) ds(5) 29} */

;/**
; * Private Internet Extensions
; * { iso(1) identified-organization(3) dod(6) internet(1)
; *                      security(5) mechanisms(5) pkix(7) }
; */
#OID_PKIX               = Chr($2B)+Chr($06)+Chr($01)+Chr($05)+Chr($05)+Chr($07)

;/*
; * OIDs For standard certificate extensions
; */
#OID_AUTHORITY_KEY_IDENTIFIER   = #OID_ID_CE + Chr($23); /**< id-ce-authorityKeyIdentifier OBJECT IDENTIFIER ::=  { id-ce 35 } */
#OID_SUBJECT_KEY_IDENTIFIER     = #OID_ID_CE + Chr($0E); /**< id-ce-subjectKeyIdentifier OBJECT IDENTIFIER ::=  { id-ce 14 } */
#OID_KEY_USAGE                  = #OID_ID_CE + Chr($0F); /**< id-ce-keyUsage OBJECT IDENTIFIER ::=  { id-ce 15 } */
#OID_CERTIFICATE_POLICIES       = #OID_ID_CE + Chr($20); /**< id-ce-certificatePolicies OBJECT IDENTIFIER ::=  { id-ce 32 } */
#OID_POLICY_MAPPINGS            = #OID_ID_CE + Chr($21); /**< id-ce-policyMappings OBJECT IDENTIFIER ::=  { id-ce 33 } */
#OID_SUBJECT_ALT_NAME           = #OID_ID_CE + Chr($11); /**< id-ce-subjectAltName OBJECT IDENTIFIER ::=  { id-ce 17 } */
#OID_ISSUER_ALT_NAME            = #OID_ID_CE + Chr($12); /**< id-ce-issuerAltName OBJECT IDENTIFIER ::=  { id-ce 18 } */
#OID_SUBJECT_DIRECTORY_ATTRS    = #OID_ID_CE + Chr($09); /**< id-ce-subjectDirectoryAttributes OBJECT IDENTIFIER ::=  { id-ce 9 } */
#OID_BASIC_CONSTRAINTS          = #OID_ID_CE + Chr($13); /**< id-ce-basicConstraints OBJECT IDENTIFIER ::=  { id-ce 19 } */
#OID_NAME_CONSTRAINTS           = #OID_ID_CE + Chr($1E); /**< id-ce-nameConstraints OBJECT IDENTIFIER ::=  { id-ce 30 } */
#OID_POLICY_CONSTRAINTS         = #OID_ID_CE + Chr($24); /**< id-ce-policyConstraints OBJECT IDENTIFIER ::=  { id-ce 36 } */
#OID_EXTENDED_KEY_USAGE         = #OID_ID_CE + Chr($25); /**< id-ce-extKeyUsage OBJECT IDENTIFIER ::= { id-ce 37 } */
#OID_CRL_DISTRIBUTION_POINTS    = #OID_ID_CE + Chr($1F); /**< id-ce-cRLDistributionPoints OBJECT IDENTIFIER ::=  { id-ce 31 } */
#OID_INIHIBIT_ANYPOLICY         = #OID_ID_CE + Chr($36); /**< id-ce-inhibitAnyPolicy OBJECT IDENTIFIER ::=  { id-ce 54 } */
#OID_FRESHEST_CRL               = #OID_ID_CE + Chr($2E); /**< id-ce-freshestCRL OBJECT IDENTIFIER ::=  { id-ce 46 } */

;/*
; * X.509 v3 Key Usage Extension flags
; */
#KU_DIGITAL_SIGNATURE           = ($80) ; /* bit 0 */
#KU_NON_REPUDIATION             = ($40) ; /* bit 1 */
#KU_KEY_ENCIPHERMENT            = ($20) ; /* bit 2 */
#KU_DATA_ENCIPHERMENT           = ($10) ; /* bit 3 */
#KU_KEY_AGREEMENT               = ($08) ; /* bit 4 */
#KU_KEY_CERT_SIGN               = ($04) ; /* bit 5 */
#KU_CRL_SIGN                    = ($02) ; /* bit 6 */

;/*
; * X.509 v3 Extended key usage OIDs
; */
#OID_ANY_EXTENDED_KEY_USAGE     = #OID_EXTENDED_KEY_USAGE + Chr($00); /**< anyExtendedKeyUsage OBJECT IDENTIFIER ::= { id-ce-extKeyUsage 0 } */

#OID_KP                         = #OID_PKIX + Chr($03); /**< id-kp OBJECT IDENTIFIER ::= { id-pkix 3 } */
#OID_SERVER_AUTH                = #OID_KP + Chr($01); /**< id-kp-serverAuth OBJECT IDENTIFIER ::= { id-kp 1 } */
#OID_CLIENT_AUTH                = #OID_KP + Chr($02); /**< id-kp-clientAuth OBJECT IDENTIFIER ::= { id-kp 2 } */
#OID_CODE_SIGNING               = #OID_KP + Chr($03); /**< id-kp-codeSigning OBJECT IDENTIFIER ::= { id-kp 3 } */
#OID_EMAIL_PROTECTION           = #OID_KP + Chr($04); /**< id-kp-emailProtection OBJECT IDENTIFIER ::= { id-kp 4 } */
#OID_TIME_STAMPING              = #OID_KP + Chr($08); /**< id-kp-timeStamping OBJECT IDENTIFIER ::= { id-kp 8 } */
#OID_OCSP_SIGNING               = #OID_KP + Chr($09); /**< id-kp-OCSPSigning OBJECT IDENTIFIER ::= { id-kp 9 } */

#STRING_SERVER_AUTH             = "TLS Web Server Authentication"
#STRING_CLIENT_AUTH             = "TLS Web Client Authentication"
#STRING_CODE_SIGNING            = "Code Signing"
#STRING_EMAIL_PROTECTION        = "E-mail Protection"
#STRING_TIME_STAMPING           = "Time Stamping"
#STRING_OCSP_SIGNING            = "OCSP Signing"

;/*
; * OIDs For CRL extensions
; */
#OID_PRIVATE_KEY_USAGE_PERIOD   = #OID_ID_CE + Chr($10)
#OID_CRL_NUMBER                 = #OID_ID_CE + Chr($14); /**< id-ce-cRLNumber OBJECT IDENTIFIER ::= { id-ce 20 } */

;/*
; * Netscape certificate extensions
; */
#OID_NETSCAPE               = Chr($60)+Chr($86)+Chr($48)+Chr($01)+Chr($86)+Chr($F8)+Chr($42); /**< Netscape OID */
#OID_NS_CERT                = #OID_NETSCAPE + Chr($01)
#OID_NS_CERT_TYPE           = #OID_NS_CERT  + Chr($01)
#OID_NS_BASE_URL            = #OID_NS_CERT  + Chr($02)
#OID_NS_REVOCATION_URL      = #OID_NS_CERT  + Chr($03)
#OID_NS_CA_REVOCATION_URL   = #OID_NS_CERT  + Chr($04)
#OID_NS_RENEWAL_URL         = #OID_NS_CERT  + Chr($07)
#OID_NS_CA_POLICY_URL       = #OID_NS_CERT  + Chr($08)
#OID_NS_SSL_SERVER_NAME     = #OID_NS_CERT  + Chr($0C)
#OID_NS_COMMENT             = #OID_NS_CERT  + Chr($0D)
#OID_NS_DATA_TYPE           = #OID_NETSCAPE + Chr($02)
#OID_NS_CERT_SEQUENCE       = #OID_NS_DATA_TYPE + Chr($05)

;/*
; * Netscape certificate types
; * (http://www.mozilla.org/projects/security/pki/nss/tech-notes/tn3.html)
; */

#NS_CERT_TYPE_SSL_CLIENT        = ($80) ; /* bit 0 */
#NS_CERT_TYPE_SSL_SERVER        = ($40) ; /* bit 1 */
#NS_CERT_TYPE_EMAIL             = ($20) ; /* bit 2 */
#NS_CERT_TYPE_OBJECT_SIGNING    = ($10) ; /* bit 3 */
#NS_CERT_TYPE_RESERVED          = ($08) ; /* bit 4 */
#NS_CERT_TYPE_SSL_CA            = ($04) ; /* bit 5 */
#NS_CERT_TYPE_EMAIL_CA          = ($02) ; /* bit 6 */
#NS_CERT_TYPE_OBJECT_SIGNING_CA = ($01) ; /* bit 7 */

#EXT_AUTHORITY_KEY_IDENTIFIER   = (1 << 0)
#EXT_SUBJECT_KEY_IDENTIFIER     = (1 << 1)
#EXT_KEY_USAGE                  = (1 << 2)
#EXT_CERTIFICATE_POLICIES       = (1 << 3)
#EXT_POLICY_MAPPINGS            = (1 << 4)
#EXT_SUBJECT_ALT_NAME           = (1 << 5)
#EXT_ISSUER_ALT_NAME            = (1 << 6)
#EXT_SUBJECT_DIRECTORY_ATTRS    = (1 << 7)
#EXT_BASIC_CONSTRAINTS          = (1 << 8)
#EXT_NAME_CONSTRAINTS           = (1 << 9)
#EXT_POLICY_CONSTRAINTS         = (1 << 10)
#EXT_EXTENDED_KEY_USAGE         = (1 << 11)
#EXT_CRL_DISTRIBUTION_POINTS    = (1 << 12)
#EXT_INIHIBIT_ANYPOLICY         = (1 << 13)
#EXT_FRESHEST_CRL               = (1 << 14)

#EXT_NS_CERT_TYPE               = (1 << 16)

;/*
; * Storage format identifiers
; * Recognized formats: PEM And DER
; */
#X509_FORMAT_DER                = 1
#X509_FORMAT_PEM                = 2

; ########################################## Types ################################################
;- ################## Types

Macro FILE : i : EndMacro

; #### Multi-precision integer library
CompilerIf Defined(POLARSSL_HAVE_INT8, #PB_Constant)
  Macro t_sint : b : EndMacro
  Macro t_uint : a : EndMacro
  Macro t_udbl : u : EndMacro
CompilerElse
  CompilerIf Defined(POLARSSL_HAVE_INT16, #PB_Constant)
    Macro t_sint : w : EndMacro
    Macro t_uint : u : EndMacro
    Macro t_udbl : l : EndMacro
  CompilerElse
    Macro t_sint : l : EndMacro
    Macro t_uint : l : EndMacro
  CompilerEndIf
CompilerEndIf

; #### X.509 certificate and private key decoding
Macro x509_buf : asn1_buf : EndMacro

Macro x509_bitstring : asn1_bitstring : EndMacro

Macro x509_sequence : asn1_sequence : EndMacro

; ########################################## Structures ###########################################
;- ################## Structures

Macro Structure_Padding(__Name, __Bytes_x86, __Bytes_x64)
  CompilerIf #PB_Compiler_Processor = #PB_Processor_x86
  __Name#_Padding.a[__Bytes_x86]
  CompilerEndIf
  CompilerIf #PB_Compiler_Processor = #PB_Processor_x64
  __Name#_Padding.a[__Bytes_x64]
  CompilerEndIf
EndMacro

; #### Multi-precision integer library
Structure mpi
  s.l ; /*!<  integer sign      */
  Structure_Padding(A, 0, 4)
  n.i ; /*!<  total # of limbs  */
  *p  ; /*!<  pointer To limbs  */
EndStructure

; #### AES
Structure aes_context
  nr.l      ; /*!<  number of rounds  */
  Structure_Padding(A, 0, 4)
  *rk.long  ; /*!<  AES round keys    */
  buf.l[68] ; /*!<  unaligned data    */
EndStructure

; #### ASN.1 parsing
Structure asn1_buf
  tag.l               ; /**< ASN1 type, e.g. ASN1_UTF8_STRING. */
  Structure_Padding(A, 0, 4)
  len.i               ; /**< ASN1 length, e.g. in octets. */
  *p                  ; /**< ASN1 Data, e.g. in ASCII. */
EndStructure

Structure asn1_bitstring
  len.i               ; /**< ASN1 length, e.g. in octets. */
  unused_bits.a       ; /**< Number of unused bits at the End of the string */
  Structure_Padding(A, 3, 7)
  *p                  ; /**< Raw ASN1 Data For the bit string */
EndStructure

Structure asn1_sequence
  buf.asn1_buf        ; /**< Buffer containing the given ASN.1 item. */
  *Next.asn1_sequence ; /**< The Next entry in the sequence. */
EndStructure

; #### CTR_DRBG based on AES-256 (NIST SP 800-90)
Structure ctr_drbg_context
  counter.a[16]           ; /*!<  counter (V)       */
  reseed_counter.l        ; /*!<  reseed counter    */
  prediction_resistance.l ; /*!<  enable prediction resistance (Automatic reseed before every random generation) */
  entropy_len.i           ; /*!<  amount of entropy grabbed on each (re)seed    */
  reseed_interval.l       ; /*!<  reseed interval   */
  
  Structure_Padding(A, 0, 4)
  
  aes_ctx.aes_context     ; /*!<  AES context       */
  
  ; Callbacks (Entropy)
  *f_entropy.f_entropy
  
  *p_entropy              ; /*!<  context for the entropy function */
EndStructure

; #### Diffie-Hellman-Merkle key exchange
Structure dhm_context
  len.i   ; /*!<  size(P) in chars  */
  P.mpi   ; /*!<  prime modulus     */
  G.mpi   ; /*!<  generator         */
  X.mpi   ; /*!<  secret value      */
  GX.mpi  ; /*!<  self = G^X mod P  */
  GY.mpi  ; /*!<  peer = G^Y mod P  */
  K.mpi   ; /*!<  key = GY^X mod P  */
  RP.mpi  ; /*!<  cached R^2 mod P  */
EndStructure

; #### SHA-224 and SHA-256 cryptographic hash function
Structure sha2_context
  total.l[2]    ; /*!< number of bytes processed  */
  state.l[8]    ; /*!< intermediate digest state  */
  buffer.a[64]  ; /*!< Data block being processed */
  
  ipad.a[64]    ; /*!< HMAC: inner padding        */
  opad.a[64]    ; /*!< HMAC: outer padding        */
  is224.l       ; /*!< 0 => SHA-256, Else SHA-224 */
  Structure_Padding(A, 0, 4)
EndStructure

; #### SHA-384 and SHA-512 cryptographic hash function
Structure sha4_context
  total.q[2]    ; /*!< number of bytes processed  */
  state.q[8]    ; /*!< intermediate digest state  */
  buffer.a[128] ; /*!< Data block being processed */
  
  ipad.a[128]   ; /*!< HMAC: inner padding        */
  opad.a[128]   ; /*!< HMAC: outer padding        */
  is384.l       ; /*!< 0 => SHA-512, Else SHA-384 */
  Structure_Padding(A, 0, 4)
EndStructure

; #### HAVEGE: HArdware Volatile Entropy Gathering and Expansion
Structure havege_state
  PT1.l
  PT2.l
  offset.l[2]
  pool.l[#COLLECT_SIZE]
  WALK.l[8192]
EndStructure

; #### Entropy accumulator implementation
Structure source_state
  *f_source.f_source_ptr  ; /**< The entropy source callback */
  *p_source               ; /**< The callback data pointer */
  size.i                  ; /**< Amount received */
  threshold.i             ; /**< Minimum level required before release */
EndStructure

Structure entropy_context
  accumulator.sha4_context
  source_count.l
  Structure_Padding(A, 0, 4)
  source.source_state[#ENTROPY_MAX_SOURCES]
  CompilerIf #POLARSSL_HAVEGE_C
  havege_data.havege_state
  CompilerEndIf
EndStructure

; #### RSA
Structure rsa_context ; SizeOf_x86 = 148, SizeOf_x64=288
  ver.l     ; /*!<  always 0          */
  Structure_Padding(A, 0, 4)
  len.i     ; /*!<  size(N) in chars  */
  
  N.mpi     ; /*!<  public modulus    */
  E.mpi     ; /*!<  public exponent   */
  
  D.mpi     ; /*!<  private exponent  */
  P.mpi     ; /*!<  1st prime factor  */
  Q.mpi     ; /*!<  2nd prime factor  */
  DP.mpi    ; /*!<  D % (P - 1)       */
  DQ.mpi    ; /*!<  D % (Q - 1)       */
  QP.mpi    ; /*!<  1 / (Q % P)       */
  
  RN.mpi    ; /*!<  cached R^2 mod N  */
  RP.mpi    ; /*!<  cached R^2 mod P  */
  RQ.mpi    ; /*!<  cached R^2 mod Q  */
  
  padding.l ; /*!<  RSA_PKCS_V15 for 1.5 padding and RSA_PKCS_v21 For OAEP/PSS */
  hash_id.l ; /*!<  Hash identifier of md_type_t as specified in the md.h header file For the EME-OAEP And EMSA-PSS encoding */
EndStructure

; #### X.509 certificate and private key decoding
Structure x509_name
  oid.x509_buf    ; /**< The object identifier. */
  val.x509_buf    ; /**< The named value. */
  *Next.x509_name ; /**< The Next named information object. */
EndStructure

Structure x509_time
  year.l    ; /**< Date. */
  mon.l
  day.l
  hour.l    ; /**< Time. */
  min.l
  sec.l
EndStructure

Structure x509_cert
  raw.x509_buf                ; /**< The raw certificate Data (DER). */
  tbs.x509_buf                ; /**< The raw certificate body (DER). The part that is To Be Signed. */
  
  version.l                   ; /**< The X.509 version. (0=v1, 1=v2, 2=v3) */
  Structure_Padding(A, 0, 4)
  serial.x509_buf             ; /**< Unique id For certificate issued by a specific CA. */
  sig_oid1.x509_buf           ; /**< Signature algorithm, e.g. sha1RSA */
  
  issuer_raw.x509_buf         ; /**< The raw issuer Data (DER). Used For quick comparison. */
  subject_raw.x509_buf        ; /**< The raw subject Data (DER). Used For quick comparison. */
  
  issuer.x509_name            ; /**< The parsed issuer Data (named information object). */
  subject.x509_name           ; /**< The parsed subject Data (named information object). */
  
  valid_from.x509_time        ; /**< Start time of certificate validity. */
  valid_to.x509_time          ; /**< End time of certificate validity. */
  
  pk_oid.x509_buf             ; /**< Subject public key info. Includes the public key algorithm And the key itself. */
  rsa.rsa_context             ; /**< Container For the RSA context. Only RSA is supported For public keys at this time. */
  
  issuer_id.x509_buf          ; /**< Optional X.509 v2/v3 issuer unique identifier. */
  subject_id.x509_buf         ; /**< Optional X.509 v2/v3 subject unique identifier. */
  v3_ext.x509_buf             ; /**< Optional X.509 v3 extensions. Only Basic Contraints are supported at this time. */
  
  ext_types.l                 ; /**< Bit string containing detected And parsed extensions */
  ca_istrue.l                 ; /**< Optional Basic Constraint extension value: 1 If this certificate belongs To a CA, 0 otherwise. */
  max_pathlen.l               ; /**< Optional Basic Constraint extension value: The maximum path length To the root certificate. */
  
  key_usage.a                 ; /**< Optional key usage extension value: See the values below */
  Structure_Padding(B, 0, 3)
  ext_key_usage.x509_sequence ; /**< Optional List of extended key usage OIDs. */
  
  ns_cert_type.a              ; /**< Optional Netscape certificate type extension value: See the values below */
  Structure_Padding(C, 3, 7)
  sig_oid2.x509_buf           ; /**< Signature algorithm. Must match sig_oid1. */
  sig.x509_buf                ; /**< Signature: hash of the tbs part signed With the private key. */
  sig_alg.l                   ; /**< Internal representation of the signature algorithm, e.g. SIG_RSA_MD2 */
  
  Structure_Padding(D, 0, 4)
  
  *Next.x509_cert             ; /**< Next certificate in the CA-chain. */ 
EndStructure

Structure x509_crl_entry
  raw.x509_buf
  
  serial.x509_buf
  
  revocation_date.x509_time
  
  entry_ext.x509_buf
  
  *Next.x509_crl_entry
EndStructure

Structure x509_crl
  raw.x509_buf          ; /**< The raw certificate Data (DER). */
  tbs.x509_buf          ; /**< The raw certificate body (DER). The part that is To Be Signed. */
  
  version.l
  Structure_Padding(A, 0, 4)
  sig_oid1.x509_buf
  
  issuer_raw.x509_buf   ; /**< The raw issuer Data (DER). */
  
  issuer.x509_name      ; /**< The parsed issuer Data (named information object). */
  
  this_update.x509_time
  next_update.x509_time
  
  entry.x509_crl_entry  ; /**< The CRL entries containing the certificate revocation times For this CA. */
  
  crl_ext.x509_buf
  
  sig_oid2.x509_buf
  sig.x509_buf
  sig_alg.l
  
  Structure_Padding(B, 0, 4)
  
  *Next.x509_crl
EndStructure

; ########################################## Variables ############################################

; ########################################## Macros ###############################################
;- ################## Macros

; #### ASN.1 parsing
Macro OID_SIZE(x)
  (SizeOf(x) - 1)
EndMacro

; #### Multi-precision integer library
;Macro MPI_CHK(f)
;  If ( ( ret = (f) ) != 0 ) : Goto cleanup : EndIf
;EndMacro

; ########################################## Prototypes ###########################################
;- ################## Prototypes

PrototypeC f_rng(*A, *B, C.i)

;/**
; * \brief           Entropy poll callback pointer
; *
; * \param Data      Callback-specific Data pointer
; * \param output    Data To fill
; * \param len       Maximum size To provide
; * \param olen      The actual amount of bytes put into the buffer (Can be 0)
; *
; * \return          0 If no critical failures occurred,
; *                  POLARSSL_ERR_ENTROPY_SOURCE_FAILED otherwise
; */
PrototypeC f_source_ptr(*Data_, *output, len.i, *olen.integer)

PrototypeC f_entropy(*A, *B, C.i)

PrototypeC f_vrfy(*A, *B.x509_cert, C.l, D.l)

; ########################################## Declares #############################################

; ########################################## Imports ##############################################
;- ################## Imports

CompilerIf #PB_Compiler_OS = #PB_OS_Windows
  CompilerIf #PB_Compiler_Processor = #PB_Processor_x86
    ImportC "Libraries/libpolarssl.x86.lib"  ; Windows x86
  CompilerElse
    ImportC "Libraries/libpolarssl.x64.lib"  ; Windows x64
  CompilerEndIf
CompilerElse
  CompilerIf #PB_Compiler_Processor = #PB_Processor_x86
    ImportC "Libraries/libpolarssl.x86.a"    ; Linux x86
  CompilerElse
    ImportC "Libraries/libpolarssl.x64.a"    ; Linux x64
  CompilerEndIf
CompilerEndIf
  
  ;- aes_setkey_enc
  ;/**
  ; * \brief          AES key schedule (encryption)
  ; *
  ; * \param ctx      AES context To be initialized
  ; * \param key      encryption key
  ; * \param keysize  must be 128, 192 Or 256
  ; *
  ; * \return         0 If successful, Or POLARSSL_ERR_AES_INVALID_KEY_LENGTH
  ; */
  aes_setkey_enc(*ctx.aes_context, *key, keysize.l)
  
  ;- aes_setkey_dec
  ;/**
  ; * \brief          AES key schedule (decryption)
  ; *
  ; * \param ctx      AES context To be initialized
  ; * \param key      decryption key
  ; * \param keysize  must be 128, 192 Or 256
  ; *
  ; * \return         0 If successful, Or POLARSSL_ERR_AES_INVALID_KEY_LENGTH
  ; */
  aes_setkey_dec(*ctx.aes_context, *key, keysize.l)
  
  ;- aes_crypt_ecb
  ;/**
  ; * \brief          AES-ECB block encryption/decryption
  ; *
  ; * \param ctx      AES context
  ; * \param mode     AES_ENCRYPT Or AES_DECRYPT
  ; * \param input    16-byte input block
  ; * \param output   16-byte output block
  ; *
  ; * \return         0 If successful
  ; */
  aes_crypt_ecb(*ctx.aes_context, mode.l, *input, *output)
  
  ;- aes_crypt_cbc
  ;/**
  ; * \brief          AES-CBC buffer encryption/decryption
  ; *                 Length should be a multiple of the block
  ; *                 size (16 bytes)
  ; *
  ; * \param ctx      AES context
  ; * \param mode     AES_ENCRYPT Or AES_DECRYPT
  ; * \param length   length of the input Data
  ; * \param iv       initialization vector (updated after use)
  ; * \param input    buffer holding the input Data
  ; * \param output   buffer holding the output Data
  ; *
  ; * \return         0 If successful, Or POLARSSL_ERR_AES_INVALID_INPUT_LENGTH
  ; */
  aes_crypt_cbc(*ctx.aes_context, mode.l, length.i, *iv, *input, *output)
  
  ;- aes_crypt_cfb128
  ;/**
  ; * \brief          AES-CFB128 buffer encryption/decryption.
  ; *
  ; * Note: Due To the nature of CFB you should use the same key schedule For
  ; * both encryption And decryption. So a context initialized With
  ; * aes_setkey_enc() For both AES_ENCRYPT And AES_DECRYPT.
  ; *
  ; * both 
  ; * \param ctx      AES context
  ; * \param mode     AES_ENCRYPT Or AES_DECRYPT
  ; * \param length   length of the input Data
  ; * \param iv_off   offset in IV (updated after use)
  ; * \param iv       initialization vector (updated after use)
  ; * \param input    buffer holding the input Data
  ; * \param output   buffer holding the output Data
  ; *
  ; * \return         0 If successful
  ; */
  aes_crypt_cfb128(*ctx.aes_context, mode.l, length.i, *iv_off.Integer, *iv, *input, *output)
  
  ;- aes_crypt_ctr
  ;/*
  ; * \brief               AES-CTR buffer encryption/decryption
  ; *
  ; * Warning: You have To keep the maximum use of your counter in mind!
  ; *
  ; * Note: Due To the nature of CTR you should use the same key schedule For
  ; * both encryption And decryption. So a context initialized With
  ; * aes_setkey_enc() For both AES_ENCRYPT And AES_DECRYPT.
  ; *
  ; * \param length        The length of the Data
  ; * \param nc_off        The offset in the current stream_block (For resuming
  ; *                      within current cipher stream). The offset pointer To
  ; *                      should be 0 at the start of a stream.
  ; * \param nonce_counter The 128-bit nonce And counter.
  ; * \param stream_block  The saved stream-block For resuming. Is overwritten
  ; *                      by the function.
  ; * \param input         The input Data stream
  ; * \param output        The output Data stream
  ; *
  ; * \return         0 If successful
  ; */
  aes_crypt_ctr(*ctx.aes_context, length.i, *nc_off, *nonce_counter, *stream_block, *input, *output)
  
  ;- aes_self_test
  ;/**
  ; * \brief          Checkup routine
  ; *
  ; * \return         0 If successful, Or 1 If the test failed
  ; */
  aes_self_test(verbose.l)
  
  ;- asn1_get_len
  ;/**
  ; * Get the length of an ASN.1 element.
  ; * Updates the pointer To immediately behind the length.
  ; *
  ; * \param p     The position in the ASN.1 Data
  ; * \param End   End of Data
  ; * \param len   The variable that will receive the value
  ; *
  ; * \return      0 If successful, POLARSSL_ERR_ASN1_OUT_OF_DATA on reaching
  ; *              End of Data, POLARSSL_ERR_ASN1_INVALID_LENGTH If length is
  ; *              unparseable.
  ; */
  asn1_get_len(*p, *End__, *len.Integer)
  
  ;- asn1_get_tag
  ;/**
  ; * Get the tag And length of the tag. Check For the requested tag.
  ; * Updates the pointer To immediately behind the tag And length.
  ; *
  ; * \param p     The position in the ASN.1 Data
  ; * \param End   End of Data
  ; * \param len   The variable that will receive the length
  ; * \param tag   The expected tag
  ; *
  ; * \return      0 If successful, POLARSSL_ERR_ASN1_UNEXPECTED_TAG If tag did
  ; *              Not match requested tag, Or another specific ASN.1 error code.
  ; */
  asn1_get_tag(*p, *End_, *len.Integer, tag.l)
  
  ;- asn1_get_bool
  ;/**
  ; * Retrieve a boolean ASN.1 tag And its value.
  ; * Updates the pointer To immediately behind the full tag.
  ; *
  ; * \param p     The position in the ASN.1 Data
  ; * \param End   End of Data
  ; * \param val   The variable that will receive the value
  ; *
  ; * \return      0 If successful Or a specific ASN.1 error code.
  ; */
  asn1_get_bool(*p, *End_, *val.Long)
  
  ;- asn1_get_int
  ;/**
  ; * Retrieve an integer ASN.1 tag And its value.
  ; * Updates the pointer To immediately behind the full tag.
  ; *
  ; * \param p     The position in the ASN.1 Data
  ; * \param End   End of Data
  ; * \param val   The variable that will receive the value
  ; *
  ; * \return      0 If successful Or a specific ASN.1 error code.
  ; */
  asn1_get_int(*p, *End_, *val.Long)
  
  ;- asn1_get_bitstring
  ;/**
  ; * Retrieve a bitstring ASN.1 tag And its value.
  ; * Updates the pointer To immediately behind the full tag.
  ; *
  ; * \param p     The position in the ASN.1 Data
  ; * \param End   End of Data
  ; * \param bs    The variable that will receive the value
  ; *
  ; * \return      0 If successful Or a specific ASN.1 error code.
  ; */
  asn1_get_bitstring(*p, *End_, *bs.asn1_bitstring)
  
  ;- asn1_get_sequence_of
  ;/**
  ; * Parses And splits an ASN.1 "SEQUENCE OF <tag>"
  ; * Updated the pointer To immediately behind the full sequence tag.
  ; *
  ; * \param p     The position in the ASN.1 Data
  ; * \param End   End of Data
  ; * \param cur   First variable in the chain To fill
  ; * \param tag   Type of sequence
  ; *
  ; * \return      0 If successful Or a specific ASN.1 error code.
  ; */
  asn1_get_sequence_of(*p, *End_, *cur.asn1_sequence, tag.l)
  
  CompilerIf #POLARSSL_BIGNUM_C
  ;- asn1_get_mpi
  ;/**
  ; * Retrieve a MPI value from an integer ASN.1 tag.
  ; * Updates the pointer To immediately behind the full tag.
  ; *
  ; * \param p     The position in the ASN.1 Data
  ; * \param End   End of Data
  ; * \param X     The MPI that will receive the value
  ; *
  ; * \return      0 If successful Or a specific ASN.1 Or MPI error code.
  ; */
  asn1_get_mpi(*p, *End_, *X.mpi)
  CompilerEndIf
  
  ;- ctr_drbg_init
  ;/**
  ; * \brief               CTR_DRBG initialization
  ; * 
  ; * Note: Personalization Data can be provided in addition To the more generic
  ; *       entropy source To make this instantiation As unique As possible.
  ; *
  ; * \param ctx           CTR_DRBG context To be initialized
  ; * \param f_entropy     Entropy callback (p_entropy, buffer To fill, buffer
  ; *                      length)
  ; * \param p_entropy     Entropy context
  ; * \param custom        Personalization Data (Device specific identifiers)
  ; *                      (Can be NULL)
  ; * \param len           Length of personalization Data
  ; *
  ; * \return              0 If successful, Or
  ; *                      POLARSSL_ERR_CTR_DRBG_ENTROPY_SOURCE_FAILED
  ; */
  ctr_drbg_init(*ctx.ctr_drbg_context, *f_entropy.f_entropy, *p_entropy, *custom, len.i)
  
  ;- ctr_drbg_set_prediction_resistance
  ;/**
  ; * \brief               Enable / disable prediction resistance (Default: Off)
  ; *
  ; * Note: If enabled, entropy is used For ctx->entropy_len before each call!
  ; *       Only use this If you have ample supply of good entropy!
  ; *
  ; * \param ctx           CTR_DRBG context
  ; * \param resistance    CTR_DRBG_PR_ON Or CTR_DRBG_PR_OFF
  ; */
  ctr_drbg_set_prediction_resistance(*ctx.ctr_drbg_context, resistance.l)
  
  ;- ctr_drbg_set_entropy_len
  ;/**
  ; * \brief               Set the amount of entropy grabbed on each (re)seed
  ; *                      (Default: CTR_DRBG_ENTROPY_LEN)
  ; *
  ; * \param ctx           CTR_DRBG context
  ; * \param len           Amount of entropy To grab
  ; */
  ctr_drbg_set_entropy_len(*ctx.ctr_drbg_context, len.i)
  
  ;- ctr_drbg_set_reseed_interval
  ;/**
  ; * \brief               Set the reseed interval
  ; *                      (Default: CTR_DRBG_RESEED_INTERVAL)
  ; *
  ; * \param ctx           CTR_DRBG context
  ; * \param interval      Reseed interval
  ; */
  ctr_drbg_set_reseed_interval(*ctx.ctr_drbg_context, interval.l)
  
  ;- ctr_drbg_reseed
  ;/**
  ; * \brief               CTR_DRBG reseeding (extracts Data from entropy source)
  ; * 
  ; * \param ctx           CTR_DRBG context
  ; * \param additional    Additional Data To add To state (Can be NULL)
  ; * \param len           Length of additional Data
  ; *
  ; * \return              0 If successful, Or
  ; *                      POLARSSL_ERR_CTR_DRBG_ENTROPY_SOURCE_FAILED
  ; */
  ctr_drbg_reseed(*ctx.ctr_drbg_context, *additional, len.i)
  
  ;- ctr_drbg_update
  ;/**
  ; * \brief               CTR_DRBG update state
  ; *
  ; * \param ctx           CTR_DRBG context
  ; * \param additional    Additional Data To update state With
  ; * \param add_len       Length of additional Data
  ; */
  ctr_drbg_update(*ctx.ctr_drbg_context, *additional, add_len.i)
  
  ;- ctr_drbg_random_with_add
  ;/**
  ; * \brief               CTR_DRBG generate random With additional update input
  ; *
  ; * Note: Automatically reseeds If reseed_counter is reached.
  ; *
  ; * \param p_rng         CTR_DRBG context
  ; * \param output        Buffer To fill
  ; * \param output_len    Length of the buffer
  ; * \param additional    Additional Data To update With (Can be NULL)
  ; * \param add_len       Length of additional Data
  ; *
  ; * \return              0 If successful, Or
  ; *                      POLARSSL_ERR_CTR_DRBG_ENTROPY_SOURCE_FAILED, Or
  ; *                      POLARSSL_ERR_CTR_DRBG_REQUEST_TOO_BIG
  ; */
  ctr_drbg_random_with_add(*p_rng, *output, output_len.i, *additional, add_len.i)
  
  ;- ctr_drbg_random
  ;/**
  ; * \brief               CTR_DRBG generate random
  ; *
  ; * Note: Automatically reseeds If reseed_counter is reached.
  ; *
  ; * \param p_rng         CTR_DRBG context
  ; * \param output        Buffer To fill
  ; * \param output_len    Length of the buffer
  ; *
  ; * \return              0 If successful, Or
  ; *                      POLARSSL_ERR_CTR_DRBG_ENTROPY_SOURCE_FAILED, Or
  ; *                      POLARSSL_ERR_CTR_DRBG_REQUEST_TOO_BIG
  ; */
  ctr_drbg_random(*p_rng, *output, output_len.i)
  
  CompilerIf #POLARSSL_FS_IO
  ;- ctr_drbg_write_seed_file
  ;/**
  ; * \brief               Write a seed file
  ; *
  ; * \param path          Name of the file
  ; *
  ; * \return              0 If successful, 1 on file error, Or
  ; *                      POLARSSL_ERR_CTR_DRBG_ENTROPY_SOURCE_FAILED
  ; */
  ctr_drbg_write_seed_file(*ctx.ctr_drbg_context, *path)
  
  ;- ctr_drbg_update_seed_file
  ;/**
  ; * \brief               Read And update a seed file. Seed is added To this
  ; *                      instance
  ; *
  ; * \param path          Name of the file
  ; *
  ; * \return              0 If successful, 1 on file error,
  ; *                      POLARSSL_ERR_CTR_DRBG_ENTROPY_SOURCE_FAILED Or
  ; *                      POLARSSL_ERR_CTR_DRBG_INPUT_TOO_BIG
  ; */
  ctr_drbg_update_seed_file(*ctx.ctr_drbg_context, *path)
  CompilerEndIf
  
  ;- ctr_drbg_self_test
  ;/**
  ; * \brief               Checkup routine
  ; *
  ; * \return              0 If successful, Or 1 If the test failed
  ; */
  ctr_drbg_self_test(verbose.l)
  
  ;- dhm_read_params
  ;/**
  ; * \brief          Parse the ServerKeyExchange parameters
  ; *
  ; * \param ctx      DHM context
  ; * \param p        &(start of input buffer)
  ; * \param End      End of buffer
  ; *
  ; * \return         0 If successful, Or an POLARSSL_ERR_DHM_XXX error code
  ; */
  dhm_read_params(*ctx.dhm_context, *p, *End_)
  
  ;- dhm_make_params
  ;/**
  ; * \brief          Setup And write the ServerKeyExchange parameters
  ; *
  ; * \param ctx      DHM context
  ; * \param x_size   private value size in bytes
  ; * \param output   destination buffer
  ; * \param olen     number of chars written
  ; * \param f_rng    RNG function
  ; * \param p_rng    RNG parameter
  ; *
  ; * \note           This function assumes that ctx->P And ctx->G
  ; *                 have already been properly set (For example
  ; *                 using mpi_read_string Or mpi_read_binary).
  ; *
  ; * \return         0 If successful, Or an POLARSSL_ERR_DHM_XXX error code
  ; */
  dhm_make_params(*ctx.dhm_context, x_size.l, *output, *olen.Integer, *f_rng.f_rng, *p_rng)
  
  ;- dhm_read_public
  ;/**
  ; * \brief          Import the peer's public value G^Y
  ; *
  ; * \param ctx      DHM context
  ; * \param input    input buffer
  ; * \param ilen     size of buffer
  ; *
  ; * \return         0 If successful, Or an POLARSSL_ERR_DHM_XXX error code
  ; */
  dhm_read_public(*ctx.dhm_context, *input, ilen.i)
  
  ;- dhm_make_public
  ;/**
  ; * \brief          Create own private value X And export G^X
  ; *
  ; * \param ctx      DHM context
  ; * \param x_size   private value size in bytes
  ; * \param output   destination buffer
  ; * \param olen     must be equal To ctx->P.len
  ; * \param f_rng    RNG function
  ; * \param p_rng    RNG parameter
  ; *
  ; * \return         0 If successful, Or an POLARSSL_ERR_DHM_XXX error code
  ; */
  dhm_make_public(*ctx.dhm_context, x_size.l, *output, olen.i, *f_rng.f_rng, *p_rng)
  
  ;- dhm_calc_secret
  ;/**
  ; * \brief          Derive And export the Shared secret (G^Y)^X mod P
  ; *
  ; * \param ctx      DHM context
  ; * \param output   destination buffer
  ; * \param olen     number of chars written
  ; *
  ; * \return         0 If successful, Or an POLARSSL_ERR_DHM_XXX error code
  ; */
  dhm_calc_secret(*ctx.dhm_context, *output, *olen.Integer)
  
  ;- dhm_free
  ;/*
  ; * \brief          Free the components of a DHM key
  ; */
  dhm_free(*ctx.dhm_context)
  
  ;- dhm_self_test
  ;/**
  ; * \brief          Checkup routine
  ; *
  ; * \return         0 If successful, Or 1 If the test failed
  ; */
  dhm_self_test(verbose.l)
  
  ;- entropy_init
  ;/**
  ; * \brief           Initialize the context
  ; *
  ; * \param ctx       Entropy context To initialize
  ; */
  entropy_init(*ctx.entropy_context)
  
  ;- entropy_add_source
  ;/**
  ; * \brief           Adds an entropy source To poll
  ; *
  ; * \param ctx       Entropy context
  ; * \param f_source  Entropy function
  ; * \param p_source  Function Data
  ; * \param threshold Minimum required from source before entropy is released
  ; *                  ( With entropy_func() )
  ; *
  ; * \return          0 If successful Or POLARSSL_ERR_ENTROPY_MAX_SOURCES
  ; */
  entropy_add_source(*ctx.entropy_context, *f_source.f_source_ptr, *p_source, threshold.i)
  
  ;- entropy_gather
  ;/**
  ; * \brief           Trigger an extra gather poll For the accumulator
  ; *
  ; * \param ctx       Entropy context
  ; *
  ; * \return          0 If successful, Or POLARSSL_ERR_ENTROPY_SOURCE_FAILED
  ; */
  entropy_gather(*ctx.entropy_context)
  
  ;- entropy_func
  ;/**
  ; * \brief           Retrieve entropy from the accumulator (Max ENTROPY_BLOCK_SIZE)
  ; *
  ; * \param Data      Entropy context
  ; * \param output    Buffer To fill
  ; * \param len       Length of buffer
  ; *
  ; * \return          0 If successful, Or POLARSSL_ERR_ENTROPY_SOURCE_FAILED
  ; */
  entropy_func(*Data_, *output, len.i)
  
  ;- entropy_update_manual
  ;/**
  ; * \brief           Add Data To the accumulator manually
  ; * 
  ; * \param ctx       Entropy context
  ; * \param Data      Data To add
  ; * \param len       Length of Data
  ; *
  ; * \return          0 If successful
  ; */
  entropy_update_manual(*ctx.entropy_context, *Data_, len.i)
  
  ;- error_strerror
  ;/**
  ; * \brief Translate a PolarSSL error code into a string representation,
  ; *        Result is truncated If necessary And always includes a terminating
  ; *        null byte.
  ; *
  ; * \param errnum    error code
  ; * \param buffer    buffer To place representation in
  ; * \param buflen    length of the buffer
  ; */
  error_strerror(errnum.l, *buffer, buflen.i)
  
  ;- havege_init
  ;/**
  ; * \brief          HAVEGE initialization
  ; *
  ; * \param hs       HAVEGE state To be initialized
  ; */
  havege_init(*hs.havege_state)
  
  ;- havege_random
  ;/**
  ; * \brief          HAVEGE rand function
  ; *
  ; * \param p_rng    A HAVEGE state
  ; * \param output   Buffer To fill
  ; * \param len      Length of buffer
  ; *
  ; * \return         A random int
  ; */
  havege_random(*p_rng, *output, len.i)
  
  ;- mpi_init
  ;/**
  ; * \brief           Initialize one MPI
  ; *
  ; * \param X         One MPI To initialize.
  ; */
  mpi_init(*X.mpi)
  
  ;- mpi_free
  ;/**
  ; * \brief          Unallocate one MPI
  ; *
  ; * \param X        One MPI To unallocate.
  ; */
  mpi_free(*X.mpi)
  
  ;- mpi_grow
  ;/**
  ; * \brief          Enlarge To the specified number of limbs
  ; *
  ; * \param X        MPI To grow
  ; * \param nblimbs  The target number of limbs
  ; *
  ; * \return         0 If successful,
  ; *                 POLARSSL_ERR_MPI_MALLOC_FAILED If memory allocation failed
  ; */
  mpi_grow(*X.mpi, nblimbs.i)
  
  ;- mpi_copy
  ;/**
  ; * \brief          Copy the contents of Y into X
  ; *
  ; * \param X        Destination MPI
  ; * \param Y        Source MPI
  ; *
  ; * \return         0 If successful,
  ; *                 POLARSSL_ERR_MPI_MALLOC_FAILED If memory allocation failed
  ; */
  mpi_copy(*X.mpi, *Y.mpi)
  
  ;- mpi_swap
  ;/**
  ; * \brief          Swap the contents of X And Y
  ; *
  ; * \param X        First MPI value
  ; * \param Y        Second MPI value
  ; */
  mpi_swap(*X.mpi, *Y.mpi)
  
  ;- mpi_lset
  ;/**
  ; * \brief          Set value from integer
  ; *
  ; * \param X        MPI To set
  ; * \param z        Value To use
  ; *
  ; * \return         0 If successful,
  ; *                 POLARSSL_ERR_MPI_MALLOC_FAILED If memory allocation failed
  ; */
  mpi_lset(*X.mpi, z.t_sint)
  
  ;- mpi_get_bit
  ;/*
  ; * \brief          Get a specific bit from X
  ; *
  ; * \param X        MPI To use
  ; * \param pos      Zero-based index of the bit in X
  ; *
  ; * \return         Either a 0 Or a 1
  ; */
  mpi_get_bit(*X.mpi, pos.i)
  
  ;- mpi_set_bit
  ;/*
  ; * \brief          Set a bit of X To a specific value of 0 Or 1
  ; *
  ; * \note           Will grow X If necessary To set a bit To 1 in a Not yet
  ; *                 existing limb. Will Not grow If bit should be set To 0
  ; *
  ; * \param X        MPI To use
  ; * \param pos      Zero-based index of the bit in X
  ; * \param val      The value To set the bit To (0 Or 1)
  ; *
  ; * \return         0 If successful,
  ; *                 POLARSSL_ERR_MPI_MALLOC_FAILED If memory allocation failed,
  ; *                 POLARSSL_ERR_MPI_BAD_INPUT_DATA If val is Not 0 Or 1
  ; */
  mpi_set_bit(*X.mpi, pos.i, val.a)
  
  ;- mpi_lsb
  ;/**
  ; * \brief          Return the number of least significant bits
  ; *
  ; * \param X        MPI To use
  ; */
  mpi_lsb(*X.mpi)
  
  ;- mpi_msb
  ;/**
  ; * \brief          Return the number of most significant bits
  ; *
  ; * \param X        MPI To use
  ; */
  mpi_msb(*X.mpi)
  
  ;- mpi_size
  ;/**
  ; * \brief          Return the total size in bytes
  ; *
  ; * \param X        MPI To use
  ; */
  mpi_size(*X.mpi)
  
  ;- mpi_read_string
  ;/**
  ; * \brief          Import from an ASCII string
  ; *
  ; * \param X        Destination MPI
  ; * \param radix    Input numeric base
  ; * \param s        Null-terminated string buffer
  ; *
  ; * \return         0 If successful, Or a POLARSSL_ERR_MPI_XXX error code
  ; */
  mpi_read_string(*X.mpi, radix.l, *s)
  
  ;- mpi_write_string
  ;/**
  ; * \brief          Export into an ASCII string
  ; *
  ; * \param X        Source MPI
  ; * \param radix    Output numeric base
  ; * \param s        String buffer
  ; * \param slen     String buffer size
  ; *
  ; * \return         0 If successful, Or a POLARSSL_ERR_MPI_XXX error code.
  ; *                 *slen is always updated To reflect the amount
  ; *                 of Data that has (Or would have) been written.
  ; *
  ; * \note           Call this function With *slen = 0 To obtain the
  ; *                 minimum required buffer size in *slen.
  ; */
  mpi_write_string(*X.mpi, radix.l, *s, *slen.Integer)
  
  ;- mpi_read_file
  ;/**
  ; * \brief          Read X from an opened file
  ; *
  ; * \param X        Destination MPI
  ; * \param radix    Input numeric base
  ; * \param fin      Input file handle
  ; *
  ; * \return         0 If successful, POLARSSL_ERR_MPI_BUFFER_TOO_SMALL If
  ; *                 the file Read buffer is too small Or a
  ; *                 POLARSSL_ERR_MPI_XXX error code
  ; */
  mpi_read_file(*X.mpi, radix.l, *fin.Integer)
  
  ;- mpi_write_file
  ;/**
  ; * \brief          Write X into an opened file, Or stdout If fout is NULL
  ; *
  ; * \param p        Prefix, can be NULL
  ; * \param X        Source MPI
  ; * \param radix    Output numeric base
  ; * \param fout     Output file handle (can be NULL)
  ; *
  ; * \return         0 If successful, Or a POLARSSL_ERR_MPI_XXX error code
  ; *
  ; * \note           Set fout == NULL To print X on the console.
  ; */
  mpi_write_file(*p, *X.mpi, radix.l, *fout.Integer)
  
  ;- mpi_read_binary
  ;/**
  ; * \brief          Import X from unsigned binary Data, big endian
  ; *
  ; * \param X        Destination MPI
  ; * \param buf      Input buffer
  ; * \param buflen   Input buffer size
  ; *
  ; * \return         0 If successful,
  ; *                 POLARSSL_ERR_MPI_MALLOC_FAILED If memory allocation failed
  ; */
  mpi_read_binary(*X.mpi, *buf, buflen.i)
  
  ;- mpi_write_binary
  ;/**
  ; * \brief          Export X into unsigned binary Data, big endian
  ; *
  ; * \param X        Source MPI
  ; * \param buf      Output buffer
  ; * \param buflen   Output buffer size
  ; *
  ; * \return         0 If successful,
  ; *                 POLARSSL_ERR_MPI_BUFFER_TOO_SMALL If buf isn't large enough
  ; */
  mpi_write_binary(*X.mpi, *buf, buflen.i)
  
  ;- mpi_shift_l
  ;/**
  ; * \brief          Left-shift: X <<= count
  ; *
  ; * \param X        MPI To shift
  ; * \param count    Amount To shift
  ; *
  ; * \return         0 If successful,
  ; *                 POLARSSL_ERR_MPI_MALLOC_FAILED If memory allocation failed
  ; */
  mpi_shift_l(*X.mpi, count.i)
  
  ;- mpi_shift_r
  ;/**
  ; * \brief          Right-shift: X >>= count
  ; *
  ; * \param X        MPI To shift
  ; * \param count    Amount To shift
  ; *
  ; * \return         0 If successful,
  ; *                 POLARSSL_ERR_MPI_MALLOC_FAILED If memory allocation failed
  ; */
  mpi_shift_r(*X.mpi, count.i)
  
  ;- mpi_cmp_abs
  ;/**
  ; * \brief          Compare unsigned values
  ; *
  ; * \param X        Left-hand MPI
  ; * \param Y        Right-hand MPI
  ; *
  ; * \return         1 If |X| is greater than |Y|,
  ; *                -1 If |X| is lesser  than |Y| Or
  ; *                 0 If |X| is equal To |Y|
  ; */
  mpi_cmp_abs(*X.mpi, *Y.mpi)
  
  ;- mpi_cmp_mpi
  ;/**
  ; * \brief          Compare signed values
  ; *
  ; * \param X        Left-hand MPI
  ; * \param Y        Right-hand MPI
  ; *
  ; * \return         1 If X is greater than Y,
  ; *                -1 If X is lesser  than Y Or
  ; *                 0 If X is equal To Y
  ; */
  mpi_cmp_mpi(*X.mpi, *Y.mpi)
  
  ;- mpi_cmp_int
  ;/**
  ; * \brief          Compare signed values
  ; *
  ; * \param X        Left-hand MPI
  ; * \param z        The integer value To compare To
  ; *
  ; * \return         1 If X is greater than z,
  ; *                -1 If X is lesser  than z Or
  ; *                 0 If X is equal To z
  ; */
  mpi_cmp_int(*X.mpi, z.t_sint)
  
  ;- mpi_add_abs
  ;/**
  ; * \brief          Unsigned addition: X = |A| + |B|
  ; *
  ; * \param X        Destination MPI
  ; * \param A        Left-hand MPI
  ; * \param B        Right-hand MPI
  ; *
  ; * \return         0 If successful,
  ; *                 POLARSSL_ERR_MPI_MALLOC_FAILED If memory allocation failed
  ; */
  mpi_add_abs(*X.mpi, *A.mpi, *B.mpi)
  
  ;- mpi_sub_abs
  ;/**
  ; * \brief          Unsigned substraction: X = |A| - |B|
  ; *
  ; * \param X        Destination MPI
  ; * \param A        Left-hand MPI
  ; * \param B        Right-hand MPI
  ; *
  ; * \return         0 If successful,
  ; *                 POLARSSL_ERR_MPI_NEGATIVE_VALUE If B is greater than A
  ; */
  mpi_sub_abs(*X.mpi, *A.mpi, *B.mpi)
  
  ;- mpi_add_mpi
  ;/**
  ; * \brief          Signed addition: X = A + B
  ; *
  ; * \param X        Destination MPI
  ; * \param A        Left-hand MPI
  ; * \param B        Right-hand MPI
  ; *
  ; * \return         0 If successful,
  ; *                 POLARSSL_ERR_MPI_MALLOC_FAILED If memory allocation failed
  ; */
  mpi_add_mpi(*X.mpi, *A.mpi, *B.mpi)
  
  ;- mpi_sub_mpi
  ;/**
  ; * \brief          Signed substraction: X = A - B
  ; *
  ; * \param X        Destination MPI
  ; * \param A        Left-hand MPI
  ; * \param B        Right-hand MPI
  ; *
  ; * \return         0 If successful,
  ; *                 POLARSSL_ERR_MPI_MALLOC_FAILED If memory allocation failed
  ; */
  mpi_sub_mpi(*X.mpi, *A.mpi, *B.mpi)
  
  ;- mpi_add_int
  ;/**
  ; * \brief          Signed addition: X = A + b
  ; *
  ; * \param X        Destination MPI
  ; * \param A        Left-hand MPI
  ; * \param b        The integer value To add
  ; *
  ; * \return         0 If successful,
  ; *                 POLARSSL_ERR_MPI_MALLOC_FAILED If memory allocation failed
  ; */
  mpi_add_int(*X.mpi, *A.mpi, b.t_sint)
  
  ;- mpi_sub_int
  ;/**
  ; * \brief          Signed substraction: X = A - b
  ; *
  ; * \param X        Destination MPI
  ; * \param A        Left-hand MPI
  ; * \param b        The integer value To subtract
  ; *
  ; * \return         0 If successful,
  ; *                 POLARSSL_ERR_MPI_MALLOC_FAILED If memory allocation failed
  ; */
  mpi_sub_int(*X.mpi, *A.mpi, b.t_sint)
  
  ;- mpi_mul_mpi
  ;/**
  ; * \brief          Baseline multiplication: X = A * B
  ; *
  ; * \param X        Destination MPI
  ; * \param A        Left-hand MPI
  ; * \param B        Right-hand MPI
  ; *
  ; * \return         0 If successful,
  ; *                 POLARSSL_ERR_MPI_MALLOC_FAILED If memory allocation failed
  ; */
  mpi_mul_mpi(*X.mpi, *A.mpi, *B.mpi)
  
  ;- mpi_mul_int
  ;/**
  ; * \brief          Baseline multiplication: X = A * b
  ; *                 Note: b is an unsigned integer type, thus
  ; *                 Negative values of b are ignored.
  ; *
  ; * \param X        Destination MPI
  ; * \param A        Left-hand MPI
  ; * \param b        The integer value To multiply With
  ; *
  ; * \return         0 If successful,
  ; *                 POLARSSL_ERR_MPI_MALLOC_FAILED If memory allocation failed
  ; */
  mpi_mul_int(*X.mpi, *A.mpi, b.t_sint)
  
  ;- mpi_div_mpi
  ;/**
  ; * \brief          Division by mpi: A = Q * B + R
  ; *
  ; * \param Q        Destination MPI For the quotient
  ; * \param R        Destination MPI For the rest value
  ; * \param A        Left-hand MPI
  ; * \param B        Right-hand MPI
  ; *
  ; * \return         0 If successful,
  ; *                 POLARSSL_ERR_MPI_MALLOC_FAILED If memory allocation failed,
  ; *                 POLARSSL_ERR_MPI_DIVISION_BY_ZERO If B == 0
  ; *
  ; * \note           Either Q Or R can be NULL.
  ; */
  mpi_div_mpi(*Q.mpi, *R.mpi, *A.mpi, *B.mpi)
  
  ;- mpi_div_int
  ;/**
  ; * \brief          Division by int: A = Q * b + R
  ; *
  ; * \param Q        Destination MPI For the quotient
  ; * \param R        Destination MPI For the rest value
  ; * \param A        Left-hand MPI
  ; * \param b        Integer To divide by
  ; *
  ; * \return         0 If successful,
  ; *                 POLARSSL_ERR_MPI_MALLOC_FAILED If memory allocation failed,
  ; *                 POLARSSL_ERR_MPI_DIVISION_BY_ZERO If b == 0
  ; *
  ; * \note           Either Q Or R can be NULL.
  ; */
  mpi_div_int(*Q.mpi, *R.mpi, *A.mpi, b.t_sint)
  
  ;- mpi_mod_mpi
  ;/**
  ; * \brief          Modulo: R = A mod B
  ; *
  ; * \param R        Destination MPI For the rest value
  ; * \param A        Left-hand MPI
  ; * \param B        Right-hand MPI
  ; *
  ; * \return         0 If successful,
  ; *                 POLARSSL_ERR_MPI_MALLOC_FAILED If memory allocation failed,
  ; *                 POLARSSL_ERR_MPI_DIVISION_BY_ZERO If B == 0,
  ; *                 POLARSSL_ERR_MPI_NEGATIVE_VALUE If B < 0
  ; */
  mpi_mod_mpi(*R.mpi, *A.mpi, *B.mpi)
  
  ;- mpi_mod_int
  ;/**
  ; * \brief          Modulo: r = A mod b
  ; *
  ; * \param r        Destination t_uint
  ; * \param A        Left-hand MPI
  ; * \param b        Integer To divide by
  ; *
  ; * \return         0 If successful,
  ; *                 POLARSSL_ERR_MPI_MALLOC_FAILED If memory allocation failed,
  ; *                 POLARSSL_ERR_MPI_DIVISION_BY_ZERO If b == 0,
  ; *                 POLARSSL_ERR_MPI_NEGATIVE_VALUE If b < 0
  ; */
  mpi_mod_int(*r.Long, *A.mpi, b.t_sint)
  
  ;- mpi_exp_mod
  ;/**
  ; * \brief          Sliding-window exponentiation: X = A^E mod N
  ; *
  ; * \param X        Destination MPI 
  ; * \param A        Left-hand MPI
  ; * \param E        Exponent MPI
  ; * \param N        Modular MPI
  ; * \param _RR      Speed-up MPI used For recalculations
  ; *
  ; * \return         0 If successful,
  ; *                 POLARSSL_ERR_MPI_MALLOC_FAILED If memory allocation failed,
  ; *                 POLARSSL_ERR_MPI_BAD_INPUT_DATA If N is negative Or even
  ; *
  ; * \note           _RR is used To avoid re-computing R*R mod N across
  ; *                 multiple calls, which speeds up things a bit. It can
  ; *                 be set To NULL If the extra performance is unneeded.
  ; */
  mpi_exp_mod(*X.mpi, *A.mpi, *E.mpi, *N.mpi, *_RR.mpi)
  
  ;- mpi_fill_random
  ;/**
  ; * \brief          Fill an MPI X With size bytes of random
  ; *
  ; * \param X        Destination MPI
  ; * \param size     Size in bytes
  ; * \param f_rng    RNG function
  ; * \param p_rng    RNG parameter
  ; *
  ; * \return         0 If successful,
  ; *                 POLARSSL_ERR_MPI_MALLOC_FAILED If memory allocation failed
  ; */
  mpi_fill_random(*X.mpi, size.i, *f_rng.f_rng, *p_rng)
  
  ;- mpi_gcd
  ;/**
  ; * \brief          Greatest common divisor: G = gcd(A, B)
  ; *
  ; * \param G        Destination MPI
  ; * \param A        Left-hand MPI
  ; * \param B        Right-hand MPI
  ; *
  ; * \return         0 If successful,
  ; *                 POLARSSL_ERR_MPI_MALLOC_FAILED If memory allocation failed
  ; */
  mpi_gcd(*G.mpi, *A.mpi, *B.mpi)
  
  ;- mpi_inv_mod
  ;/**
  ; * \brief          Modular inverse: X = A^-1 mod N
  ; *
  ; * \param X        Destination MPI
  ; * \param A        Left-hand MPI
  ; * \param N        Right-hand MPI
  ; *
  ; * \return         0 If successful,
  ; *                 POLARSSL_ERR_MPI_MALLOC_FAILED If memory allocation failed,
  ; *                 POLARSSL_ERR_MPI_BAD_INPUT_DATA If N is negative Or nil
  ;                   POLARSSL_ERR_MPI_NOT_ACCEPTABLE If A has no inverse mod N
  ; */
  mpi_inv_mod(*X.mpi, *A.mpi, *N.mpi)
  
  ;- mpi_is_prime
  ;/**
  ; * \brief          Miller-Rabin primality test
  ; *
  ; * \param X        MPI To check
  ; * \param f_rng    RNG function
  ; * \param p_rng    RNG parameter
  ; *
  ; * \return         0 If successful (probably prime),
  ; *                 POLARSSL_ERR_MPI_MALLOC_FAILED If memory allocation failed,
  ; *                 POLARSSL_ERR_MPI_NOT_ACCEPTABLE If X is Not prime
  ; */
  mpi_is_prime(*X.mpi, *f_rng.f_rng, *p_rng)
  
  ;- mpi_gen_prime
  ;/**
  ; * \brief          Prime number generation
  ; *
  ; * \param X        Destination MPI
  ; * \param nbits    Required size of X in bits ( 3 <= nbits <= POLARSSL_MPI_MAX_BITS )
  ; * \param dh_flag  If 1, then (X-1)/2 will be prime too
  ; * \param f_rng    RNG function
  ; * \param p_rng    RNG parameter
  ; *
  ; * \return         0 If successful (probably prime),
  ; *                 POLARSSL_ERR_MPI_MALLOC_FAILED If memory allocation failed,
  ; *                 POLARSSL_ERR_MPI_BAD_INPUT_DATA If nbits is < 3
  ; */
  mpi_gen_prime(*X.mpi, nbits.i, dh_flag.l, *f_rng.f_rng, *p_rng)
  
  ;- mpi_self_test
  ;/**
  ; * \brief          Checkup routine
  ; *
  ; * \return         0 If successful, Or 1 If the test failed
  ; */
  mpi_self_test(verbose.l)
  
  ;- rsa_init
  ;/**
  ; * \brief          Initialize an RSA context
  ; *
  ; * \param ctx      RSA context To be initialized
  ; * \param padding  RSA_PKCS_V15 Or RSA_PKCS_V21
  ; * \param hash_id  RSA_PKCS_V21 hash identifier
  ; *
  ; * \note           The hash_id parameter is actually ignored
  ; *                 when using RSA_PKCS_V15 padding.
  ; */
  rsa_init(*ctx.rsa_context, padding.l, hash_id.l)
  
  ;- rsa_gen_key
  ;/**
  ; * \brief          Generate an RSA keypair
  ; *
  ; * \param ctx      RSA context that will hold the key
  ; * \param f_rng    RNG function
  ; * \param p_rng    RNG parameter
  ; * \param nbits    size of the public key in bits
  ; * \param exponent public exponent (e.g., 65537)
  ; *
  ; * \note           rsa_init() must be called beforehand To setup
  ; *                 the RSA context.
  ; *
  ; * \return         0 If successful, Or an POLARSSL_ERR_RSA_XXX error code
  ; */
  rsa_gen_key(*ctx.rsa_context, *f_rng.f_rng, *p_rng, nbits.l, exponent.l)
  
  ;- rsa_check_pubkey
  ;/**
  ; * \brief          Check a public RSA key
  ; *
  ; * \param ctx      RSA context To be checked
  ; *
  ; * \return         0 If successful, Or an POLARSSL_ERR_RSA_XXX error code
  ; */
  rsa_check_pubkey(*ctx.rsa_context)
  
  ;- rsa_check_privkey
  ;/**
  ; * \brief          Check a private RSA key
  ; *
  ; * \param ctx      RSA context To be checked
  ; *
  ; * \return         0 If successful, Or an POLARSSL_ERR_RSA_XXX error code
  ; */
  rsa_check_privkey(*ctx.rsa_context)
  
  ;- rsa_public
  ;/**
  ; * \brief          Do an RSA public key operation
  ; *
  ; * \param ctx      RSA context
  ; * \param input    input buffer
  ; * \param output   output buffer
  ; *
  ; * \return         0 If successful, Or an POLARSSL_ERR_RSA_XXX error code
  ; *
  ; * \note           This function does Not take care of message
  ; *                 padding. Also, be sure To set input[0] = 0 Or assure that
  ; *                 input is smaller than N.
  ; *
  ; * \note           The input And output buffers must be large
  ; *                 enough (eg. 128 bytes If RSA-1024 is used).
  ; */
  rsa_public(*ctx.rsa_context, *input, *output)
  
  ;- rsa_private
  ;/**
  ; * \brief          Do an RSA private key operation
  ; *
  ; * \param ctx      RSA context
  ; * \param input    input buffer
  ; * \param output   output buffer
  ; *
  ; * \return         0 If successful, Or an POLARSSL_ERR_RSA_XXX error code
  ; *
  ; * \note           The input And output buffers must be large
  ; *                 enough (eg. 128 bytes If RSA-1024 is used).
  ; */
  rsa_private(*ctx.rsa_context, *input, *output)
  
  ;- rsa_pkcs1_encrypt
  ;/**
  ; * \brief          Add the message padding, then do an RSA operation
  ; *
  ; * \param ctx      RSA context
  ; * \param f_rng    RNG function (Needed For padding And PKCS#1 v2.1 encoding)
  ; * \param p_rng    RNG parameter
  ; * \param mode     RSA_PUBLIC Or RSA_PRIVATE
  ; * \param ilen     contains the plaintext length
  ; * \param input    buffer holding the Data To be encrypted
  ; * \param output   buffer that will hold the ciphertext
  ; *
  ; * \return         0 If successful, Or an POLARSSL_ERR_RSA_XXX error code
  ; *
  ; * \note           The output buffer must be As large As the size
  ; *                 of ctx->N (eg. 128 bytes If RSA-1024 is used).
  ; */
  rsa_pkcs1_encrypt(*ctx.rsa_context, *f_rng.f_rng, *p_rng, mode.l, ilen.i, *input, *output)
  
  ;- rsa_pkcs1_decrypt
  ;/**
  ; * \brief          Do an RSA operation, then remove the message padding
  ; *
  ; * \param ctx      RSA context
  ; * \param mode     RSA_PUBLIC Or RSA_PRIVATE
  ; * \param olen     will contain the plaintext length
  ; * \param input    buffer holding the encrypted Data
  ; * \param output   buffer that will hold the plaintext
  ; * \param output_max_len    maximum length of the output buffer
  ; *
  ; * \return         0 If successful, Or an POLARSSL_ERR_RSA_XXX error code
  ; *
  ; * \note           The output buffer must be As large As the size
  ; *                 of ctx->N (eg. 128 bytes If RSA-1024 is used) otherwise
  ; *                 an error is thrown.
  ; */
  rsa_pkcs1_decrypt(*ctx.rsa_context, mode.l, *olen.integer, *input, *output, output_max_len.i)
  
  ;- rsa_pkcs1_sign
  ;/**
  ; * \brief          Do a private RSA To sign a message digest
  ; *
  ; * \param ctx      RSA context
  ; * \param f_rng    RNG function (Needed For PKCS#1 v2.1 encoding)
  ; * \param p_rng    RNG parameter
  ; * \param mode     RSA_PUBLIC Or RSA_PRIVATE
  ; * \param hash_id  SIG_RSA_RAW, SIG_RSA_MD{2,4,5} Or SIG_RSA_SHA{1,224,256,384,512}
  ; * \param hashlen  message digest length (For SIG_RSA_RAW only)
  ; * \param hash     buffer holding the message digest
  ; * \param sig      buffer that will hold the ciphertext
  ; *
  ; * \return         0 If the signing operation was successful,
  ; *                 Or an POLARSSL_ERR_RSA_XXX error code
  ; *
  ; * \note           The "sig" buffer must be As large As the size
  ; *                 of ctx->N (eg. 128 bytes If RSA-1024 is used).
  ; *
  ; * \note           In Case of PKCS#1 v2.1 encoding keep in mind that
  ; *                 the hash_id in the RSA context is the one used For the
  ; *                 encoding. hash_id in the function call is the type of hash
  ; *                 that is encoded. According To RFC 3447 it is advised To
  ; *                 keep both hashes the same.
  ; */
  rsa_pkcs1_sign(*ctx.rsa_context, *f_rng.f_rng, *p_rng, mode.l, hash_id.l, hashlen.l, *hash, *sig)
  
  ;- rsa_pkcs1_verify
  ;/**
  ; * \brief          Do a public RSA And check the message digest
  ; *
  ; * \param ctx      points To an RSA public key
  ; * \param mode     RSA_PUBLIC Or RSA_PRIVATE
  ; * \param hash_id  SIG_RSA_RAW, SIG_RSA_MD{2,4,5} Or SIG_RSA_SHA{1,224,256,384,512}
  ; * \param hashlen  message digest length (For SIG_RSA_RAW only)
  ; * \param hash     buffer holding the message digest
  ; * \param sig      buffer holding the ciphertext
  ; *
  ; * \return         0 If the verify operation was successful,
  ; *                 Or an POLARSSL_ERR_RSA_XXX error code
  ; *
  ; * \note           The "sig" buffer must be As large As the size
  ; *                 of ctx->N (eg. 128 bytes If RSA-1024 is used).
  ; *
  ; * \note           In Case of PKCS#1 v2.1 encoding keep in mind that
  ; *                 the hash_id in the RSA context is the one used For the
  ; *                 verification. hash_id in the function call is the type of hash
  ; *                 that is verified. According To RFC 3447 it is advised To
  ; *                 keep both hashes the same.
  ; */
  rsa_pkcs1_verify(*ctx.rsa_context, mode.l, hash_id.l, hashlen.l, *hash, *sig)
  
  ;- rsa_free
  ;/**
  ; * \brief          Free the components of an RSA key
  ; *
  ; * \param ctx      RSA Context To free
  ; */
  rsa_free(*ctx.rsa_context)
  
  ;- rsa_self_test
  ;/**
  ; * \brief          Checkup routine
  ; *
  ; * \return         0 If successful, Or 1 If the test failed
  ; */
  rsa_self_test(verbose.l)
  
  ;- sha2_starts
  ;/**
  ; * \brief          SHA-256 context setup
  ; *
  ; * \param ctx      context To be initialized
  ; * \param is224    0 = use SHA256, 1 = use SHA224
  ; */
  sha2_starts(*ctx.sha2_context, is224.l)
  
  ;- sha2_update
  ;/**
  ; * \brief          SHA-256 process buffer
  ; *
  ; * \param ctx      SHA-256 context
  ; * \param input    buffer holding the  Data
  ; * \param ilen     length of the input Data
  ; */
  sha2_update(*ctx.sha2_context, *input, ilen.i)
  
  ;- sha2_finish
  ;/**
  ; * \brief          SHA-256 final digest
  ; *
  ; * \param ctx      SHA-256 context
  ; * \param output   SHA-224/256 checksum result
  ; */
  sha2_finish(*ctx.sha2_context, *output)
  
  ;- sha2
  ;/**
  ; * \brief          Output = SHA-256( input buffer )
  ; *
  ; * \param input    buffer holding the  Data
  ; * \param ilen     length of the input Data
  ; * \param output   SHA-224/256 checksum result
  ; * \param is224    0 = use SHA256, 1 = use SHA224
  ; */
  sha2(*input, ilen.i, *output, is224.l)
  
  ;- sha2_file
  ;/**
  ; * \brief          Output = SHA-256( file contents )
  ; *
  ; * \param path     input file name
  ; * \param output   SHA-224/256 checksum result
  ; * \param is224    0 = use SHA256, 1 = use SHA224
  ; *
  ; * \return         0 If successful, Or POLARSSL_ERR_SHA2_FILE_IO_ERROR
  ; */
  sha2_file(*path, *output, is224.l)
  
  ;- sha2_hmac_starts
  ;/**
  ; * \brief          SHA-256 HMAC context setup
  ; *
  ; * \param ctx      HMAC context To be initialized
  ; * \param key      HMAC secret key
  ; * \param keylen   length of the HMAC key
  ; * \param is224    0 = use SHA256, 1 = use SHA224
  ; */
  sha2_hmac_starts(*ctx.sha2_context, *key, keylen.i, is224.l)
  
  ;- sha2_hmac_update
  ;/**
  ; * \brief          SHA-256 HMAC process buffer
  ; *
  ; * \param ctx      HMAC context
  ; * \param input    buffer holding the  Data
  ; * \param ilen     length of the input Data
  ; */
  sha2_hmac_update(*ctx.sha2_context, *input, ilen.i)
  
  ;- sha2_hmac_finish
  ;/**
  ; * \brief          SHA-256 HMAC final digest
  ; *
  ; * \param ctx      HMAC context
  ; * \param output   SHA-224/256 HMAC checksum result
  ; */
  sha2_hmac_finish(*ctx.sha2_context, *output)
  
  ;- sha2_hmac_reset
  ;/**
  ; * \brief          SHA-256 HMAC context reset
  ; *
  ; * \param ctx      HMAC context To be reset
  ; */
  sha2_hmac_reset(*ctx.sha2_context)
  
  ;- sha2_hmac
  ;/**
  ; * \brief          Output = HMAC-SHA-256( hmac key, input buffer )
  ; *
  ; * \param key      HMAC secret key
  ; * \param keylen   length of the HMAC key
  ; * \param input    buffer holding the  Data
  ; * \param ilen     length of the input Data
  ; * \param output   HMAC-SHA-224/256 result
  ; * \param is224    0 = use SHA256, 1 = use SHA224
  ; */
  sha2_hmac(*key, keylen.i, *input, ilen.i, *output, is224.l)
  
  ;- sha2_self_test
  ;/**
  ; * \brief          Checkup routine
  ; *
  ; * \return         0 If successful, Or 1 If the test failed
  ; */
  sha2_self_test(verbose.l)
  
  ;- sha4_starts
  ;/**
  ; * \brief          SHA-512 context setup
  ; *
  ; * \param ctx      context To be initialized
  ; * \param is384    0 = use SHA512, 1 = use SHA384
  ; */
  sha4_starts(*ctx.sha4_context, is384.l)
  
  ;- sha4_update
  ;/**
  ; * \brief          SHA-512 process buffer
  ; *
  ; * \param ctx      SHA-512 context
  ; * \param input    buffer holding the  Data
  ; * \param ilen     length of the input Data
  ; */
  sha4_update(*ctx.sha4_context, *input, ilen.i)
  
  ;- sha4_finish
  ;/**
  ; * \brief          SHA-512 final digest
  ; *
  ; * \param ctx      SHA-512 context
  ; * \param output   SHA-384/512 checksum result
  ; */
  sha4_finish(*ctx.sha4_context, *output)
  
  ;- sha4
  ;/**
  ; * \brief          Output = SHA-512( input buffer )
  ; *
  ; * \param input    buffer holding the  Data
  ; * \param ilen     length of the input Data
  ; * \param output   SHA-384/512 checksum result
  ; * \param is384    0 = use SHA512, 1 = use SHA384
  ; */
  sha4(*input, ilen.i, *output, is384.l)
  
  ;- sha4_file
  ;/**
  ; * \brief          Output = SHA-512( file contents )
  ; *
  ; * \param path     input file name
  ; * \param output   SHA-384/512 checksum result
  ; * \param is384    0 = use SHA512, 1 = use SHA384
  ; *
  ; * \return         0 If successful, Or POLARSSL_ERR_SHA4_FILE_IO_ERROR
  ; */
  sha4_file(*path, *output, is384.i)
  
  ;- sha4_hmac_starts
  ;/**
  ; * \brief          SHA-512 HMAC context setup
  ; *
  ; * \param ctx      HMAC context To be initialized
  ; * \param is384    0 = use SHA512, 1 = use SHA384
  ; * \param key      HMAC secret key
  ; * \param keylen   length of the HMAC key
  ; */
  sha4_hmac_starts(*ctx.sha4_context, *key, keylen.i, is384.l)
  
  ;- sha4_hmac_update
  ;/**
  ; * \brief          SHA-512 HMAC process buffer
  ; *
  ; * \param ctx      HMAC context
  ; * \param input    buffer holding the  Data
  ; * \param ilen     length of the input Data
  ; */
  sha4_hmac_update(*ctx.sha4_context, *input, ilen.i)
  
  ;- sha4_hmac_finish
  ;/**
  ; * \brief          SHA-512 HMAC final digest
  ; *
  ; * \param ctx      HMAC context
  ; * \param output   SHA-384/512 HMAC checksum result
  ; */
  sha4_hmac_finish(*ctx.sha4_context, *output)
  
  ;- sha4_hmac_reset
  ;/**
  ; * \brief          SHA-512 HMAC context reset
  ; *
  ; * \param ctx      HMAC context To be reset
  ; */
  sha4_hmac_reset(*ctx.sha4_context)
  
  ;- sha4_hmac
  ;/**
  ; * \brief          Output = HMAC-SHA-512( hmac key, input buffer )
  ; *
  ; * \param key      HMAC secret key
  ; * \param keylen   length of the HMAC key
  ; * \param input    buffer holding the  Data
  ; * \param ilen     length of the input Data
  ; * \param output   HMAC-SHA-384/512 result
  ; * \param is384    0 = use SHA512, 1 = use SHA384
  ; */
  sha4_hmac(*key, keylen.i, *input, ilen.i, *output, is384.i)
  
  ;- sha4_self_test
  ;/**
  ; * \brief          Checkup routine
  ; *
  ; * \return         0 If successful, Or 1 If the test failed
  ; */
  sha4_self_test(verbose.l)
  
  ;- version_get_number
  ;/**
  ; * Get the version number.
  ; *
  ; * \return          The constructed version number in the format
  ; *                  MMNNPP00 (Major, Minor, Patch).
  ; */
  version_get_number()
  
  ;- version_get_string
  ;/**
  ; * Get the version string ("x.y.z").
  ; *
  ; * \param string    The string that will receive the value.
  ; *                  (Should be at least 9 bytes in size)
  ; */
  version_get_string(*string.String)
  
  ;- version_get_string_full
  ;/**
  ; * Get the full version string ("PolarSSL x.y.z").
  ; *
  ; * \param string    The string that will receive the value.
  ; *                  (Should be at least 18 bytes in size)
  ; */
  version_get_string_full(*string.String)
  
  ;/**
  ; * \name Functions To Read in DHM parameters, a certificate, CRL Or private RSA key
  ; * \{
  ; */
  
  ;/** \ingroup x509_module */
  ;/**
  ;- x509parse_crt
  ; * \brief          Parse one Or more certificates And add them
  ; *                 To the chained List. Parses permissively. If some
  ; *                 certificates can be parsed, the result is the number
  ; *                 of failed certificates it encountered. If none complete
  ; *                 correctly, the first error is returned.
  ; *
  ; * \param chain    points To the start of the chain
  ; * \param buf      buffer holding the certificate Data
  ; * \param buflen   size of the buffer
  ; *
  ; * \return         0 If all certificates parsed successfully, a positive number
  ; *                 If partly successful Or a specific X509 Or PEM error code
  ; */
  x509parse_crt(*chain.x509_cert, *buf, buflen.i)
  
  ;/** \ingroup x509_module */
  ;/**
  ;- x509parse_crtfile
  ; * \brief          Load one Or more certificates And add them
  ; *                 To the chained List. Parses permissively. If some
  ; *                 certificates can be parsed, the result is the number
  ; *                 of failed certificates it encountered. If none complete
  ; *                 correctly, the first error is returned.
  ; *
  ; * \param chain    points To the start of the chain
  ; * \param path     filename To Read the certificates from
  ; *
  ; * \return         0 If all certificates parsed successfully, a positive number
  ; *                 If partly successful Or a specific X509 Or PEM error code
  ; */
  x509parse_crtfile(*chain.x509_cert, *path)
  
  ;/** \ingroup x509_module */
  ;/**
  ;- x509parse_crl
  ; * \brief          Parse one Or more CRLs And add them
  ; *                 To the chained List
  ; *
  ; * \param chain    points To the start of the chain
  ; * \param buf      buffer holding the CRL Data
  ; * \param buflen   size of the buffer
  ; *
  ; * \return         0 If successful, Or a specific X509 Or PEM error code
  ; */
  x509parse_crl(*chain.x509_crl, *buf, buflen.i)
  
  ;/** \ingroup x509_module */
  ;/**
  ;- x509parse_crlfile
  ; * \brief          Load one Or more CRLs And add them
  ; *                 To the chained List
  ; *
  ; * \param chain    points To the start of the chain
  ; * \param path     filename To Read the CRLs from
  ; *
  ; * \return         0 If successful, Or a specific X509 Or PEM error code
  ; */
  x509parse_crlfile(*chain.x509_crl, *path)
  
  ;/** \ingroup x509_module */
  ;/**
  ;- x509parse_key
  ; * \brief          Parse a private RSA key
  ; *
  ; * \param rsa      RSA context To be initialized
  ; * \param key      input buffer
  ; * \param keylen   size of the buffer
  ; * \param pwd      password For decryption (optional)
  ; * \param pwdlen   size of the password
  ; *
  ; * \return         0 If successful, Or a specific X509 Or PEM error code
  ; */
  x509parse_key(*rsa.rsa_context, *key, keylen.i, *pwd, pwdlen.i)
  
  ;/** \ingroup x509_module */
  ;/**
  ;- x509parse_keyfile
  ; * \brief          Load And parse a private RSA key
  ; *
  ; * \param rsa      RSA context To be initialized
  ; * \param path     filename To Read the private key from
  ; * \param password password To decrypt the file (can be NULL)
  ; *
  ; * \return         0 If successful, Or a specific X509 Or PEM error code
  ; */
  x509parse_keyfile(*rsa.rsa_context, *path, *password)
  
  ;/** \ingroup x509_module */
  ;/**
  ;- x509parse_public_key
  ; * \brief          Parse a public RSA key
  ; *
  ; * \param rsa      RSA context To be initialized
  ; * \param key      input buffer
  ; * \param keylen   size of the buffer
  ; *
  ; * \return         0 If successful, Or a specific X509 Or PEM error code
  ; */
  x509parse_public_key(*rsa.rsa_context, *key, keylen.i)
  
  ;/** \ingroup x509_module */
  ;/**
  ;- x509parse_public_keyfile
  ; * \brief          Load And parse a public RSA key
  ; *
  ; * \param rsa      RSA context To be initialized
  ; * \param path     filename To Read the private key from
  ; *
  ; * \return         0 If successful, Or a specific X509 Or PEM error code
  ; */
  x509parse_public_keyfile(*rsa.rsa_context, *path)
  
  ;/** \ingroup x509_module */
  ;/**
  ;- x509parse_dhm
  ; * \brief          Parse DHM parameters
  ; *
  ; * \param dhm      DHM context To be initialized
  ; * \param dhmin    input buffer
  ; * \param dhminlen size of the buffer
  ; *
  ; * \return         0 If successful, Or a specific X509 Or PEM error code
  ; */
  x509parse_dhm(*dhm.dhm_context, *dhmin, dhminlen.i)
  
  ;/** \ingroup x509_module */
  ;/**
  ;- x509parse_dhmfile
  ; * \brief          Load And parse DHM parameters
  ; *
  ; * \param dhm      DHM context To be initialized
  ; * \param path     filename To Read the DHM Parameters from
  ; *
  ; * \return         0 If successful, Or a specific X509 Or PEM error code
  ; */
  x509parse_dhmfile(*dhm.dhm_context, *path)
  
  ;/** \} name Functions To Read in DHM parameters, a certificate, CRL Or private RSA key */
  
  ;- x509parse_dn_gets
  ;/**
  ; * \brief          Store the certificate DN in printable form into buf;
  ; *                 no more than size characters will be written.
  ; *
  ; * \param buf      Buffer To write To
  ; * \param size     Maximum size of buffer
  ; * \param dn       The X509 name To represent
  ; *
  ; * \return         The amount of Data written To the buffer, Or -1 in
  ; *                 Case of an error.
  ; */
  x509parse_dn_gets(*buf, size.i, *dn.x509_name)
  
  ;- x509parse_serial_gets
  ;/**
  ; * \brief          Store the certificate serial in printable form into buf;
  ; *                 no more than size characters will be written.
  ; *
  ; * \param buf      Buffer To write To
  ; * \param size     Maximum size of buffer
  ; * \param serial   The X509 serial To represent
  ; *
  ; * \return         The amount of Data written To the buffer, Or -1 in
  ; *                 Case of an error.
  ; */
  x509parse_serial_gets(*buf, size.i, *serial.x509_buf)
  
  ;- x509parse_cert_info
  ;/**
  ; * \brief          Returns an informational string about the
  ; *                 certificate.
  ; *
  ; * \param buf      Buffer To write To
  ; * \param size     Maximum size of buffer
  ; * \param prefix   A line prefix
  ; * \param crt      The X509 certificate To represent
  ; *
  ; * \return         The amount of Data written To the buffer, Or -1 in
  ; *                 Case of an error.
  ; */
  x509parse_cert_info(*buf, size.i, *prefix, *crt.x509_cert)
  
  ;- x509parse_crl_info
  ;/**
  ; * \brief          Returns an informational string about the
  ; *                 CRL.
  ; *
  ; * \param buf      Buffer To write To
  ; * \param size     Maximum size of buffer
  ; * \param prefix   A line prefix
  ; * \param crl      The X509 CRL To represent
  ; *
  ; * \return         The amount of Data written To the buffer, Or -1 in
  ; *                 Case of an error.
  ; */
  x509parse_crl_info(*buf, size.i, *prefix, *crl.x509_crl)
  
  ;- x509_oid_get_description
  ;/**
  ; * \brief          Give an known OID, Return its descriptive string.
  ; *
  ; * \param oid      buffer containing the oid
  ; *
  ; * \return         Return a string If the OID is known,
  ; *                 Or NULL otherwise.
  ; */
  x509_oid_get_description(*oid.x509_buf)
  
  ;- x509_oid_get_numeric_string
  ;/*
  ; * \brief          Give an OID, Return a string version of its OID number.
  ; *
  ; * \param buf      Buffer To write To
  ; * \param size     Maximum size of buffer
  ; * \param oid      Buffer containing the OID
  ; *
  ; * \return         The amount of Data written To the buffer, Or -1 in
  ; *                 Case of an error.
  ; */
  x509_oid_get_numeric_string(*buf, size.i, *oid.x509_buf)
  
  ;- x509parse_time_expired
  ;/**
  ; * \brief          Check a given x509_time against the system time And check
  ; *                 If it is valid.
  ; *
  ; * \param time     x509_time To check
  ; *
  ; * \return         Return 0 If the x509_time is still valid,
  ; *                 Or 1 otherwise.
  ; */
  x509parse_time_expired(*time.x509_time)
  
  ;/**
  ; * \name Functions To verify a certificate
  ; * \{
  ; */
  ;/** \ingroup x509_module */
  ;/**
  
  ;- x509parse_verify
  ; * \brief          Verify the certificate signature
  ; *
  ; * \param crt      a certificate To be verified
  ; * \param trust_ca the trusted CA chain
  ; * \param ca_crl   the CRL chain For trusted CA's
  ; * \param cn       expected Common Name (can be set To
  ; *                 NULL If the CN must Not be verified)
  ; * \param flags    result of the verification
  ; * \param f_vrfy   verification function
  ; * \param p_vrfy   verification parameter
  ; *
  ; * \return         0 If successful Or POLARSSL_ERR_X509_SIG_VERIFY_FAILED,
  ; *                 in which Case *flags will have one Or more of
  ; *                 the following values set:
  ; *                      BADCERT_EXPIRED --
  ; *                      BADCERT_REVOKED --
  ; *                      BADCERT_CN_MISMATCH --
  ; *                      BADCERT_NOT_TRUSTED
  ; *
  ; * \note           TODO: add two arguments, depth And crl
  ; */
  x509parse_verify(*crt.x509_cert, *trust_ca.x509_cert, *ca_crl.x509_crl, *cn, *flags.Integer, *f_vrfy.f_vrfy, *p_vrfy)
  
  ;- x509parse_revoked
  ;/**
  ; * \brief          Verify the certificate signature
  ; *
  ; * \param crt      a certificate To be verified
  ; * \param crl      the CRL To verify against
  ; *
  ; * \return         1 If the certificate is revoked, 0 otherwise
  ; *
  ; */
  x509parse_revoked(*crt.x509_cert, *crl.x509_crl)
  
  ;/** \} name Functions To verify a certificate */
  
  ;/**
  ; * \name Functions To clear a certificate, CRL Or private RSA key 
  ; * \{
  ; */
  ;/** \ingroup x509_module */
  ;/**
  ;- x509_free
  ; * \brief          Unallocate all certificate Data
  ; *
  ; * \param crt      Certificate chain To free
  ; */
  x509_free(*crt.x509_cert)
  
  ;- x509_crl_free
  ;/** \ingroup x509_module */
  ;/**
  ; * \brief          Unallocate all CRL Data
  ; *
  ; * \param crl      CRL chain To free
  ; */
  x509_crl_free(*crl.x509_crl)
  
  ;/** \} name Functions To clear a certificate, CRL Or private RSA key */
  
  ;- x509_self_test
  ;/**
  ; * \brief          Checkup routine
  ; *
  ; * \return         0 If successful, Or 1 If the test failed
  ; */
  x509_self_test(verbose.l)
  
EndImport

; ########################################## Macros ###############################################

; ########################################## Other ################################################


; IDE Options = PureBasic 5.21 LTS Beta 1 (Windows - x64)
; CursorPosition = 1718
; FirstLine = 1662
; Folding = ---
; EnableXP