Rails.application.routes.draw do
  #mount Versions::V1::Api => '/'
  #mount GrapeSwaggerRails::Engine => '/api/swagger'

  root "posts#new"
  get  "/" => "posts#new"
  get "/result" => "posts#new"
  post "/result" => "posts#result"

end
