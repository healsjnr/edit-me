class DocumentsController < ApplicationController
  def index

    @documents = Document.filter(params.slice(:status, :owner_id))

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @documents}
      format.json  { render :json => @documents.to_json }
    end
  end

end
