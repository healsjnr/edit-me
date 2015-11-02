class DocumentsController < ApplicationController
  def index

    # TODO should update this to use common code such as:
    # http://www.justinweiss.com/articles/search-and-filter-rails-models-without-bloating-your-controller/
    #@documents = Document.filter(params.slice(:status, :user_id))
    @documents = Document.where(nil) # creates an anonymous scope
    @documents = @documents.status(params[:status]) if params[:status].present?
    @documents = @documents.owner_id(params[:owner_id]) if params[:owner_id].present?

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @documents}
      format.json  { render :json => @documents.to_json }
    end
  end

end
