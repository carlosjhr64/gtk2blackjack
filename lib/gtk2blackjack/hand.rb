class Hand
  attr_accessor :bet, :insured
  attr_reader :blackjack, :soft, :aces, :splitable, :next

  def clear
    @bj_value = 0
    @aces = false
    @soft = false
    @bet = 0
    @blackjack = false
    @insured = false
    @splitable = false
    @n = 0
    @next = nil
  end

  def initialize()
    self.clear
  end

  def store
    @s1 = @bj_value
    @s2 = @aces
    @s3 = @soft
    @s4 = @bet
    @s5 = @blackjack
    @s6 = @insured
    @s7 = @splitable
    @s8 = @n
    @s9 = (@next)? @next.dup: @next
  end

  def restore
    @bj_value	= @s1
    @aces	= @s2
    @soft	= @s3
    @bet	= @s4
    @blackjack	= @s5
    @insured	= @s6
    @splitable	= @s7
    @n		= @s8
    @next	= @s9
    @s1 = @s2 = @s3 = @s4 = @s5 = @s6 = @s7 = @s8 = @s9 = nil
  end

  def hits(card)
    @n += 1
    n = card.to_i
    if n > 0 then
      @bj_value += n
    else
      if card[0,1] == 'a' then
        if @aces then
          @bj_value += 1
        else
          @aces = true
        end
      else
        @bj_value += 10
      end
    end
    if @n == 2 then
      if @aces then
        (@bj_value == 10)?  (@blackjack = true): (@splitable = (@bj_value == 1))
      else
        @splitable = (n+n == @bj_value)
      end
    elsif @splitable then
      @splitable = false
    end
    @soft = (@aces && @bj_value < 11)
    return self
  end

  def bj_value
    val = @bj_value
    if @aces then
      if @bj_value < 11 then
        val += 11
      else
        val += 1
      end
    end
    return val
  end

  def split
    if @aces then
      @bj_value = 0
    else
      @bj_value /= 2
    end
    @splitable = false
    @next = self.dup
  end
end
