require "test_helper"

class ChatControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get chat_index_url
    assert_response :success
  end

  test "should get show" do
    get chat_show_url
    assert_response :success
  end

  test "should get create_message" do
    get chat_create_message_url
    assert_response :success
  end
end
