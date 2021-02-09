Rails.application.routes.draw do
  root "posts#new"
  get  "/" => "posts#new"
  #post "/" => "posts#create"
  #patch "/" => "posts#create"
  post "/show" => "posts#show"
  #patch "/show" => "posts#create"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  # app/api/api.rbをマウント
  # mount API::Base => '/'
end
