require 'rails_helper'

include PokerHands
include HandCommon

RSpec.describe "PokerHands" do
  describe "poker_web(card)" do

    context "when input is valid" do
      it "returns ストレートフラッシュ" do
        input = Post.new(card_info: "S1 S2 S3 S4 S5")
        expect(poker_web(input)).to eq("ストレートフラッシュ")
      end
      it "returns フラッシュ" do
        input = Post.new(card_info: "H1 H2 H3 H4 H9")
        expect(poker_web(input)).to eq("フラッシュ")
      end
      it "returns ストレート" do
        input = Post.new(card_info: "D1 H2 C3 S4 D5")
        expect(poker_web(input)).to eq("ストレート")
      end
      it "returns フォー・オブ・ア・カインド" do
        input = Post.new(card_info: "S1 D1 H1 C1 S5")
        expect(poker_web(input)).to eq("フォー・オブ・ア・カインド")
      end
      it "returns フルハウス" do
        input = Post.new(card_info: "S1 D1 H1 C13 S13")
        expect(poker_web(input)).to eq("フルハウス")
      end
      it "returns スリー・オブ・ア・カインド" do
        input = Post.new(card_info: "S12 D12 H12 C10 S13")
        expect(poker_web(input)).to eq("スリー・オブ・ア・カインド")
      end
      it "returns ツーペア" do
        input = Post.new(card_info: "S12 D12 H5 C5 S13")
        expect(poker_web(input)).to eq("ツーペア")
      end
      it "returns ワンペア" do
        input = Post.new(card_info: "S12 D12 H5 C1 S13")
        expect(poker_web(input)).to eq("ワンペア")
      end
      it "returns ハイカード" do
        input = Post.new(card_info: "S12 D10 H5 C3 S13")
        expect(poker_web(input)).to eq("ハイカード")
      end
    end

    # context "when input is empty" do
    # it ""
    # end

  end
end
