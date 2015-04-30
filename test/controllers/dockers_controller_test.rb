require 'test_helper'

class DockersControllerTest < ActionController::TestCase
  setup do
    @docker = dockers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:dockers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create docker" do
    assert_difference('Docker.count') do
      post :create, docker: { name: @docker.name }
    end

    assert_redirected_to docker_path(assigns(:docker))
  end

  test "should show docker" do
    get :show, id: @docker
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @docker
    assert_response :success
  end

  test "should update docker" do
    patch :update, id: @docker, docker: { name: @docker.name }
    assert_redirected_to docker_path(assigns(:docker))
  end

  test "should destroy docker" do
    assert_difference('Docker.count', -1) do
      delete :destroy, id: @docker
    end

    assert_redirected_to dockers_path
  end
end
