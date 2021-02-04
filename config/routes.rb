Rails.application.routes.draw do
  root "posts#new"
  patch "/" => "posts#create"
  get "/show" => "posts#show"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  # app/api/api.rbをマウント
  # mount API::Base => '/'
end
