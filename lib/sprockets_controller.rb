class SprocketsController < ActionController::Base
  caches_page :show, :index
  
  def index
    render :text => SprocketsApplication.source, :content_type => "text/javascript"
  end
  
  def show id
    render :text => SprocketsApplication.source(id), :content_type => "text/javascript"
  end
end
