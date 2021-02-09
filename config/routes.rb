Rails.application.routes.draw do
  root "posts#new"
  get  "/" => "posts#new"
  post "/result" => "posts#result"

end
