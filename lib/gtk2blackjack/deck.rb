class Deck < Array
  attr_accessor :i, :n

  def initialize(n=1,f='./data/deck.dat')
    super()
    File.open(f) { |fh| fh.each{ |card| self.push card.strip } }
    (n-1).times do
      self.concat( self.dup )
    end
    @i = 0
    @n = n
    @storage = nil
    @hole = nil; @noacehole = nil; @notenhole = nil
  end

  # setting the shuffle point k allows random replays of a particular deck information state
  def shuffle(k=0)
    @i = k # shuffle resets draw point
    tmp = j = nil
    self.push( @hole ) if @hole
    l = self.length
    raise "need k<deck.length" if k>=l
    k.upto(l-1) { |i|
      j = rand(l-k) + k
      tmp = self[i]
      self[i] = self[j]
      self[j] = tmp
    }
    if @hole then
      @hole = self.pop
      if @noacehole then
        while @hole[0,1] == 'a' do
          j = rand(l-k-1) + k; tmp = @hole; @hole = self[j]; self[j] = tmp
        end
      elsif @notenhole then
        while 'xjqk'.include?(@hole[0,1]) do
          j = rand(l-k-1) + k; tmp = @hole; @hole = self[j]; self[j] = tmp
        end
      end
    end
    return @hole || self
  end

  def draw
    raise "end of deck" if @i >= self.length
    ret = self[@i]
    @i += 1
    return ret
  end

  def remaining
    return self.length - @i
  end

  def store(hole,noacehole,notenhole)
    @hole = hole; @noacehole = noacehole; @notenhole = notenhole
    @storage = self.dup
  end

  def restore
    0.upto(self.length-1){ |i|
      self[i] = @storage[i]
    }
    @noacehole = nil; @notenhole = nil; @storage = nil; 
    hole = @hole; @hole = nil
    return hole
  end
end
