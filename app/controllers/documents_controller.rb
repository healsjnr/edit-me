class DocumentsController < ApplicationController
  include ApplicationHelper
  protect_from_forgery with: :exception
  before_action :authenticate_user!

  def index
    current_user_id = current_user.id
    logger.debug "Current user: #{current_user_id}"
    @documents = Document.get_documents_for_user(current_user_id, allowed_get_params(params))

    respond_to do |format|
      format.html
      format.xml  { render :xml => @documents}
      format.json  { render :json => @documents.to_json }
    end
  end

  def create
    user_id = params[:owner_id].to_s
    logger.debug "Create request: #{request.raw_post}"
    current_user_valid(current_user, user_id) do
      @doc = Document.new(doc_params(params))

      # Set the doc source as Owner as this user has created this doc
      @doc.source = 'owner'
      if @doc.save
        render json: @doc
      else
        render json: @doc.errors, status: :unprocessable_entity
      end
    end
  end

  private

  def allowed_get_params(params)
    params.slice(:title, :status, :original_file_name)
  end

  def doc_params(supplied_params)
    supplied_params.require(:document).permit(:title, :original_file_name, :status, :owner_id)
  end

end
