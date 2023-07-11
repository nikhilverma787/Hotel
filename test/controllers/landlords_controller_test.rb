require "test_helper"

class LandlordsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get landlords_create_url
    assert_response :success
  end

  test "should get login" do
    get landlords_login_url
    assert_response :success
  end
end
