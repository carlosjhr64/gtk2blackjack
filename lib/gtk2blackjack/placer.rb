#!/usr/bin/ruby
require 'thread'
require 'gtk2blackjack/constants.rb'
require 'gtk2blackjack/tables.rb'

COUNTS = 'c'

class Counts
  attr_accessor :updated

  TR = 16.0/52.0
  TRN = 1.0/(TR - (15.0/51.0))
  CV = {
	# from Beat The Dealer, page 48
	'a' => -2.42,
	'2' =>  1.75,
	'3' =>  2.14,
	'4' =>  2.64,
	'5' =>  3.58,
	'6' =>  2.40,
	'7' =>  2.05,
	'8' =>  0.43,
	'9' => -0.41,
	# set to -3.04 to counter balance to zero sum
	'x' => -3.04,
	'j' => -3.04,
	'q' => -3.04,
	'k' => -3.04,
  }

  def clear
    @i = 0

    @cv = 0
    @ca = 0
    @c2 = 0
    @cl = 0
    @c5 = 0
    @c7 = 0
    @cn = 0
    @cx = 0

    @peaked = false
    @ace_peaked = nil
    @ten_peaked = nil

    @updated = true
  end

  def initialize(n)
    @n = n
    @l = 52*n
    self.clear
  end

  def count(card)
    c = card[0,1]
    @i += 1
    @cv += CV[c]
    case c
      when 'a'			then @ca += 1
      when '2'			then @c2 += 1
      when '3','4','5','6'	
        @cl += 1
        @c5 += 1 if c == '5'
      when '7'			then @c7 += 1
      when '8','9'		then @cn += 1
      when 'x','j','q','k'	then @cx += 1
    end
    @updated = true
  end

  def counts
    n = @l - @i
    pn = (100.0 * (@cv/4.0) * (@n*48.0)/(n+1.0)  +  0.5).to_i / 100.0
    pm = @c2 + @cl - @ca - @cx
    tr = (100.0 * TRN * ((@n*16 - @cx).to_f/n.to_f - TR) + 0.5).to_i / 100.0
    return "A's:#{@ca} 2's:#{@c2} 3-6:#{@cl} 5's:#{@c5} 7's:#{@c7} 8-9:#{@cn} X's:#{@cx} D:#{tr} P:#{pn}% C:#{pm}"
  end
end

class Places
  include Constants
  attr_reader :sx, :sy

  PLACES = {}
  X = 0; Y = 1;

  DY = 20; DX = 13; DP = 93; 

  def initialize
    x = 37 - DP

    PLACES[DEALER]	= [300,   50]

    PLACES[P7]		= [x+=DP, 160]
    PLACES[P6]		= [x+=DP, 160]
    PLACES[P5]		= [x+=DP, 160]
    PLACES[P4]		= [x+=DP, 160]
    PLACES[P3]		= [x+=DP, 160]
    PLACES[P2]		= [x+=DP, 160]
    PLACES[P1]		= [x+=DP, 160]

    PLACES[SHUFFLE]	= [300, 200]
    PLACES[COUNTS]	= [10, 30]

    @splited = Hash.new(false)
  end

  def reset(label=nil)
    case label
    when COUNTS
      PLACES[COUNTS][X]	= 10
      PLACES[COUNTS][Y]	= 30
    else
      PLACES[DEALER][X]	= 300
      PLACES[DEALER][Y]	= 50
      x = 37 - DP
      PLACES[P7][X]	= (x+=DP)
      PLACES[P6][X]	= (x+=DP)
      PLACES[P5][X]	= (x+=DP)
      PLACES[P4][X]	= (x+=DP)
      PLACES[P3][X]	= (x+=DP)
      PLACES[P2][X]	= (x+=DP)
      PLACES[P1][X]	= (x+=DP)

      PLACES[P7][Y]	= 160
      PLACES[P6][Y]	= 160
      PLACES[P5][Y]	= 160
      PLACES[P4][Y]	= 160
      PLACES[P3][Y]	= 160
      PLACES[P2][Y]	= 160
      PLACES[P1][Y]	= 160
    end
  end

  def split(player)
    @splited[player] = true
    @sx = PLACES[player][X]
    @sy = PLACES[player][Y]
    PLACES[player][X] += DX
    PLACES[player][Y] = 160
  end
  def splited?(player)
    return @splited[player]
  end
  def restore(player)
    PLACES[player][X] = @sx
    PLACES[player][Y] = @sy
    @splited[player] = false
  end

  def xy(label,mv=true,dx=0,dy=0)
    ret = "#{PLACES[label][X] + dx} #{PLACES[label][Y] + dy}"
    if mv then
      case label
      when COUNTS
        PLACES[COUNTS][X] += 65
        if PLACES[COUNTS][X] > 200 then
          PLACES[COUNTS][X] = 10
          PLACES[COUNTS][Y] += 15
        end
      when DEALER
          PLACES[label][X] += DX
      when P1,P2,P3,P4,P5,P6,P7
          PLACES[label][Y] += DY
      else
        #
      end
    end
    return ret
  end

  def x(k)
    return PLACES[k][X]
  end
  def y(k)
    return PLACES[k][Y]
  end
