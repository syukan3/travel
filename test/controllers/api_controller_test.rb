require 'test_helper'

class ApiControllerTest < ActionDispatch::IntegrationTest
  test "should get set_spot" do
    get api_set_spot_url
    assert_response :success
  end

end
