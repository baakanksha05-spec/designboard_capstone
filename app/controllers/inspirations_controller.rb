require "ai-chat"
require "json"
require "securerandom"
require "fileutils"

class InspirationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @inspirations = Inspiration.where({ :user_id => current_user.id })

    render({ :template => "inspirations/index" })
  end

  def new
    @inspiration = Inspiration.new

    render({ :template => "inspirations/new" })
  end

  def create
    uploaded = params.fetch("photo")
    notes = params.fetch("notes", "")

    filename = "#{SecureRandom.uuid}_#{uploaded.original_filename}"
    uploads_path = Rails.root.join("public", "uploads")
    FileUtils.mkdir_p(uploads_path)
    full_path = uploads_path.join(filename)

    File.binwrite(full_path, uploaded.read)

    image_path = "/uploads/#{filename}"
    image_url = "#{request.base_url}#{image_path}"

    chat = AI::Chat.new
    chat.proxy = true

    chat.system(
      "You are an interior design coach. " \
      "Given a reference room photo URL and optional notes, " \
      "1) describe the style, 2) list concrete items to buy, " \
      "3) give styling rules. Respond ONLY with JSON. " \
      "JSON keys: items (array of objects: category, description, why_it_works), " \
      "style_rules (array of strings), shopping_tips (array of strings)."
    )

    chat.user(
      "Reference room image URL: #{image_url}. " \
      "User notes: #{notes}."
    )

    response_hash = chat.generate!
    raw_content = response_hash.fetch(:content)
    ai_hash = JSON.parse(raw_content)

    the_inspiration = Inspiration.new
    the_inspiration.image_path = image_path
    the_inspiration.notes = notes
    the_inspiration.ai_data_json = ai_hash.to_json
    the_inspiration.user_id = current_user.id
    the_inspiration.save

    redirect_to("/inspirations/#{the_inspiration.id}")
  end

  def show
    the_id = params.fetch("id")

    matching_inspirations = Inspiration.where({
      :id => the_id,
      :user_id => current_user.id
    })
    @inspiration = matching_inspirations.at(0)

    render({ :template => "inspirations/show" })
  end
end
