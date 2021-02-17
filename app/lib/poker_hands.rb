module PokerHands
  def poker(card)
    #フラッシュ、ストレートフラッシュ、ストレートの判定
    # スートの判定プログラム
    # scanメソッドでH, S, C, D を取得。配列で返す
    heart = card.card_info.scan("H")
    club = card.card_info.scan("C")
    spade = card.card_info.scan("S")
    dia = card.card_info.scan("D")

    # フラッシュの判定
    if heart.size == 5 || club.size ==5 || spade.size == 5 || dia.size ==5
      @flash = 1
    end

    # 連番の判定
    num = card.card_info.scan(/\d+/)

    num = num.sort

    for n in 1..4 do
      if num[0].to_i + n != num[n].to_i
        @notice = "not straight or flash"
        break
      else
        #puts "#{num}"
        @notice = "straight"
      end
    end

    # ストレートフラッシュ、ストレート、フラッシュの判定
    if @notice == "straight" and @flash == 1
      @hand = "straight flash"
    elsif @notice == "straight"
      @hand = "straight"
    elsif @flash == 1
      @hand = "flash"
    else
      @hand = nil
    end

    if @hand != nil
      return @hand
    end

    #フラッシュ系、ストレート系以外の役の判定
    # 数字の重複の判定
    # 整数化
    num = card.card_info.scan(/\d+/)
    num = num.sort
    num = num.map!(&:to_i)

    # 数字ごとにグループ化してハッシュ形式にしました。
    group = num.group_by(&:itself).map{ |key, value| [key, value.count] }.to_h

    group.values.sort.reverse.each do |value|
      @pair = 0
      if value == 4
        @hand = "four of a kind"
        break
      elsif value == 3
        @three_of_a_kind = 1
      elsif value == 2
        if @three_of_a_kind == 1
          @hand = "full house"
        elsif
        @pair += 1
          if @pair == 2
            @hand = "two pair"
            break
          else
            @hand = "one pair"
            break
          end
        end
      else
        if @three_of_a_kind == 1
          @hand = "three of a kind"
        else
          @hand = "high card"
        end
      end
    end

    return @hand
  end
end