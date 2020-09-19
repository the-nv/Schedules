Rails.application.routes.draw do
  resources :interview_schedules
  resources :interviews
  resources :users

  post 'interviews/contact', to: 'interviews#contact'

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  namespace 'api' do
    namespace 'v1' do
      resources :interviews
      resources :users
    end
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