end

class Placer
  include Constants
  def send( command=nil )
    ret = @comm.send( command ).strip.split(/\s+/).last
    # $stderr.puts "C:#{command}" if ret == '!' # for testing
    raise QUIT if ret == QUIT
    return ret
  end
  alias receive send

  def report_counts
    @places.reset(COUNTS)
    send( "d #{COUNTS}" )
      @counter.counts.split(/\s+/).each { |count|
        send("T #{@places.xy(COUNTS)} \"#{count}\" #{COUNTS}" )
      }
    @counter.updated = false # reset
  end

  def query( player, str )
    report_counts if @counter.updated

    response = QUIT
    if player == QUIT then
      response = receive()
    elsif player == CONFIGURATION then
      response = YES # Currently only one conf question: Dealer hits soft 17?
    elsif player == DEALER then
      case str
      when ACE+PEAK
	# Dealer peaks hole on ace?
	response = PEAK
      when TEN+PEAK
	# Dealer peaks hole on ten?
	response = PEAK
      when HIT
	# Dealer hits soft 17?
	response = HIT
      when INSURANCE
	# Dealer offers insurance? yes...
	response = INSURANCE
      else
	raise "What?"
      end
    else
      # PLAYERS
      case str
      when BET
	if @same_as then
	  response = @same_as
	  @same_as = nil if player == P7
	else
	  # Player's bet
	  send( "i #{@places.xy(player,false)} qu #{BET} 25A" )
	  send( "i #{@places.xy(player,false,-50,0)} ar #{BET} 25B" )
	  send( "i #{@places.xy(player,false,0,50)} di #{BET} 10A" )
	  send( "i #{@places.xy(player,false,-50,50)} ar #{BET} 10B" )
	  send( "i #{@places.xy(player,false,0,100)} ni #{BET} 5A" )
	  send( "i #{@places.xy(player,false,-50,100)} ar #{BET} 5B" )
	  if player != P1 then
	    send( "i #{@places.xy(player,false,0,150)} ch #{BET} 0A" )
	    send( "i #{@places.xy(player,false,-50,150)} ar #{BET} 0B" ) if player != P7
	  end
	  response = receive()
	  while response !~ /^\d+([AB])$/ do
	    response = receive()
	  end
	  @same_as = response if $1 == 'B'
	  send( "d #{BET}")
	end
	@players.push(player) if response.to_i > 0
      when INSURANCE
	# Player takes insurance?
        x = @places.x(player) - 25
	send( "i #{x} 105 i #{INSURANCE}" )
	response = receive()
	send( "d #{INSURANCE}")
      else
	# Player's choice
	if @skip_to && (@skip_to > player) || (@skip_to == DEALER) then
	  response = STAND
	else
	  @skip_to = nil
	  tags = ''
	  x = @places.x(player) - 28
          str.gsub!(SPLIT,'')	if @places.splited?(player) # THIS INTERFACE WILL NOT SUPPORT MULTIPLE SPLITS
          splitable = false
	  str.each_byte {|cc| c = cc.chr; send( "i #{x} 105 #{c} #{c}" ); x += 18; tags += ' '+c; splitable = true if c == SPLIT }
          send( "i 400 15 #{TRIALS} #{TRIALS}" )

          # Book says....
          xy = @places.xy(COUNTS,false)
          if splitable && (@ps || BJTables::splits?( (@pv/2).to_i, @dv )) then # Clunky?
            send("T #{xy} \"Split\" bs")
          elsif BJTables::doubles?( @pv, @dv, @ps ) then
            send("T #{xy} \"Double\" bs")
          elsif BJTables::hits?( @pv, @dv, @ps )
            send("T #{xy} \"Hit\" bs")
          else
            send("T #{xy} \"Stand\" bs")
          end

	  response = receive()
	  while !(str+TRIALS).include?(response) do
	    response = response.to_i.to_s if response=~/^[01234567]P$/
	    case response
	    when player
	      response = HIT
	    when DEALER
	      @skip_to = DEALER
	      response = STAND
	    when P1,P2,P3,P4,P5,P6,P7
	      if response > player then
	        @skip_to = response
	        response = STAND
	      else
	        response = receive()
	      end
	    else
	      response = receive()
	    end
	  end
          @places.split(player) if response == SPLIT
	  send("d#{tags} #{TRIALS}")
          send("d bs")
        end
      end
    end
    return response
  end

  def alert( type, str )
    case type
      when TRIALS
        y = 15 
        case str[0,1]
          when STAND	then y = 30
          when HIT	then y = 45
          when DOUBLE	then y = 60
          when SPLIT	then y = 75
        end
        send("T 415 #{y} \"#{str.gsub(/\s+/,"\t")}\" #{TRIALS}")
      when SHUFFLE
	send( "i #{@places.xy(SHUFFLE)} sh sh" )
	@counter.clear
        sleep( 6 * @rest )
	send( "d sh" )
      when START
	#
      when P1,P2,P3,P4,P5,P6,P7
        if str == SPLIT then
          @places.restore(type)
        else
	  send( "d v#{type}" )
          if @places.splited?(type) then
	    send( "T #{@places.sx-32} #{@places.sy+30} \"#{str}\" v#{type}" )
          else
	    send( "T #{@places.xy(type,false,-32,30)} \"#{str}\" v#{type}" )
          end
          @pv = str.to_i
          @ps = (str[-1,1] == '*')
        end
      when HOLE
	# Hole card revealing
	send( "d #{HL}" ) # hl denotes hole card
      when DEALER
	send( "d v#{type}" )
	send( "T #{@places.xy(type,false,25,-45)} \"#{str}\" v#{type}" )
      when FINISH
        @skip_to = nil
	@places.reset
        # Clear the table...
	@players.each {|p|
	  send( "d #{p}P v#{p}" )
	  sleep( @rest )
	}
	@players.clear
	send( "d #{DEALER}P v#{DEALER}" )
      else
	raise "What?"
    end
  end

  def action( player, card )
    send( "i #{@places.xy(player)} #{card} #{player}P" )
    if card != HL then
      @counter.count(card)
      @dv = (card.to_i > 0)? card.to_i: (card[0,1]=='a')? 11: 10	if player == DEALER
    end
    sleep( @rest )
  end

  def settle( player, str )
    w,b = str.split(/\s+/)
    x = @places.x(player)
    send( "d #{SETTLE}#{player}" )
    if player == DEALER then
      send( "T 10 10 \"#{str.sub(/\s/,' / ').gsub(/\.0\b/,'')}\" #{SETTLE}#{player}" )
    else
      send( "T #{x-30} 335 \"#{str.sub(/\s/,' / ').gsub(/\.0\b/,'')}\" #{SETTLE}#{player}" )
    end
  end


  def initialize( decks, comm, places, rest )
    @comm	= comm
    @places	= places
    @rest	= rest

    @counter	= Counts.new(decks)
    @skip_to	= nil
    @same_as	= nil
    @players	= []
  end

  def run(s2p,p2s)
    begin
      while command = s2p.gets.strip do
	  case command[0,1]
	  when QUERY
	    response = query( command[1,1], command[2,command.length] )
            p2s.puts response
	  when ALERT
	    alert( command[1,1], command[2,command.length] )
	  when ACTION
	    action( command[1,1], command[2,command.length] )
	  when SETTLE
	    settle( command[1,1], command[2,command.length] )
	  else
	    raise "What?"
          end
        end
    rescue Exception
      if $!.to_s != QUIT then
          $stderr.puts $!
          $stderr.puts $!.backtrace
      end
      p2s.puts QUIT
    ensure
      @comm.close
    end
  end
end
