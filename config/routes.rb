# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
Rails.application.routes.draw do
  # rubocop:disable Metrics/LineLength
  mount GraphiQL::Rails::Engine, at: '/graphiql', graphql_path: '/graphql' if Rails.env.development?
  post '/graphql', to: 'graphql#execute'
  root to: 'home#index'
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }, only: :omniauth_callbacks
  as :user do
    delete '/sign_out' => 'devise/sessions#destroy', :as => :destroy_user_session
    # rubocop:enable Metrics/LineLength
  end

  direct :new_user_session do
    root_path
  end

  # get '/boardsql', to: 'boardsql#show'

  resources :boards, param: :slug do
    member do
      post 'continue'
    end
  end

  get 'my_boards', to: 'boards#my'
  get 'participating_boards', to: 'boards#participating'

  resources :action_items, only: :index do
    member do
      put 'close'
      put 'complete'
      put 'reopen'
    end
  end

  get 'my_actions', to: 'action_items#my'

  resources :teams

  resources :boardsql, param: :slug, only: :show

  mount ActionCable.server, at: '/cable'
end
# rubocop:enable Metrics/BlockLength
