class PostValidator < ActiveModel::Validator
  #カード5枚分の入力を分割して、1枚ずつバリデーションをかけるメソッド
  def validate(record)
    # 入力が存在しかつ単語がスペース区切りの場合のみ重複とカードごとのバリデーションを実行する
    if record.card_info.empty?
      record.errors[:card_info] << '値を入力してください'
    elsif !record.card_info.match(/\A\w+ \w+ \w+ \w+ \w+\z/)
      record.errors[:card_info] << '5つのカード指定文字を半角スペース区切りで入力してください。（例："S1 H3 D9 C13 S11"）'
    else
      if record.card_info.match(/([SHDC](?:[1][0123]\b|[123456789]\b)).+\b(\1)\b/)
        record.errors[:card_info] << 'カードが重複しています'
      end

      @invalid = 0
      if record.card_info.split(" ")[0] !~ /([SHDC](?:[1][0123]\b|[123456789]\b))/
        record.errors[:card_info] << "1枚目のカード情報が適切ではありません。(#{record.card_info.split(" ")[0]})"
        @invalid = 1
      end

      if record.card_info.split(" ")[1] !~ (/([SHDC](?:[1][0123]\b|[123456789]\b))/)
        record.errors[:card_info] << "2枚目のカード情報が適切ではありません。(#{record.card_info.split(" ")[1]})"
        @invalid = 1
      end

      if record.card_info.split(" ")[2] !~ (/([SHDC](?:[1][0123]\b|[123456789]\b))/)
        record.errors[:card_info] << "3枚目のカード情報が適切ではありません。(#{record.card_info.split(" ")[2]})"
        @invalid = 1
      end

      if record.card_info.split(" ")[3] !~ (/([SHDC](?:[1][0123]\b|[123456789]\b))/)
        record.errors[:card_info] << "4枚目のカード情報が適切ではありません。(#{record.card_info.split(" ")[3]})"
        @invalid = 1
      end

      if record.card_info.split(" ")[4] !~ (/([SHDC](?:[1][0123]\b|[123456789]\b))/)
        record.errors[:card_info] << "5枚目のカード情報が適切ではありません。(#{record.card_info.split(" ")[4]})"
        @invalid = 1
      end

      if @invalid == 1
        record.errors[:card_info] << "半角英字大文字のスート（S,H,D,C）と数字（1〜13）の組み合わせでカードを指定してください。"
      end
    end
  end
end


class Post < ApplicationRecord
  include ActiveModel::Model
  include ActiveModel::Validations

  attr_accessor :card_info

  #カスタムバリデーション。空白 > 5単語が半角スペース区切り > 重複 > 不適切なカード情報 という優先順位の条件分岐
  validates_with PostValidator

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