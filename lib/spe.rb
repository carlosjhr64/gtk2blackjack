class SimplePipeEmulator
  @@n =  0
  attr_reader :n

  def initialize
    @buffer = []
    @mutex = Mutex.new
    @@n += 1
    @n = @@n
  end

  def gets
    ret = nil
    if @buffer then
      while @buffer.length == 0 do
        Thread.pass
      end
      @mutex.synchronize do
        ret = @buffer.shift
      end
    end
    return ret
  end

  def each
    while ret = self.gets do
      yield(ret)
    end
  end

  def puts(str)
    @mutex.synchronize do
      @buffer.push(str.to_s)
    end
  end

  def flush
    Thread.pass # just to have a flush do something
  end

  def close
    @mutex.synchronize do
      @buffer = nil
    end
  end
  alias new open
end
