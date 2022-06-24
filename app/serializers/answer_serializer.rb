class AnswerSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :question_id, :body, :created_at, :updated_at, :user_id, :best, :files

  has_many :comments
  has_many :links

  def files
    object.files.map { |file| rails_blob_path(file, only_path: true) }
  end
end 