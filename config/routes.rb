# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

Rails.application.routes.draw do
  # rubocop:disable Metrics/LineLength
  mount GraphiQL::Rails::Engine, at: '/graphiql', graphql_path: '/graphql' if Rails.env.development?
  post '/graphql', to: 'graphql#execute'
  root to: 'home#index'
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }, skip: :sessions
  as :user do
    delete '/sign_out' => 'devise/sessions#destroy', :as => :destroy_user_session
    # rubocop:enable Metrics/LineLength
  end
  # get '/boardsql', to: 'boardsql#show'

  resources :boards, param: :slug do
    member do
      post 'continue'
    end

    scope module: 'boards' do
      resources :cards, only: :create
      resources :memberships, only: :create
      resources :action_items, only: :create do
      end
    end
  end

  resources :action_items, only: :index do
    member do
      put 'close'
      put 'complete'
      put 'reopen'
    end
  end

  resources :teams

  namespace :api do
    resources :boards, param: :slug do
      member do
        post 'invite'
        get 'suggestions'
      end
      resources :memberships, only: %i[index destroy] do
        collection do
          get 'ready_status'
          put 'ready_toggle'
        end
      end
      resources :cards do
        member do
          put 'like'
        end
        resources :comments, only: %i[create update destroy]
      end
      resources :action_items, only: %i[update destroy] do
        member do
          post 'move'
          put 'close'
          put 'complete'
          put 'reopen'
        end
      end
    end
  end

  resources :boardsql, param: :slug, only: :show

  mount ActionCable.server, at: '/cable'
end

# rubocop:enable Metrics/BlockLength
