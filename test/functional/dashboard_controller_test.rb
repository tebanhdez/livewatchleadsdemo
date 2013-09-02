require 'test_helper'

class DashboardControllerTest < ActionController::TestCase
  test "should get show_live_watch_leads" do
    get :show_live_watch_leads
    assert_response :success
  end

  test "should get refresh_livewatch_leads" do
    get :refresh_livewatch_leads
    assert_response :success
  end

end
