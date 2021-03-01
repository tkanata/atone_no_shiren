module Ver1
  class Root < Grape::API
    # これでdomain/api/v1でアクセス出来るようになる。(versioning)
    version 'v1', using: :path
    format :json
    mount Ver1::Cards
  end
end
