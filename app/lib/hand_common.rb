# web appとAPIの共通処理を行うメソッド
# 入力：カード情報(文字列)を格納したcardを引数とする
# 出力：役の名前を文字列で返す

module HandCommon

  def self.hand_common(card)
    
    #フラッシュ、ストレートフラッシュ、ストレートの判定を先に行う

    # スートの判定
    # H, S, C, D を取得。配列で返す
    heart = card.scan('H')
    club = card.scan('C')
    spade = card.scan('S')
    dia = card.scan('D')

    flash = false

    # フラッシュの判定
    if heart.size == 5 || club.size ==5 || spade.size == 5 || dia.size ==5
      flash = true
    end

    # 番号のみを抜き出して並べ替える
    num = card.scan(/\d+/).sort


    for n in 1..4 do
      if num[0].to_i + n != num[n].to_i
        straight = false
        break
      else
        straight = true
      end
    end

    # ストレートフラッシュ、ストレート、フラッシュの判定
    if straight && flash
      @hand = 'ストレートフラッシュ'
    elsif straight
      @hand = 'ストレート'
    elsif flash
      @hand = 'フラッシュ'
    else
      @hand = false
    end

    # ストレートフラッシュ、フラッシュ、ストレートのいずれかならば、@handを返して終了する
    return @hand if @hand

    # 数字を整数に変換
    num = num.map!(&:to_i)

    # 数字ごとにグループ化してハッシュ形式に変換
    group = num.group_by(&:itself).map do |key, value|
      [key, value.count]
    end.to_h

    # 重複した数字の組数で役を判断
    # 役が確定した段階でbreakし、@hand を戻り値として処理を終了

    # 初期化
    @pair = 0
    @three_of_a_kind = false

    # 重複の数によって役を判定
    group.values.sort.reverse.each do |value|

      if value == 4
        @hand = 'フォー・オブ・ア・カインド'
        break
      elsif value == 3
        @three_of_a_kind = true
      elsif value == 2
        @pair += 1
        if @three_of_a_kind
          @hand = 'フルハウス'
          break
        end
      else
        if @three_of_a_kind
          @hand = 'スリー・オブ・ア・カインド'
          break
        end
      end

      if @pair == 1
        @hand = 'ワンペア'
      elsif @pair == 2
        @hand = 'ツーペア'
      else
        @hand = 'ハイカード'
      end

    end

    return @hand

  end
end
