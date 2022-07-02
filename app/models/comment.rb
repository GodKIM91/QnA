class Comment < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  belongs_to :user
  belongs_to :commentable, polymorphic: true
  
  validates :body, presence: true

  settings do
    mappings dynamic: false do
      indexes :body, type: :text
    end
  end
end
