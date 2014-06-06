require 'test_helper'

class OutfitControllerTest < ActionController::TestCase
  test "should get formal" do
    get :formal
    assert_response :success
  end

  test "should get smart_casual" do
    get :smart_casual
    assert_response :success
  end

  test "should get beach" do
    get :beach
    assert_response :success
  end

end
