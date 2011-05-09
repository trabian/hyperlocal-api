require 'test_helper'

class MembersControllerTest < ActionController::TestCase
  setup do
    @member = members(:one)
  end

  test "should return a list of members as json" do
    get :index, :format => :json
    assert_response :success
  end

  test "should show member as json" do
    get :show, :id => @member.to_param, :format => :json
    assert_response :success
  end

  test "should allow updates to a member" do

    put :update, :id => @member.to_param, :member => @member.attributes, :format => :json

    assert_response :success

  end

  test "should not allow direct creation of a member" do
    assert_raise(AbstractController::ActionNotFound) do
      post :create, :member => @member.attributes, :format => :json
    end
  end

end
