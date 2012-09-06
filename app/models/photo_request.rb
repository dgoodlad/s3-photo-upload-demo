require 'aws'

class PhotoRequest
  def self.configure(config)
    @config = config
  end

  def self.aws_config
    AWS.config.with(
      access_key_id:     @config[:access_key_id],
      secret_access_key: @config[:secret_access_key]
    )
  end

  def self.bucket
    AWS::S3::Bucket.new(@config[:bucket_name], :config => aws_config)
  end

  def initialize(username, filename)
    raise ArgumentError unless username.present?
    raise ArgumentError unless filename.present?
    @username = username
    @filename = filename
  end

  def bucket
    self.class.bucket
  end

  def key
    "#{@username}/#{@filename}"
  end

  def presigned_post
    AWS::S3::PresignedPost.new(
      bucket,
      :key => key,
      :secure => Rails.production?,
      :content_type => "image/jpeg",
      :acl => "public-read"
    )
  end

  def form_fields
    presigned_post.fields
  end

  def url
    presigned_post.url
  end

end
