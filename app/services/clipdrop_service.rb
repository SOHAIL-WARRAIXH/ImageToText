require "net/http"
require "uri"
require "json"

class ClipdropService
  API_KEY = "d57fca9e8342fc9a592f0fd19f1f196ea13fb00ca887a7d3a23edcca7dcdec177e880b840d4b82ce70bd355566f5c327"
  API_URL = "https://clipdrop-api.co/text-to-image/v1"

  def self.generate_image(prompt)
    uri = URI(API_URL)

    request = Net::HTTP::Post.new(uri)
    request["x-api-key"] = API_KEY
    request["Content-Type"] = "application/json"

    # Only send the prompt parameter as required by ClipDrop API
    request.body = {
      prompt: prompt
    }.to_json

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    response = http.request(request)

    if response.code == "200"
      # Save the image to a file and return the path
      filename = "image_#{Time.current.to_i}.png"
      filepath = Rails.root.join("public", "generated_images", filename)

      # Ensure directory exists
      FileUtils.mkdir_p(File.dirname(filepath))

      File.open(filepath, "wb") do |file|
        file.write(response.body)
      end

      "/generated_images/#{filename}"
    else
      Rails.logger.error "ClipDrop API error: #{response.code} - #{response.body}"
      nil
    end
  rescue => e
    Rails.logger.error "ClipDrop API exception: #{e.message}"
    nil
  end
end
