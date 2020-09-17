Rails.application.routes.draw do
  resources :interview_schedules
  resources :interviews

  post 'interviews/contact', to: 'interviews#contact'

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
