require 'sinatra'
require 'json'
require 'aws'

configure do
  aws_config = AWS.config.with(
    access_key_id:     ENV['PHOTOS_AWS_ACCESS_KEY_ID'],
    secret_access_key: ENV['PHOTOS_AWS_SECRET_ACCESS_KEY'],
  )
  set :aws_bucket, AWS::S3::Bucket.new(ENV['PHOTOS_BUCKET_NAME'], :config => aws_config)
end

get '/' do
  erb :index
end

get '/sign' do
  if params[:username] && params[:filename]
    key = "#{params[:username]}/#{params[:filename]}"
    presigned_post = AWS::S3::PresignedPost.new(
      settings.aws_bucket,
      :key => key,
      :secure => production?,
      :content_type => "image/jpeg",
      :content_length => 1..(3 * 1024 * 1024),
      :acl => "public-read"
    )
    Rack::Response.new(
      JSON.generate("url" => presigned_post.url,
                    "fields" => presigned_post.fields),
      200,
      { "Content-Type" => "application/json" }
    ).finish
  else
    400 # Bad Request
  end
end
