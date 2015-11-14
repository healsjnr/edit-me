class DocumentsController < ApplicationController
  include ApplicationHelper
  protect_from_forgery with: :exception
  before_action :authenticate_user!

  def index
    current_user_id = current_user.id
    logger.debug "current user: #{current_user_id}"
    # Todo Need to permit pararms
    @documents = Document.get_documents_for_user(current_user_id, params.slice(:title, :status, :original_file_name))

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @documents}
      format.json  { render :json => @documents.to_json }
    end
  end

  def create
    user_id = params[:owner_id].to_s
    logger.info("UserId: #{user_id} Current User: #{current_user.id.to_s}")
    logger.debug "request: #{request.raw_post}"
    current_user_valid(current_user, user_id) do
      logger.debug "Valid user."
      @doc = Document.new(doc_params(params))
      if @doc.save
        render json: @doc
      else
        render json: @doc.errors, status: :unprocessable_entity
      end
    end
  end

  private
  def doc_params(supplied_params)
    supplied_params.require(:document).permit(:title, :original_file_name, :status, :owner_id)
  end

end
