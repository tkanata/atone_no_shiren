Rails.application.routes.draw do

  root "posts#new"
  #get  "/" => "posts#new"
  get "/result" => "posts#new"
  post "/result" => "posts#result"

  #APIの設定
  mount API::Root => '/'

end
