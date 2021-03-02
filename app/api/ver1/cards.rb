module Ver1
  class Cards < Grape::API
    include ::HandsStrength

    content_type :json, 'application/json'
    format :json

    params do
      requires :cards, type: Array
    end

    post 'cards' do
      # 役の判定、最強の役の判定、バリデーションは以下のメソッドを用いる
      HandsStrength.output_api(params[:cards])

    end

  end
end
