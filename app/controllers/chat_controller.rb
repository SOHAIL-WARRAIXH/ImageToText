class ChatController < ApplicationController
  def index
    @conversations = Conversation.order(updated_at: :desc)
  end

  def show
    @conversation = Conversation.find(params[:id])
    @messages = @conversation.messages.ordered
  end

  def create_message
    @conversation = Conversation.find(params[:conversation_id])
    user_message = @conversation.messages.create!(
      content: params[:content],
      role: "user"
    )

    # Generate image using ClipDrop API
    image_url = ClipdropService.generate_image(params[:content])

    # Create assistant response
    assistant_content = if image_url
      "I've generated an image based on your prompt: '#{params[:content]}'. Here it is!"
    else
      "I'm sorry, I couldn't generate an image for your prompt. Please try again with a different description."
    end

    @conversation.messages.create!(
      content: assistant_content,
      role: "assistant",
      image_url: image_url
    )

    @conversation.update!(updated_at: Time.current)

    redirect_to chat_show_path(@conversation)
  end

  def new_conversation
    @conversation = Conversation.create!(title: "New Conversation #{Time.current.strftime('%Y-%m-%d %H:%M')}")
    redirect_to chat_show_path(@conversation)
  end

  def update_conversation
    @conversation = Conversation.find(params[:id])
    if @conversation.update(title: params[:title])
      render json: { success: true, title: @conversation.title }
    else
      render json: { success: false, errors: @conversation.errors.full_messages }
    end
  end

  def delete_conversation
    @conversation = Conversation.find(params[:id])
    @conversation.destroy
    redirect_to chat_index_path, notice: "Conversation deleted successfully."
  end

  def download_image
    image_path = params[:image_path]

    # Security: Validate that the path is within the generated_images directory
    return redirect_back(fallback_location: chat_index_path, alert: "Invalid image path.") unless image_path&.start_with?("/generated_images/")

    # Security: Extract only the filename from the path to prevent path traversal
    filename = File.basename(image_path)

    # Security: Validate filename format (should be image_*.png)
    return redirect_back(fallback_location: chat_index_path, alert: "Invalid image path.") unless filename.match?(/\Aimage_\d+\.png\z/)

    # Security: Construct the path safely using only the validated filename
    full_path = Rails.root.join("public", "generated_images", filename)

    if File.exist?(full_path) && File.file?(full_path)
      send_file full_path, disposition: "attachment", filename: filename
    else
      redirect_back(fallback_location: chat_index_path, alert: "Image not found.")
    end
  end
end
