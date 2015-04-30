class ContainersController < ApplicationController
  before_action :set_container, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @containers = Container.all
    respond_with(@containers)
  end

  def show
    respond_with(@container)
  end

  def new
    @container = Container.new
    respond_with(@container)
  end

  def edit
  end

  def create
    @container = Container.new(container_params)
    @container.save
    @container.run
    redirect_to containers_path
  end

  def update
    @container.update(container_params)
    respond_with(@container)
  end

  def destroy
    @container.rm
    @container.delete
    # @container.destroy
    respond_with(@container)
  end

  private
    def set_container
      @container = Container.find(params[:id])
    end

    def container_params
      params.require(:container).permit(:name, :uuid, :tag_id,:command,:env,:link,:docker_id)
    end
end
