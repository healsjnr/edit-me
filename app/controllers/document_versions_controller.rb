class DocumentVersionsController < ApplicationController
  include ApplicationHelper
  protect_from_forgery with: :exception
  before_action :authenticate_user!

  def index
    # Todo Need to permit pararms
    @document_versions = DocumentVersion.get_doc_versions(current_user, allowed_get_params(params))

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @document_versions}
      format.json  { render :json => @document_versions.to_json }
    end
  end

  def create
    #TODO need to allow creation when user is part of the collaborators
    user_id = params[:uploader_id].to_s
    logger.info("UserId: #{user_id} Current User: #{current_user.id.to_s}")
    logger.debug "request: #{request.raw_post}"
    current_user_valid(current_user, user_id) do
      @doc_version = DocumentVersion.create_document(doc_version_params(params))
      if @doc_version.save
        render json: @doc_version
      else
        render json: @doc_version.errors, status: :unprocessable_entity
      end
    end
  end

  private

  def allowed_get_params(params)
    params.slice(:document_id, :uploader_id, :uploader_account_type, :version)
  end

  def doc_version_params(supplied_params)
    supplied_params.require(:document_version).permit(
        :uploader_id,
        :uploader_account_type,
        :document_id,
        :s3_link
    )
  end
end
