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
      get 'history'
    end

    collection do
      get 'my'
      get 'participating'
    end
  end

  resources :action_items, only: :index do
    member do
      put 'close'
      put 'complete'
      put 'reopen'
    end
  end

  resources :users, only: %i[edit update] do
    member do
      delete 'avatar_destroy', to: 'users#avatar_destroy'
    end
  end

  resources :teams

  resources :boardsql, param: :slug, only: :show

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :action_items, only: %i[create update destroy] do
        member do
          put 'close'
          put 'complete'
          put 'move'
          put 'reopen'
        end
      end

      resources :boards, only: %i[index show]

      resources :cards, only: %i[create update destroy] do
        put 'like', on: :member
      end

      resources :comments, only: %i[create update destroy] do
        put 'like', on: :member
      end

      resources :memberships, only: %i[index create destroy] do
        get 'current', on: :collection
        put 'toggle_ready_status', on: :member
      end

      post 'suggestions', to: 'users#suggestions'
    end
  end

  mount ActionCable.server, at: '/cable'
end
# rubocop:enable Metrics/BlockLength
