require 'thread'

class Comm
  QUIT = 'q'

  def initialize(input,output=nil)
    @mutex = Mutex.new
    @input = input
    @output = (output)? output: input # input may be w+

    @responding = true
    @responded = false
    @transmision = nil
    @th = Thread.new {
      while @responding do
        transmision = @input.gets.strip
        @mutex.synchronize do
          @transmision = transmision
          @responded = true
          @responding = false if transmision == QUIT
        end
      end
    }
  end

  def close
    @input.close
    @output.close if @input != @output
  end

  def send( command=nil )
    response = nil
    if @responding then
      @mutex.synchronize do
        @responded = false
        if command then
          @output.puts command
        end
      end
      while !@responded do
        Thread.pass
      end
      @mutex.synchronize do
        response = @transmision
      end
    else
      response = QUIT
    end
    return response
  end
  alias receive send

  def responding?
    return @responding
  end
end
