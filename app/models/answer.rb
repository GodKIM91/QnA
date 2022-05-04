class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user
  
  validates :body, presence: true

  scope :sort_by_best, -> { order(best: :desc) }

  def set_as_best
    old_best_answer = question.answers.find_by(best: true)
		transaction do
			old_best_answer&.update!(best: false)
      update!(best: true)
		end
	end
end
