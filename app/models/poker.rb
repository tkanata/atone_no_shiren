class PokerValidator < ActiveModel::Validator
  #カード5枚分の入力を分割して、1枚ずつバリデーションをかけるメソッド
  def validate(record)
    # 入力が存在しかつ単語がスペース区切りの場合のみ重複とカードごとのバリデーションを実行する

    if record.card_info.nil?
      record.errors[:card_info] << Settings.ERROR_MESSAGE.HALF_WIDTH_SPACE

      elsif record.card_info.empty?
      record.errors[:card_info] << Settings.ERROR_MESSAGE.EMPTY

    else
      if !record.card_info.match(Settings.REGEX.HALF_WIDTH_SPACE)
        record.errors[:card_info] << Settings.ERROR_MESSAGE.HALF_WIDTH_SPACE
        record.errors[:card_info] << "カードが#{record.card_info.split(' ').count}枚あります。" if record.card_info.split(' ').count > 5
      end

      record.errors[:card_info] << Settings.ERROR_MESSAGE.DUPLICATE if record.card_info.match(Settings.REGEX.DUPLICATED)

      invalid = false
      record.card_info.split(' ').each_with_index do |card, index|
        if card !~ Settings.REGEX.EACH_CARD
          record.errors[:card_info] << "#{index + 1}枚目のカード情報が適切ではありません。(#{card})"
          invalid = true
        end
      end

      record.errors[:card_info] << Settings.ERROR_MESSAGE.VALID_SUIT_NUM if invalid == true

    end
  end
end

class Poker < ApplicationRecord
  include ActiveModel::Model
  include ActiveModel::Validations

  attr_accessor :card_info

  #カスタムバリデーション。nil > 空白 > 5単語が半角スペース区切り > 重複 > 不適切なカード情報 という優先順位の条件分岐
  validates_with PokerValidator

end
