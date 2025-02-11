# frozen_string_literal: true

require 'uri'
require 'json'
require 'httparty'

def get_response_from_gemini(message)
  fetch_response(build_url, build_body(message))
end

def build_url
  "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=#{ENV['GOOGLE_GEMINI_API_TOKEN']}"
end

def build_body(message)
  {
    contents: [{ "role": 'user', parts: [{ text: message }] }],
    generationConfig: {
      temperature: 1,
      topK: 40,
      topP: 0.95,
      maxOutputTokens: 8192,
      responseMimeType: 'text/plain'
    }
  }.to_json
end

def fetch_response(url, body)
  response = HTTParty.post(url, body: body, headers: { 'Content-Type' => 'application/json' })
  parsed_response = JSON.parse(response.body, { symbolize_names: true })
  p parsed_response
  bot_message = parsed_response.dig(:candidates, 0, :content, :parts, 0, :text)
  bot_message.nil? ? "Huh, the bot couldn't process your message" : bot_message
end
