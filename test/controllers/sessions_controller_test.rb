require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest

  setup do
    @session = sessions(:heiligenhafen)
    @spot = spots(:heiligenhafen)
  end

  test "should get index" do
    get sessions_url
    assert_response :success
  end

  test "should get new" do
    login_as(users(:ralf))

    get new_session_url
    assert_response :success
  end

  test "should create session" do
    login_as(users(:ralf))

    assert_difference("Session.count") do
      post sessions_url, params: { session: { sport: @session.sport, spot_id: @spot.id, when: 5.days.from_now } }
    end

    assert_redirected_to sessions_url
  end

  test "should show session" do
    get session_url(@session)
    assert_response :success
  end

  test "should get edit" do
    login_as(users(:ralf))

    get edit_session_url(@session)
    assert_response :success
  end

  test "should update session" do
    login_as(users(:ralf))

    patch session_url(@session), params: { session: {
      sport: @session.sport,
      spot_id: @spot.id,
      when: 5.days.from_now,
      user_id: users(:ralf).id,
      duration: 1.0,
      distance: 1.0,
      maxspeed: 1.0,
      visibility: "public" }
    }
    assert_redirected_to session_url(@session)
  end

  test "should destroy session" do
    login_as(users(:ralf))

    assert_difference("Session.count", -1) do
      delete session_url(@session)
    end

    assert_redirected_to sessions_url
  end
end
