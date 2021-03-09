# web appとAPIの共通処理を行うメソッド
# 入力：カード情報(文字列)を格納したcardを引数とする
# 出力：役の名前を文字列で返す

module HandCommon
  def self.hand_common(card)
    # フラッシュ、ストレートフラッシュ、ストレートの判定を先に行う
    # フラッシュの判定
    flash = false
    if card.scan('H').size == 5 || card.scan('C').size == 5 || card.scan('S').size == 5 || card.scan('D').size == 5
      flash = true
    end

    # 番号のみを抜き出して左から小さい順に並べ替える
    num = card.scan(/\d+/).sort.map(&:to_i)

    # 連番の判定
    serialized_num = num.map.with_index { |_, index| num[0] + index }
    straight = true if num == serialized_num

    # 上記のパターンに一致しない例外的なストレートフラッシュ
    straight = true if num == [1, 10, 11, 12, 13]
    # ストレートフラッシュ、ストレート、フラッシュの判定
    hand = if straight && flash
             ENV['STRAIGHT_FLASH']
           elsif straight
             ENV['STRAIGHT']
           elsif flash
             ENV['FLASH']
           else
             false
           end

    # ストレートフラッシュ、フラッシュ、ストレートのいずれかならば、@handを返して終了する
    return hand if hand

    # 数字ごとにグループ化してハッシュ形式に変換
    group_hash = num.group_by(&:itself).transform_values(&:count)

    # 初期化
    n = 0
    pair = n
    three_of_a_kind = false

    # 重複の数によって役を判定
    group_hash.values.sort.reverse.each do |value|
      return hand = ENV['FOUR_OF_A_KIND'] if value == n + 4

      if value == n + 3
        three_of_a_kind = true
      elsif value == n + 2
        pair += 1
        return hand = ENV['FULL_HOUSE'] if three_of_a_kind
      elsif three_of_a_kind
        return hand = ENV['THREE_OF_A_KIND']
      end

      hand = case pair
             when 1
               ENV['ONE_PAIR']
             when 2
               ENV['TWO_PAIR']
             else
               ENV['HIGH_CARD']
             end
    end

    hand
  end
end
