class PostValidator < ActiveModel::Validator
  def validate(record)
    unless record.card_info != nil
      unless record.card_info.split(" ")[0].match(/([SHDC](?:[1][0123]\b|[123456789]\b))/)
        record.errors[:card_info] << '1枚目のカード情報が適切ではありません！'
      end

      unless record.card_info.split(" ")[1].match(/([SHDC](?:[1][0123]\b|[123456789]\b))/)
        record.errors[:card_info] << '2枚目のカード情報が適切ではありません！'
      end

      unless record.card_info.split(" ")[2].match(/([SHDC](?:[1][0123]\b|[123456789]\b))/)
        record.errors[:card_info] << '3枚目のカード情報が適切ではありません！'
      end

      unless record.card_info.split(" ")[3].match(/([SHDC](?:[1][0123]\b|[123456789]\b))/)
        record.errors[:card_info] << '4枚目のカード情報が適切ではありません！'
      end

      unless record.card_info.split(" ")[4].match(/([SHDC](?:[1][0123]\b|[123456789]\b))/)
        record.errors[:card_info] << '5枚目のカード情報が適切ではありません！'
      end
    end
  end
end


class Post < ApplicationRecord
  include ActiveModel::Model
  include ActiveModel::Validations

  attr_accessor :card_info

  VALID_CARD_REGEX     = /([SHDC](?:[1][0123]\b|[123456789]\b))/
  #VALID_CARD_1ST_REGEX = /\A([SHDC](?:[1][0123]\b|[123456789]\b))/
  #VALID_CARD_2ND_REGEX =/(?:(?<=\A.. )|(?<=\A... ))([SDCH](?:[1][0123]\b|[123456789]\b))/
  #VALID_CARD_3RD_REGEX = /(?:(?<=\A......)|(?<=\A.......)|(?<=\A........))([SDCH](?:[1][0123]\b|[123456789]\b))/
  #VALID_CARD_4TH_REGEX = /\b([SDCH](?:[123456789]|[1][0123]))(?:(?= ...\z)|(?= ..\z))/
  #VALID_CARD_5TH_REGEX = /\b([SHDC](?:[1][0123]|[123456789]))\z/
  #↓の正規表現から得られる5つのマッチを用いて↑を表現することもできる
  VALID_INPUT_FORMAT_REGEX = /\A(?<card1>[SDHC](?:[1][0-3]|[1-9])) (?<card2>[SDHC](?:[1][0-3]|[1-9])) (?<card3>[SDHC](?:[1][0-3]|[1-9])) (?<card4>[SDHC](?:[1][0-3]|[1-9])) (?<card5>[SDHC](?:[1][0-3]|[1-9]))\z/

  #match = params[:card_info].match(/\A(?<card1>[SDHC](?:[1][0123]|[123456789])) (?<card2>[SDHC](?:[1][0123]|[123456789])) (?<card3>[SDHC](?:[1][0123]|[123456789])) (?<card4>[SDHC](?:[1][0123]|[123456789])) (?<card5>[SDHC](?:[1][0123]|[123456789]))\z/)

  #重複の検出
  VALID_INPUT_DUP_REGEX = /([SHDC](?:[1][0123]\b|[123456789]\b)).+\b(\1)\b/

  #validates :card_info, presence: {message: "入力してください"}, on: :new
  #validates :card_info, presence: {message: "入力してください"}, on: :result
  validates_presence_of(:card_info)
  #validates :card_info, format: {with: VALID_CARD_1ST_REGEX, message: "において1枚目のカードのデータが適切ではありません。"}, unless: -> { card_info.blank? }
  #validates :card_info, format: {with: VALID_CARD_2ND_REGEX, message: "において2枚目のカードのデータが適切ではありません。"}, unless: -> { card_info.blank? }
  #validates :card_info, format: {with: VALID_CARD_3RD_REGEX, message: "において3枚目のカードのデータが適切ではありません。"}, unless: -> { card_info.blank? }
  #validates :card_info, format: {with: VALID_CARD_4TH_REGEX, message: "において4枚目のカードのデータが適切ではありません。"}, unless: -> { card_info.blank? }
  #validates :card_info, format: {with: VALID_CARD_5TH_REGEX, message: "において5枚目のカードのデータが適切ではありません。"}, unless: -> { card_info.blank? }
  validates :card_info, format: {with: VALID_INPUT_FORMAT_REGEX, message: "において5つのカード指定文字を半角スペース区切りで入力してください。（例：\"S1 H3 D9 C13 S11\"）"}, unless: -> { card_info.blank? }
  validates :card_info, format: {without: VALID_INPUT_DUP_REGEX, message: "においてカードが重複しています。"}
  validates_with PostValidator
end
