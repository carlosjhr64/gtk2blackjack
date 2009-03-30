class Player
  attr_accessor :name, :bank, :hands

  def initialize
    @name = @bank = @hands = @s1 = nil
  end

  def store
    @hands.store
    @s1 = @bank
  end

  def restore
    @hands.restore
    @bank = @s1
    @s1 = nil
  end
end
