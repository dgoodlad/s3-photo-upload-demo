PhotoRequest.configure(
  access_key_id:     ENV['PHOTOS_AWS_ACCESS_KEY_ID'],
  secret_access_key: ENV['PHOTOS_AWS_SECRET_ACCESS_KEY'],
  bucket_name:       ENV['PHOTOS_BUCKET_NAME']
)
