class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user
    return guest_abilities unless user
    user.admin? ? admin_abilities : user_abilities
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    can :create, [Question, Answer, Comment, Subscription]
    can :update, [Question, Answer], user_id: user.id
    can :destroy, [Question, Answer, Subscription], user_id: user.id
    can :set_best, Answer, question: { user_id: user.id }

    can :me, User
    can :index, User
    
    can :destroy, Link do |link|
      user.author_of?(link.linkable)
    end

    can :destroy, ActiveStorage::Attachment do |file|
      user.author_of?(file.record)
    end

    can %i[like dislike], [Answer, Question] do |votable|
      !user.author_of?(votable)
    end
  end

  def guest_abilities
    can :read, :all
  end
end
