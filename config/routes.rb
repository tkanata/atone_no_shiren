Rails.application.routes.draw do

  root "pokers#new"
  get "/result" => "pokers#new"
  post "/result" => "pokers#result"

  #APIの設定
  mount API::Root => '/'

end
