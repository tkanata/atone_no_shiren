require 'rails_helper'

RSpec.describe "Posts", type: :request do

  describe "GET #new" do
    it "shows #new template" do
      get "/"
      expect(response).to render_template :new
    end

    #newメソッド使えないらしいので、もしかしてこれはテストできない？
    it "assigns new model instance to @post"
  end

  describe "GET #result" do
    it "shows #new template" do
      #"/result"にGETリクエストを出した時、newテンプレートを表示する
      get "/result"
      expect(response).to render_template :new
    end
  end

  describe "POST #result" do
    context "when @post is valid" do
      it "sends a POST request" do
        post "/result", :params => {:post => {:card_info => "S1 S2 S3 S4 H5"}}
        #↓@postにカード情報を渡して、result内での処理に使う
        #params.merge(card_info: "S1 S2 S3 S4 H5")
        #@post = Post.new(params[:card_info])
        expect(response.status).to eq 200
      end

      #it "returns straight" do
      # post :result, params: {card_info: "S1 S2 S3 S4 H5"}
      # expect(@hand).to eq "straight"
      #end
      #it "returns straight flash"
      #it "returns flash"
      #it "returns four of a kind"
      #it "returns three of a kind"
      #it "returns full house"
      #it "returns one pair"
      #it "returns two pair"
      #it "returns high card"
    end

    context "when @post is not valid" do
      it "returns empty instance @hand"
    end
  end

end
