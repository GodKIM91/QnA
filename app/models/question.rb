class Question < ApplicationRecord
  # include Elasticsearch::Model
  # include Elasticsearch::Model::Callbacks

  include Votable
  include Commentable
  
  has_many :answers, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable
  has_one :reward, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  
  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank
  accepts_nested_attributes_for :reward, reject_if: :all_blank

  belongs_to :user
  validates :title, :body, presence: true

  # settings do
  #   mappings dynamic: false do
  #     indexes :title, type: :text
  #     indexes :body, type: :text
  #   end
  # end
end
