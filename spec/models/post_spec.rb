require 'rails_helper'

RSpec.describe Post, type: :model do

  describe "judge a card information" do

    context "when a card information is correct" do

      it "is valid with correct card information" do
        #有効なデータを作成
        post = Post.new(card_info:"S1 D2 H3 C4 S13")
        #exprctにpostを渡した時、それは有効であるという意味
        expect(post).to be_valid
      end

    end

    context "when a card information is incorrect" do

      it "is not valid with empty card information" do
        post = Post.new(card_info:"")
        post.valid?
        expect(post.errors[:card_info]).to include("値を入力してください")
      end

      it "is not valid with too much card information" do
        post = Post.new(card_info:"S1 S2 S3 S4 S5 S6")
        post.valid?
        expect(post.errors[:card_info]).to include("5つのカード指定文字を半角スペース区切りで入力してください。（例：\"S1 H3 D9 C13 S11\"）")
      end

      it "is not valid with wrong first suit information" do
        post = Post.new(card_info:"X1 S2 S3 S4 S5")
        post.valid?
        expect(post.errors[:card_info]).to include("1枚目のカード情報が適切ではありません。(X1)")
      end

      it "is not valid with wrong second suit information" do
        post = Post.new(card_info:"S1 X2 S3 S4 S5")
        post.valid?
        expect(post.errors[:card_info]).to include("2枚目のカード情報が適切ではありません。(X2)")
      end

      it "is not valid with wrong third suit information" do
        post = Post.new(card_info:"S1 S2 X3 S4 S5")
        post.valid?
        expect(post.errors[:card_info]).to include("3枚目のカード情報が適切ではありません。(X3)")
      end

      it "is not valid with wrong fourth suit information" do
        post = Post.new(card_info:"S1 S2 S3 X4 S5")
        post.valid?
        expect(post.errors[:card_info]).to include("4枚目のカード情報が適切ではありません。(X4)")
      end

      it "is not valid with wrong fifth suit information" do
        post = Post.new(card_info:"S1 S2 S3 S4 X5")
        post.valid?
        expect(post.errors[:card_info]).to include("5枚目のカード情報が適切ではありません。(X5)")
      end

      it "is not valid with too large first card number information" do
        post = Post.new(card_info:"S14 S2 S3 S4 S5")
        post.valid?
        expect(post.errors[:card_info]).to include("1枚目のカード情報が適切ではありません。(S14)")
      end

      it "is not valid with too large second card number information" do
        post = Post.new(card_info:"S1 S14 S3 S4 S5")
        post.valid?
        expect(post.errors[:card_info]).to include("2枚目のカード情報が適切ではありません。(S14)")
      end

      it "is not valid with too large third card number information" do
        post = Post.new(card_info:"S1 S2 S14 S4 S5")
        post.valid?
        expect(post.errors[:card_info]).to include("3枚目のカード情報が適切ではありません。(S14)")
      end

      it "is not valid with too large fourth card number information" do
        post = Post.new(card_info:"S1 S2 S3 S14 S5")
        post.valid?
        expect(post.errors[:card_info]).to include("4枚目のカード情報が適切ではありません。(S14)")
      end

      it "is not valid with too large fifth card number information" do
        post = Post.new(card_info:"S1 S2 S3 S4 S14")
        post.valid?
        expect(post.errors[:card_info]).to include("5枚目のカード情報が適切ではありません。(S14)")
      end

      it "is not valid with card number 0 for first card" do
        post = Post.new(card_info: "S0 S2 S3 S4 S5")
        post.valid?
        expect(post.errors[:card_info]).to include("1枚目のカード情報が適切ではありません。(S0)")
      end

      it "is not valid with card number 0 for second card" do
        post = Post.new(card_info: "S1 S0 S3 S4 S5")
        post.valid?
        expect(post.errors[:card_info]).to include("2枚目のカード情報が適切ではありません。(S0)")
      end

      it "is not valid with card number 0 for third card" do
        post = Post.new(card_info: "S1 S2 S0 S4 S5")
        post.valid?
        expect(post.errors[:card_info]).to include("3枚目のカード情報が適切ではありません。(S0)")
      end

      it "is not valid with card number 0 for fourth card" do
        post = Post.new(card_info: "S1 S2 S3 S0 S5")
        post.valid?
        expect(post.errors[:card_info]).to include("4枚目のカード情報が適切ではありません。(S0)")
      end

      it "is not valid with card number 0 for fifth card" do
        post = Post.new(card_info: "S1 S2 S3 S4 S0")
        post.valid?
        expect(post.errors[:card_info]).to include("5枚目のカード情報が適切ではありません。(S0)")
      end

      it "is not valid without a space between the each card" do
        post = Post.new(card_info:"S1 S2 S3 S4S5")
        post.valid?
        expect(post.errors[:card_info]).to include("5つのカード指定文字を半角スペース区切りで入力してください。（例：\"S1 H3 D9 C13 S11\"）")
      end

      it "is not valid with duplicated card" do
        post = Post.new(card_info:"S1 S2 S3 S1 H2")
        post.valid?
        expect(post.errors[:card_info]).to include("カードが重複しています")
      end

    end

  end

end
