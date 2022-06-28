class Answer < ApplicationRecord
  include Votable
  include Commentable
  
  belongs_to :question
  belongs_to :user

  has_many_attached :files
  has_many :links, dependent: :destroy, as: :linkable
  
  accepts_nested_attributes_for :links, reject_if: :all_blank
  
  validates :body, presence: true

  scope :sort_by_best, -> { order(best: :desc) }

  after_create :new_answer_notice

  def set_as_best
    old_best_answer = question.answers.find_by(best: true)
    transaction do
      old_best_answer&.update!(best: false)
      update!(best: true)
      question.reward&.update!(user: user)
    end
  end

  def new_answer_notice
    NewAnswerNotifyJob.perform_later(self)
  end
end
