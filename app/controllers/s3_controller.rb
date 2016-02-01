require 'aws-sdk-resources'
class S3Controller < ApplicationController
  include ApplicationHelper
  protect_from_forgery with: :exception
  before_action :authenticate_user!

  S3_BUCKET = Rails.configuration.x.s3['bucket']
  S3_FOLDER = Rails.configuration.x.s3['folder']


  def upload
    options = {path_style: true}
    headers = {
        'Content-Type' => params[:contentType],
        'x-amz-acl' => 'public-read'
    }
    upload_path = "#{S3_FOLDER}/#{params[:objectName]}"

    logger.debug "Creating upload URL to s3 with path: #{upload_path}"

    @url = FOG_CONNECTION.put_object_url(S3_BUCKET, upload_path, 15.minutes.from_now.to_time.to_i, headers, options)
    respond_to do |format|
      format.json { render json: {signedUrl: @url} }
    end
  end
end
