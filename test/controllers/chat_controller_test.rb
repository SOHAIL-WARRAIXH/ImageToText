require "test_helper"

class ChatControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get chat_index_url
    assert_response :success
  end

  test "should get show" do
    # Create a conversation first
    conversation = Conversation.create!(title: "Test Conversation")
    get chat_show_url(conversation)
    assert_response :success
  end

  test "should post create_message" do
    # Create a conversation first
    conversation = Conversation.create!(title: "Test Conversation")
    post create_message_url(conversation), params: { content: "Test message" }
    assert_response :redirect
  end
end
