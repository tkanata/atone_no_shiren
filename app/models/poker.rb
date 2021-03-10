# バリデーションメソッドを定義するクラス
class PokerValidator < ActiveModel::Validator
  def validate(record)
    if record.card_info.nil?
      # nilだった場合のエラーメッセージは半角スペースに関するメッセージと同じ
      record.errors[:card_info] << Settings.ERROR_MESSAGE.HALF_WIDTH_SPACE

    elsif record.card_info.empty?
      record.errors[:card_info] << Settings.ERROR_MESSAGE.EMPTY

    else
      # 5つの単語が半角スペース区切りで入力されているかを確認する
      unless record.card_info.match(Settings.REGEX.HALF_WIDTH_SPACE)
        record.errors[:card_info] << Settings.ERROR_MESSAGE.HALF_WIDTH_SPACE
        # 5枚以上のカードが入力されたら枚数を表示するバリデーション
        how_many_card(record)
      end

      # 重複するカードがあるか確認
      record.errors[:card_info] << Settings.ERROR_MESSAGE.DUPLICATE if record.card_info.match(Settings.REGEX.DUPLICATED)

      # 初期化
      invalid = false
      # カードを1枚ずつ確認
      record.card_info.split(' ').each_with_index do |card, index|
        if card !~ Settings.REGEX.EACH_CARD
          record.errors[:card_info] << "#{index + 1}枚目のカード情報が適切ではありません。(#{card})"
          invalid = true
        end
      end

      # いずれかのカードが不正の場合に最後にこのエラーメッセージを表示する
      record.errors[:card_info] << Settings.ERROR_MESSAGE.VALID_SUIT_NUM if invalid == true

    end
  end

  private

  def how_many_card(record)
    num_of_cards = record.card_info.split(' ').count
    record.errors[:card_info] << "カードが#{num_of_cards}枚あります。" if num_of_cards > 5
  end
end

# モデルではバリデーションを行う
class Poker < ApplicationRecord
  include ActiveModel::Model
  include ActiveModel::Validations

  attr_accessor :card_info

  # カスタムバリデーション。nil > 空白 > 5単語が半角スペース区切り > 重複 > 不適切なカード情報 という優先順位の条件分岐
  validates_with PokerValidator
end
