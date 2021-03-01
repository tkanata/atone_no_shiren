require 'rails_helper'

RSpec.describe PostsController, type: :controller do

  # newアクションが適切に応答しているかどうかのテスト
  describe "new" do
    it "responds successfully" do
      get :new
      expect(response).to be_successful
    end
  end

  # resultアクションにおいてカード情報を更新できるかどうかのテスト
  # 入力が不正だとしても、バリデーションはモデルの仕事なので値は@postに保持される

  describe "result" do
    context "when @post receives valid card information from a form" do

      before do
        @post = FactoryBot.build(:post)
      end

      it "adds a card information to @post" do
        post_params = FactoryBot.attributes_for(:post, card_info: "H1 H2 H3 H4 H5")
        post :result, params: {post: post_params}
        @post = Post.new(post_params)
        expect(@post.card_info).to eq "H1 H2 H3 H4 H5"
      end

    end

    context "when @post receives invalid card information from a form" do

      before do
        @post = FactoryBot.build(:post)
      end

      it "adds a card information to @post" do
        post_params = FactoryBot.attributes_for(:post, card_info: "H1 H2 H3 H4")
        post :result, params: {post: post_params}
        @post = Post.new(post_params)
        expect(@post.card_info).to eq "H1 H2 H3 H4"
      end

    end

  end
end
