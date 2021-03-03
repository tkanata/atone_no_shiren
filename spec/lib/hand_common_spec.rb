require 'rails_helper'

include HandCommon

RSpec.describe "self.hand_common(card)" do
  context "when num is valid" do
    it "returns ストレートフラッシュ" do
      input = Post.new(card_info: "S1 S2 S3 S4 S5")
      expect(HandCommon.hand_common(input.card_info)).to eq("ストレートフラッシュ")
    end
    it "returns フラッシュ" do
      input = Post.new(card_info: "H1 H2 H3 H4 H9")
      expect(HandCommon.hand_common(input.card_info)).to eq("フラッシュ")
    end
    it "returns ストレート" do
      input = Post.new(card_info: "D1 H2 C3 S4 D5")
      expect(HandCommon.hand_common(input.card_info)).to eq("ストレート")
    end
    it "returns フォー・オブ・ア・カインド" do
      input = Post.new(card_info: "S1 D1 C1 H1 S10")
      expect(HandCommon.hand_common(input.card_info)).to eq("フォー・オブ・ア・カインド")
    end

    it "returns フルハウス" do
      input = Post.new(card_info: "S4 D4 H4 C13 H13")
      expect(HandCommon.hand_common(input.card_info)).to eq("フルハウス")
    end
    it "returns スリー・オブ・ア・カインド" do
      input = Post.new(card_info: "S9 H9 C9 D12 S7")
      expect(HandCommon.hand_common(input.card_info)).to eq("スリー・オブ・ア・カインド")
    end
    it "returns ツーペア" do
      input = Post.new(card_info: "S3 D3 H8 C8 H12")
      expect(HandCommon.hand_common(input.card_info)).to eq("ツーペア")
    end
    it "returns ワンペア" do
      input = Post.new(card_info: "S6 C6 H9 C13 S2")
      expect(HandCommon.hand_common(input.card_info)).to eq("ワンペア")
    end
    it "returns ハイカード" do
      input = Post.new(card_info: "S5 D2 C9 H12 D8")
      expect(HandCommon.hand_common(input.card_info)).to eq("ハイカード")
    end
  end

  # context "when num is invalid" do

  # end
end
