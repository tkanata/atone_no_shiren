# web appとAPIの共通処理を行うメソッド
# 入力：カード情報(文字列)を格納したcardを引数とする
# 出力：役の名前を文字列で返す

module HandCommon

  def self.hand_common(card)
    
    #フラッシュ、ストレートフラッシュ、ストレートの判定を先に行う
    # フラッシュの判定
    flash = false
    if card.scan('H').size == 5 || card.scan('C').size ==5 || card.scan('S').size == 5 || card.scan('D').size ==5
      flash = true
    end

    # 番号のみを抜き出して左から小さい順に並べ替える
    num = card.scan(/\d+/).sort.map(&:to_i)

    # 連番の判定
    serialized_num = num.map.with_index { |each_num, index| num[0] + index }
    straight =true if num == serialized_num

    # 上記のパターンに一致しない例外的なストレートフラッシュ
    straight = true if num == [1, 10, 11, 12, 13]
   
    # ストレートフラッシュ、ストレート、フラッシュの判定
    if straight && flash
      hand = ENV['STRAIGHT_FLASH']
    elsif straight
      hand = ENV['STRAIGHT']
    elsif flash
      hand = ENV['FLASH']
    else
      hand = false
    end

    # ストレートフラッシュ、フラッシュ、ストレートのいずれかならば、@handを返して終了する
    return hand if hand

    # 数字ごとにグループ化してハッシュ形式に変換
    group_hash = num.group_by(&:itself).map { |key, value| [key, value.count] }.to_h

    # 初期化
    pair = 0
    three_of_a_kind = false

    # 重複の数によって役を判定
    group_hash.values.sort.reverse.each do |value|
      if value == 4
        return hand = ENV['FOUR_OF_A_KIND']
      elsif value == 3
        three_of_a_kind = true
      elsif value == 2
        pair += 1
        return hand = ENV['FULL_HOUSE'] if three_of_a_kind
      else
        return hand = ENV['THREE_OF_A_KIND'] if three_of_a_kind
      end

      if pair == 1
        hand = ENV['ONE_PAIR']
      elsif pair == 2
        hand = ENV['TWO_PAIR']
      else
        hand = ENV['HIGH_CARD']
      end
    end

    return hand

  end
end
