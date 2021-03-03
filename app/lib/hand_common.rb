# web appとAPIの共通処理を行うメソッド
# 入力値から数字を抜き出して配列に格納したnumを引数とする
# ストレートフラッシュ、フラッシュ、ストレート以外の役のみを戻り値とする

module HandCommon

  def self.hand_common(card)
    
    #フラッシュ、ストレートフラッシュ、ストレートの判定
    # スートの判定プログラム
    # scanメソッドでH, S, C, D を取得。配列で返す
    heart = card.scan("H")
    club = card.scan("C")
    spade = card.scan("S")
    dia = card.scan("D")

    @flash = nil

    # フラッシュの判定
    if heart.size == 5 || club.size ==5 || spade.size == 5 || dia.size ==5
      @flash = 1
    end

    # 連番の判定
    num = card.scan(/\d+/).sort

    for n in 1..4 do
      if num[0].to_i + n != num[n].to_i
        @notice = "not straight or flash"
        break
      else
        @notice = "straight"
      end
    end

    # ストレートフラッシュ、ストレート、フラッシュの判定
    if @notice == "straight" and @flash == 1
      @hand = "ストレートフラッシュ"
    elsif @notice == "straight"
      @hand = "ストレート"
    elsif @flash == 1
      @hand = "フラッシュ"
    else
      @hand = nil
    end

    #ストレートフラッシュ、フラッシュ、ストレートのいずれかならば、@handを返して終了する
    unless @hand == nil
      return @hand
    end

    num = num.map!(&:to_i)

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
