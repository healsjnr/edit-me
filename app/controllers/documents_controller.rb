class DocumentsController < ApplicationController
  def index
    @documents = Document.filter(params.slice(:status, :owner_id))

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @documents}
      format.json  { render :json => @documents.to_json }
    end
  end

  def create
    logger.debug "request: #{request.raw_post}"
    @doc = Document.new(doc_params(params))
    if @doc.save
      render json: @doc
    else
      render json: @doc.errors, status: :unprocessable_entity
    end
  end

  private
  def doc_params(supplied_params)
    supplied_params.require(:document).permit(:title, :original_file_name, :status, :owner_id)
  end

end
