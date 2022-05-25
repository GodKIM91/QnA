require 'active_support/concern'

module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, dependent: :destroy, as: :votable
  end

  def rank_up(user)
    vote = self.votes.find_by(user: user)
    if vote
      vote.destroy if vote.value == 1 #отмена лайка реализована повторным нажатием на лайк
      vote.update!(value: 1) if vote.value == -1
    else
      self.votes.create!(user: user, value: 1)
    end
  end

  def rank_down(user)
    vote = self.votes.find_by(user: user)
    if vote
      vote.destroy if vote.value == -1 #отмена дизлайка реализована повторным нажатием на дизлайк
      vote.update!(value: -1) if vote.value == 1
    else
      self.votes.create!(user: user, value: -1)
    end
  end

  def rank
    self.votes.sum(:value)
  end
end