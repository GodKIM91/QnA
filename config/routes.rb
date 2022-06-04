Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

  concern :votable do
    member do
      patch :like
      patch :dislike
    end
  end

  concern :commentable do
    resources :comments, only: :create, shallow: true
  end
  
  resources :questions, concerns: [:votable, :commentable] do
    resources :answers, concerns: [:votable, :commentable], shallow: true do
      patch :set_best, on: :member
    end
  end

  resources :attachments, only: :destroy
  resources :links, only: :destroy
  resources :rewards, only: :index
end
