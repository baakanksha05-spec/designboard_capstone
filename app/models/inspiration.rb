# == Schema Information
#
# Table name: inspirations
#
#  id           :bigint           not null, primary key
#  ai_data_json :text
#  image_path   :string
#  notes        :text
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class Inspiration < ApplicationRecord
end
