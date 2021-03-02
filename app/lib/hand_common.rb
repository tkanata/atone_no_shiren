# web appとAPIの共通処理を行うメソッド
# 入力値から数字を抜き出して配列に格納したnumを引数とする
# ストレートフラッシュ、フラッシュ、ストレート以外の役のみを戻り値とする

module HandCommon

  def self.hand_common(num)

    # 数字ごとにグループ化してハッシュ形式にしました。
    group = num.group_by(&:itself).map do |key, value|
      [key, value.count]
      end.to_h

    # 同じ数字の数で役を見分けている
    # 役が確定した段階でif文から抜け、@hand を戻り値として処理を終了する
    @pair = 0
    @three_of_a_kind = 0
    group.values.sort.reverse.each do |value|
      if value == 4
        @hand = "フォー・オブ・ア・カインド"
        break
      elsif value == 3
        @three_of_a_kind = 1
      elsif value == 2
        @pair += 1
        if @three_of_a_kind == 1
          @hand = "フルハウス"
          break
        end
      else
        if @three_of_a_kind == 1
          @hand = "スリー・オブ・ア・カインド"
          break
        end
      end
      if @pair == 1
        @hand = "ワンペア"
      elsif @pair == 2
        @hand = "ツーペア"
      else
        @hand = "ハイカード"
      end
    end

    return @hand

  end
end
