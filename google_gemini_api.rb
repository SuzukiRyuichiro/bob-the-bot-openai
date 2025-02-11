# frozen_string_literal: true

require 'uri'
require 'json'
require 'httparty'

def get_response_from_gemini(message)
  url = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=#{ENV['GOOGLE_GEMINI_API_TOKEN']}"

  body = {
    contents: [{ parts: [{ text: message }] }]
  }.to_json

  response = HTTParty.post(url, body: body, headers: { 'Content-Type' => 'application/json' })

  p JSON.parse(response.body, { symbolize_names: true })

  bot_message = JSON.parse(response.body, { symbolize_names: true }).dig(:candidates, 0, :content, :parts, 0, :text)

  bot_message.nil? ? "Huh, the bot couldn't process your message" : bot_message
end
