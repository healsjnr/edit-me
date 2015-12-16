require 'aws-sdk-resources'
class S3Controller < ApplicationController
  include ApplicationHelper
  protect_from_forgery with: :exception
  before_action :authenticate_user!

  S3_BUCKET = 'edit-me.s3.amazonaws.com'
  def upload
    options = {path_style: true}
    headers = {
        'Content-Type' => params[:contentType],
        'x-amz-acl' => 'public-read'
    }

    @url = FOG_CONNECTION.put_object_url('edit-me', "dev/uploads/#{params[:objectName]}", 15.minutes.from_now.to_time.to_i, headers, options)
    respond_to do |format|
      format.json { render json: {signedUrl: @url} }
    end
  end
end
