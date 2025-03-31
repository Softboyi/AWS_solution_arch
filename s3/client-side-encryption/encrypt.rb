require 'aws-sdk-s3'
require 'openssl'

# Generate a new RSA key pair
rsa_key = OpenSSL::PKey::RSA.new(2048)

# Initialize the S3 encryption client
s3_encryption_client = Aws::S3::EncryptionV2::Client.new(
  encryption_key: rsa_key,
  key_wrap_schema: :rsa_oaep_sha1, # Required for asymmetric keys
  content_encryption_schema: :aes_gcm_no_padding,
  security_profile: :v2 # Use :v2_and_legacy to allow decrypting objects encrypted by the V1 client
)


# Define the bucket and object key
bucket_name = 'chima-s3-bucket-v1'
object_key = 'hello.txt'

# The content you want to encrypt and upload
content = "Hello World! Learning Cloud is fun"

# Upload the encrypted object
s3_encryption_client.put_object(
  bucket: bucket_name,
  key: object_key,
  body: content
)


# Download the encrypted object and decrypt it
response = s3_encryption_client.get_object(
  bucket: bucket_name,
  key: object_key
)

# Read and print the decrypted content
decrypted_content = response.body.read
puts decrypted_content
