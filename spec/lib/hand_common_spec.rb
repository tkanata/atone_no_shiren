require 'rails_helper'

include HandCommon

RSpec.describe "self.hand_common(card)" do
  context "when num is valid" do
    it "returns ENV[STRAIGHT_FLASH]" do
      card_info = "S1 S2 S3 S4 S5"
      expect(HandCommon.hand_common(card_info)).to eq(ENV['STRAIGHT_FLASH'])
    end
    it "returns ENV[FLASH]" do
      card_info = "H1 H2 H3 H4 H9"
      expect(HandCommon.hand_common(card_info)).to eq(ENV['FLASH'])
    end
    it "returns ENV[STRAIGHT]" do
      card_info = "D1 H2 C3 S4 D5"
      expect(HandCommon.hand_common(card_info)).to eq(ENV['STRAIGHT'])
    end
    it "returns ENV[FOUR_OF_A_KIND]" do
      card_info = "S1 D1 C1 H1 S10"
      expect(HandCommon.hand_common(card_info)).to eq(ENV['FOUR_OF_A_KIND'])
    end
    it "returns ENV[FLL_HOUSE]" do
      card_info = "S4 D4 H4 C13 H13"
      expect(HandCommon.hand_common(card_info)).to eq(ENV['FULL_HOUSE'])
    end
    it "returns ENV[THREE_OF_A_KIND]" do
      card_info = "S9 H9 C9 D12 S7"
      expect(HandCommon.hand_common(card_info)).to eq(ENV['THREE_OF_A_KIND'])
    end
    it "returns ENV[TWO_PAIR]" do
      card_info = "S3 D3 H8 C8 H12"
      expect(HandCommon.hand_common(card_info)).to eq(ENV['TWO_PAIR'])
    end
    it "returns ENV[ONE_PAIR]" do
      card_info = "S6 C6 H9 C13 S2"
      expect(HandCommon.hand_common(card_info)).to eq(ENV['ONE_PAIR'])
    end
    it "returns ENV[HIGH_CARD]" do
      card_info = "S5 D2 C9 H12 D8"
      expect(HandCommon.hand_common(card_info)).to eq(ENV['HIGH_CARD'])
    end
  end
end
