class PhotoUploadController < ApplicationController
  def index
  end

  def sign
    photo_request = PhotoRequest.new('demo', params[:filename])
    render :json => JSON.generate(
      "url" => photo_request.url.to_s,
      "fields" => photo_request.form_fields
    )
  end
end
