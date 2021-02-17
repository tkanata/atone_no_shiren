require 'rails_helper'

RSpec.describe PostsController, type: :controller do

  describe "new" do
    it "responds successfully" do
      get :new
      expect(response).to be_successful
    end
  end

  #カード情報を更新できるかどうかのテスト
  describe "result" do
    context "when @post is correct" do

      before do
        @post = FactoryBot.build(:post)
      end

      it "adds a card information" do
        post_params = FactoryBot.attributes_for(:post, card_info: "H1 H2 H3 H4 H5")
        post :result, params: {post: post_params}
        @post = Post.new(post_params)
        expect(@post.card_info).to eq "H1 H2 H3 H4 H5"
      end

      #it "returns straight flash" do
        #post_paramsにストレートフラッシュのカード情報を代入
      # post_params = FactoryBot.attributes_for(:post, card_info: "C1 C2 C3 C4 C5")
      # #resultアクションにPOSTしている。params経由でpost_paramsの値を@postに渡す
      # @post = Post.new(post_params)
        #createアクションが上記の@postの値を用いて実行されていれば、@handはstraight flashとなっているはず
      # expect(@hand).to eq "straight flash"
      #end

      #it "returns flash"

      #it "straight straight"

      #it "returns four of a kind"

      #it "returns full house"

      #it "returns three of a kind"

      #it "returns two pair"

      #it "returns one pair"

      #it "returns high card"

    end

    context "when @post is incorrect" do

      it "returns an error message about blank"

      it "returns an error message about each card"

      it "returns an error message about format of five cards"

    end

  end
end
