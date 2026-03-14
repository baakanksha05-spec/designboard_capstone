require "ai-chat"
require "json"

class MoodboardsController < ApplicationController
  def new
    @moodboard = Moodboard.new

    render({ :template => "moodboards/new" })
  end

  def create
  vibe_sentence = params.fetch("vibe_sentence")

  chat = AI::Chat.new
  chat.proxy = true

  # Tell the model to return JSON with the structure you want
  chat.system(
    "You are an interior design assistant. " \
    "The user will describe a room and a vibe. " \
    "Respond ONLY with JSON, no extra text. " \
    "The JSON must have two keys: " \
    "`items` (array of objects with `category`, `description`, `why_it_works`) " \
    "and `style_rules` (array of strings)."
  )

  chat.user(vibe_sentence)

  # No chat.schema = ... here

  response_hash = chat.generate!
  raw_content = response_hash.fetch(:content) # this is a JSON string

  ai_hash = JSON.parse(raw_content)

  the_moodboard = Moodboard.new
  the_moodboard.vibe_sentence = vibe_sentence
  the_moodboard.ai_data_json = ai_hash.to_json
  the_moodboard.save

  redirect_to("/moodboards/#{the_moodboard.id}")
end

  def show
    the_id = params.fetch("id")
    matching_moodboards = Moodboard.where({ :id => the_id })
    @moodboard = matching_moodboards.at(0)

    render({ :template => "moodboards/show" })
  end
end
