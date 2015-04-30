class DockersController < ApplicationController
  before_action :set_docker, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @dockers = Docker.all
    respond_with(@dockers)
  end

  def show
    respond_with(@docker)
  end

  def new
    @docker = Docker.new
    respond_with(@docker)
  end

  def edit
  end

  def create
    @docker = Docker.new(docker_params)
    @docker.save
    @docker.sync
    redirect_to dockers_path
  end

  def update
    @docker.update(docker_params)
    respond_with(@docker)
  end

  def destroy
    @docker.destroy
    respond_with(@docker)
  end

  def clear
    @docker = Docker.find(params[:id])
    @docker.clear
    redirect_to dockers_path
  end

  def sync
    @docker = Docker.find(params[:id])
    @docker.sync
    redirect_to dockers_path
  end

  private
    def set_docker
      @docker = Docker.find(params[:id])
    end

    def docker_params
      params.require(:docker).permit(:name)
    end
end
