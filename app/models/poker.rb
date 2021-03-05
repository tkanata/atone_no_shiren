class PokerValidator < ActiveModel::Validator
  #カード5枚分の入力を分割して、1枚ずつバリデーションをかけるメソッド
  def validate(record)
    # 入力が存在しかつ単語がスペース区切りの場合のみ重複とカードごとのバリデーションを実行する
    if record.card_info.empty?
      record.errors[:card_info] << Settings.ERROR_MESSAGE.EMPTY
    else
      if !record.card_info.match(/\A\w+ \w+ \w+ \w+ \w+\z/)
        record.errors[:card_info] << Settings.ERROR_MESSAGE.HALF_WIDTH_SPACE
        if record.card_info.split(' ').count > 5
          record.errors[:card_info] << "カードが#{record.card_info.split(' ').count}枚あります。"
        end
      end
      if record.card_info.match(/([SHDC](?:[1][0-3]\b|[1-9]\b)).+\b(\1)\b/)
        record.errors[:card_info] << Settings.ERROR_MESSAGE.DUPLICATE
      end
      

      invalid = false
      record.card_info.split(' ').each_with_index do |card, index|
        if card !~ /([SHDC](?:[1][0-3]\b|[1-9]\b))/
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

  #カスタムバリデーション。空白 > 5単語が半角スペース区切り > 重複 > 不適切なカード情報 という優先順位の条件分岐
  validates_with PokerValidator

end

# 無駄に作ってしまったけどもったいなくて残している正規表現達の墓場

# VALID_CARD_1ST_REGEX = /\A([SHDC](?:[1][0123]\b|[123456789]\b))/
# VALID_CARD_2ND_REGEX =/(?:(?<=\A.. )|(?<=\A... ))([SDCH](?:[1][0123]\b|[123456789]\b))/
# VALID_CARD_3RD_REGEX = /(?:(?<=\A......)|(?<=\A.......)|(?<=\A........))([SDCH](?:[1][0123]\b|[123456789]\b))/
# VALID_CARD_4TH_REGEX = /\b([SDCH](?:[123456789]|[1][0123]))(?:(?= ...\z)|(?= ..\z))/
# VALID_CARD_5TH_REGEX = /\b([SHDC](?:[1][0123]|[123456789]))\z/
# 重複の検出
# VALID_INPUT_DUP_REGEX = /([SHDC](?:[1][0123]\b|[123456789]\b)).+\b(\1)\b/
# 適切なカード1枚分の入力にマッチする正規表現
# VALID_CARD_REGEX     = /([SHDC](?:[1][0123]\b|[123456789]\b))/
# カード5枚分の適切な入力にマッチする正規表現
# VALID_INPUT_FORMAT_REGEX = /\A(?<card1>[SDHC](?:[1][0-3]|[1-9])) (?<card2>[SDHC](?:[1][0-3]|[1-9])) (?<card3>[SDHC](?:[1][0-3]|[1-9])) (?<card4>[SDHC](?:[1][0-3]|[1-9])) (?<card5>[SDHC](?:[1][0-3]|[1-9]))\z/
