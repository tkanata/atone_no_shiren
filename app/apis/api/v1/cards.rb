#module API
  module V1
    class Cards < Grape::API
      content_type :json, 'application/json'
      format :json

    end
  end
#end