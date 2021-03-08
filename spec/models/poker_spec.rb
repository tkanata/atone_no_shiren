require 'rails_helper'

RSpec.describe Poker, type: :model do

  describe 'judge a card information' do

    context 'when a card information is correct' do

      it 'is valid with correct card information' do
        #有効なデータを作成
        poker = Poker.new(card_info:'S1 D2 H3 C4 S13')
        #exprctにpokerを渡した時、それは有効であるという意味
        expect(poker).to be_valid
      end

    end

    context 'when a card information is incorrect' do

      it 'is not valid with empty card information' do
        poker = Poker.new(card_info:'')
        poker.valid?
        expect(poker.errors[:card_info]).to include(Settings.ERROR_MESSAGE.EMPTY)
      end

      it 'is not valid with wrong space before and after cards' do
        poker = Poker.new(card_info:' S1 S2 S3 S4 S5 ')
        poker.valid?
        expect(poker.errors[:card_info]).to include(Settings.ERROR_MESSAGE.HALF_WIDTH_SPACE)
      end

      it 'is not valid with too much card information' do
        poker = Poker.new(card_info:'S1 S2 S3 S4 S5 S6')
        poker.valid?
        expect(poker.errors[:card_info]).to include(Settings.ERROR_MESSAGE.HALF_WIDTH_SPACE)
      end

      test_cards = ['X1 S2 S3 S4 S5', 'S1 X2 S3 S4 S5', 'S1 S2 X3 S4 S5', 'S1 S2 S3 X4 S5', 'S1 S2 S3 S4 X5']
      test_cards.each_with_index do |card, index|
        describe 'validation of wrong suit for each card' do
          example "{#{card}}" do
            poker = Poker.new(card_info: card)
            poker.valid?
            expect(
              poker.errors[:card_info]
            ).to include(
                   "#{index + 1}枚目のカード情報が適切ではありません。(X#{index + 1})", Settings.ERROR_MESSAGE.VALID_SUIT_NUM
                 )
          end
        end
      end

      test_cards = ['S14 S2 S3 S4 S5', 'S1 S14 S3 S4 S5', 'S1 S2 S14 S4 S5', 'S1 S2 S3 S14 S5', 'S1 S2 S3 S4 S14']
      test_cards.each_with_index do |card, index|
        describe 'validation of too large number for each card' do
          example "{#{card}}" do
            poker = Poker.new(card_info: card)
            poker.valid?
            expect(
              poker.errors[:card_info]
            ).to include(
                   "#{index + 1}枚目のカード情報が適切ではありません。(S14)", Settings.ERROR_MESSAGE.VALID_SUIT_NUM
                 )
          end
        end
      end

      test_cards = ['S0 S2 S3 S4 S5', 'S1 S0 S3 S4 S5', 'S1 S2 S0 S4 S5', 'S1 S2 S3 S0 S5', 'S1 S2 S3 S4 S0']
      test_cards.each_with_index do |card, index|
        describe 'validation of wrong number zero for each card' do
          example "{#{card}}" do
            poker = Poker.new(card_info: card)
            poker.valid?
            expect(
              poker.errors[:card_info]
            ).to include(
                   "#{index + 1}枚目のカード情報が適切ではありません。(S0)", Settings.ERROR_MESSAGE.VALID_SUIT_NUM
                 )
          end
        end
      end

      it 'is not valid without a half width space between the each card' do
        poker = Poker.new(card_info:'S1 S2 S3 S4S5')
        poker.valid?
        expect(poker.errors[:card_info]).to include(Settings.ERROR_MESSAGE.HALF_WIDTH_SPACE)
      end

      it 'is not valid with a full width space between the card' do
        poker = Poker.new(card_info: 'S1 S2 S3 S4　S5')
        poker.valid?
        expect(poker.errors[:card_info]).to include(Settings.ERROR_MESSAGE.HALF_WIDTH_SPACE)
      end

      it 'is not valid with duplicated card' do
        poker = Poker.new(card_info:'S1 S2 S3 S1 H2')
        poker.valid?
        expect(poker.errors[:card_info]).to include(Settings.ERROR_MESSAGE.DUPLICATE)
      end

      it 'is not valid with duplicated card and wrong suit' do
        poker = Poker.new(card_info: 'S1 S2 S1 S5 K12')
        poker.valid?
        expect(poker.errors[:card_info]).to include(Settings.ERROR_MESSAGE.DUPLICATE, '5枚目のカード情報が適切ではありません。(K12)')
      end

    end

  end

end
