require 'rails_helper'

RSpec.describe Post, type: :model do

  describe "judge a card information" do

    context "when a card information is correct" do

      it "is valid with correct card information" do
        #有効なデータを作成
        post = Post.new(card_info:"S1 S2 S3 S4 S5")
        #exprctにpostを渡した時、それは有効であるという意味
        expect(post).to be_valid
      end

    end

    context "when a card information is incorrect" do

      it "is not valid with empty card information" do
        post = Post.new(card_info:"")
        post.valid?
        expect(post.errors[:card_info]).to include("can't be blank")
      end

      it "is not valid with too much card information" do
        post = Post.new(card_info:"S1 S2 S3 S4 S5 S6")
        post.valid?
        expect(post.errors[:card_info]).to include("において5つのカード指定文字を半角スペース区切りで入力してください。（例：\"S1 H3 D9 C13 S11\"）")
      end

      it "is not valid with wrong suit information" do
        post = Post.new(card_info:"S1 S2 S3 S4 X5")
        post.valid?
        expect(post.errors[:card_info]).to include("において5つのカード指定文字を半角スペース区切りで入力してください。（例：\"S1 H3 D9 C13 S11\"）")
      end

      it "is not valid with wrong card number information" do
        post = Post.new(card_info:"S1 S2 S3 S4 S20")
        post.valid?
        expect(post.errors[:card_info]).to include("において5つのカード指定文字を半角スペース区切りで入力してください。（例：\"S1 H3 D9 C13 S11\"）")
      end

      it "is not valid without a space between the each card" do
        post = Post.new(card_info:"S1 S2 S3 S4S5")
        post.valid?
        expect(post.errors[:card_info]).to include("において5つのカード指定文字を半角スペース区切りで入力してください。（例：\"S1 H3 D9 C13 S11\"）")
      end

      it "is not valid with duplicated card" do
        post = Post.new(card_info:"S1 S2 S3 S1 H2")
        post.valid?
        expect(post.errors[:card_info]).to include("においてカードが重複しています。")
      end

    end

  end

end
