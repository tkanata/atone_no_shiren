require 'rails_helper'

include HandCommon

RSpec.describe "hand_common(num)" do
  context "when num is valid" do
    it "returns フォー・オブ・ア・カインド" do
      num = ["1", "1", "1", "5", "1"]
      expect(HandCommon.hand_common(num)).to eq("フォー・オブ・ア・カインド")
    end

    it "returns フルハウス" do
      num = ["8", "8", "13", "13", "13"]
      expect(HandCommon.hand_common(num)).to eq("フルハウス")
    end
    it "returns スリー・オブ・ア・カインド" do
      num = ["8", "7", "8", "11", "8"]
      expect(HandCommon.hand_common(num)).to eq("スリー・オブ・ア・カインド")
    end
    it "returns ツーペア" do
      num = ["8", "10", "8", "10", "3"]
      expect(HandCommon.hand_common(num)).to eq("ツーペア")
    end
    it "returns ワンペア" do
      num = ["8", "7", "8", "10", "3"]
      expect(HandCommon.hand_common(num)).to eq("ワンペア")
    end
    it "returns ハイカード" do
      num = ["8", "7", "4", "10", "3"]
      expect(HandCommon.hand_common(num)).to eq("ハイカード")
    end
  end

  # context "when num is invalid" do

  # end
end