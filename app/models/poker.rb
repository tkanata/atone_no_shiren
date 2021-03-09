class PokerValidator < ActiveModel::Validator
  #カード5枚分の入力を分割して、1枚ずつバリデーションをかけるメソッド
  def validate(record)
    # 入力が存在しかつ単語がスペース区切りの場合のみ重複とカードごとのバリデーションを実行する

    if record.card_info.nil?
      record.errors[:card_info] << Settings.ERROR_MESSAGE.HALF_WIDTH_SPACE

      elsif record.card_info.empty?
      record.errors[:card_info] << Settings.ERROR_MESSAGE.EMPTY

    else
      if !record.card_info.match(/\A\w+ \w+ \w+ \w+ \w+\z/)
        record.errors[:card_info] << Settings.ERROR_MESSAGE.HALF_WIDTH_SPACE
        if record.card_info.split(' ').count > 5
          record.errors[:card_info] << "カードが#{record.card_info.split(' ').count}枚あります。"
        end
      end
      if record.card_info.match(/(\b[SHDC](?:[1][0-3]\b|[1-9]\b)).+\b(\1)\b/)
        record.errors[:card_info] << Settings.ERROR_MESSAGE.DUPLICATE
      end
      

      invalid = false
      record.card_info.split(' ').each_with_index do |card, index|
        if card !~ /(\b[SHDC](?:[1][0-3]\b|[1-9]\b))/
          record.errors[:card_info] << "#{index + 1}枚目のカード情報が適切ではありません。(#{card})"
          invalid = true
        end
      end

      if invalid == true
        record.errors[:card_info] << Settings.ERROR_MESSAGE.VALID_SUIT_NUM
      end
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
