Rails.application.routes.draw do
  resources :interview_schedules
  resources :interviews

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
