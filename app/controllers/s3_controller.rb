require 'aws-sdk-resources'
class S3Controller < ApplicationController
  include ApplicationHelper
  protect_from_forgery with: :exception
  before_action :authenticate_user!

  S3_BUCKET = 'edit-me.s3.amazonaws.com'
  #URL:
  # https://s3.amazonaws.com/edit-me.s3.amazonaws.com/dev/uploads/DSC_4022.jpg?
  #   X-Amz-Expires=900&
  #   X-Amz-Date=20151128T012707Z&
  #   X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAIY5VNFX6OXWMQINA/20151128/us-east-1/s3/aws4_request&
  #   X-Amz-SignedHeaders=access-control-allow-origin%3B
  #     content-type%3B
  #     host%3B
  #     x-amz-acl&
  #   X-Amz-Signature=be015f9bbf98e52a957d557617526a69f25992b4f690a5e4393edade3072cd2a

  def upload_
    Aws.config.update({
      region: 'ap-southeast-2',
      credentials: Aws::Credentials.new('AKIAIY5VNFX6OXWMQINA', 'l3xdzy1DOTy2PVAINmDDh+5UPbpRANsU/kUFJCQ2')})
    s3 = Aws::S3::Resource.new(region:'ap-southeast-2')
    obj = s3.bucket('edit-me').object("dev/uploads/#{params[:objectName]}")
    @url = obj.presigned_url(:put)
    puts "AWS-sdk URL: #{@url}"

    respond_to do |format|
      format.json { render json: {signedUrl: @url} }
    end
  end
  def upload
    options = {path_style: true}
    headers = {
        'Content-Type' => params[:contentType],
        'x-amz-acl' => 'public-read'
    }

    @url = FOG_CONNECTION.put_object_url('edit-me', "dev/uploads/#{params[:objectName]}", 15.minutes.from_now.to_time.to_i, headers, options)
    puts "URL: #{@url}"

    respond_to do |format|
      format.json { render json: {signedUrl: @url} }
    end
  end
end
