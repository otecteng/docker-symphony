class TagsController< ApplicationController
  skip_before_filter :verify_authenticity_token

  def index
    @tags = Tag.all
  end

  def new
    @tag = Tag.new
  end

  def create
    @tag = Tag.create(:name=>params[:tag][:name])
    @tag.create_image(params[:from],params[:docker_file])
    # File.new("Docoker"). write()
  end

  def sync
    Tag.sync
    render :json=>{:status=>200}
  end

  def create_container
    @tag = Tag.find(params[:id])
    @tag.create_container
    redirect_to '/containers'
  end
end