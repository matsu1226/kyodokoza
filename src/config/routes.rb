Rails.application.routes.draw do
  root 'static_pages#introduction'
  get 'static_pages/introduction'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
