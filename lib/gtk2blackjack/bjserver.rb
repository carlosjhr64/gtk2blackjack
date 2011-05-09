require 'gtk2blackjack/deck'
require 'gtk2blackjack/hand'
require 'gtk2blackjack/player'
require 'gtk2blackjack/constants'
require 'gtk2blackjack/tables'

class BJServer
  include Constants

  def initialize(decks,input=$stdin,output=$stdout)
    @deck = Deck.new(decks)
    @input = input
    @output = output
    @players = []
    0.upto(7) { |n|
      player = Player.new
      player.name = n.to_s # 0,1,2,3...
      player.hands = Hand.new
      player.bank = 0.0
      @players.push(player)
    }
    @dealer = @players.shift

    @trials = false
    @first_choice = nil
  end

  def notify(command)
    @output.puts command 
    @output.flush
  end

  def ask(command)
    notify(command)
    response = @input.gets.strip
    exit if response == 'q'
    return response
  end

  def configure
    @dealer_hits_soft = (ask( QUERY + CONFIGURATION ) == YES) # Dealer hits soft 17?
  end

  def round(x)
    return( (x * 100.0 + 0.5).to_i / 100.0 )
  end

  def stablish_bets
    @actives = 0
    # STABLISH BETS
    @dealer.hands.clear
    @players.each {|player|
      player.hands.clear
      player.hands.bet = ask( QUERY + player.name + BET ).to_f
      @actives += 1 if player.hands.bet > 0.0
    }
  end

  def disbursement_of_cards
    # INITIAL DISBURSEMENT OF CARDS
    hole = false
    @hole_card = nil
    2.times do
      @players.each{|player|
        next	if player.hands.bet == 0.0
        card = @deck.draw
        player.hands.hits( card )
        notify( ACTION + player.name + card )	if !@trials
      }
      if hole then
        @hole_card = @deck.draw
        notify( ACTION + DEALER + HL )	if !@trials # hole card denoted as hl
      else
        card = @deck.draw
        @dealer.hands.hits( card )
        notify( ACTION + DEALER +  card )	if !@trials
        hole = true
      end
    end
    @players.each {|player| @actives -= 1 if player.hands.blackjack }
  end

  def peaking_and_insurance
    @peaked_for_ace = false
    @peaked_for_ten = false
    # Does dealer peak or offers insurance?
    if @dealer.hands.bj_value == 10 then
      choice = ask( QUERY + DEALER + TEN + PEAK ) # does dealer peak on ten?
      if choice == PEAK then
        @peaked_for_ace = true
        if @hole_card[0,1]=='a' then
          @dealer.hands.hits( @hole_card )
          notify( ALERT + HOLE )	if !@trials
          notify( ACTION + DEALER + @hole_card )	if !@trials
        end
      end
    elsif @dealer.hands.aces then
      choice = ask( QUERY + DEALER + INSURANCE ) # does dealer offer insurance?
      if choice == INSURANCE then
        @players.each { |player|
          next if player.hands.bet == 0.0
          choice = ask( QUERY + player.name + INSURANCE ) # does player take insurance?
          if choice == INSURANCE then
            player.hands.insured = true
          end
        }
      end
      choice = ask( QUERY + DEALER + ACE + PEAK ) # does dealer peak on ace?
      if choice == PEAK then
        @peaked_for_ten = true
        if 'xjqk'.include?(@hole_card[0,1]) then
          @dealer.hands.hits( @hole_card )
          notify( ALERT + HOLE )	if !@trials
          notify( ACTION + DEALER + @hole_card )	if !@trials
        end
      end
    end
  end

  def basic_strategy(hands)
    choice = STAND
    pv = hands.bj_value
    sf = hands.soft
    dv = @dealer.hands.bj_value
    if (pv < 19) && hands.splitable && (hands.aces || BJTables.splits?(pv/2,dv)) then
      choice = SPLIT
    elsif BJTables.doubles?(pv,dv,sf) then
      choice = DOUBLE
    elsif BJTables.hits?(pv,dv,sf) then
      choice = HIT
    end
    return choice
  end

  def choice_is(name,hands)
    choice = nil
    if @trials then
      if @first_choice then
        choice = @first_choice
        @first_choice = nil
      else
        choice = basic_strategy(hands)
      end
    else
      choice = ask( QUERY + name + STAND + HIT + DOUBLE + ((hands.splitable)? SPLIT: '') )
    end
    return choice
  end

  def player_choices(player)
    hands = player.hands
    if hands.bet != 0.0 then
      while hands do
        if hands.bj_value != 21 then
          notify( ALERT + player.name + hands.bj_value.to_s + ((hands.soft)? '*': '') )	if !@trials
          while choice = choice_is(player.name,hands) do
            if choice == TRIALS then
              self.trials(player,hands.splitable)
            else
              break if choice == STAND
              if choice == SPLIT && hands.splitable then # second part for tainted safety / sanity check
                hands.split; @actives += 1;
              else
                card = @deck.draw; hands.hits( card )
                notify( ACTION + player.name + card )	if !@trials
              end
              notify( ALERT + player.name + hands.bj_value.to_s + ((hands.soft)? '*': '') )	if !@trials
              if choice == DOUBLE then
                hands.bet += hands.bet
                break
              end
              @actives -= 1 if hands.bj_value > 21
              break if hands.bj_value > 20
            end
          end
        end 
        notify( ALERT + player.name + SPLIT ) if (hands = hands.next) && !@trials # Note the side-effect of assignment on hands
      end
    end
  end

  def dealer_reveals
    # DEALER REVEALS
    notify( ALERT + HOLE )	if !@trials
    @dealer.hands.hits( @hole_card )
    notify( ACTION + DEALER + @hole_card )	if !@trials
  end

  def dealer_hits
    # DEALER HITS
    # might be soft
    while @dealer.hands.bj_value < 17 do
      card = @deck.draw
      @dealer.hands.hits( card )
      notify( ACTION + DEALER + card )	if !@trials
    end
    # dealer hits soft-17?
    if @dealer.hands.soft && @dealer.hands.bj_value == 17 then
      if @dealer_hits_soft then
        card = @deck.draw
        @dealer.hands.hits( card )
        notify( ACTION + DEALER + card )	if !@trials
      end
    end
    # guaranteed hard
    while @dealer.hands.bj_value < 17 do
      card = @deck.draw
      @dealer.hands.hits( card )
      notify( ACTION + DEALER + card )	if !@trials
    end
  end

  def settlements
    # SETTLEMENTS
    dealer_win = 0.0
    dealer_got = @dealer.hands.bj_value
    @players.each { |player|
      wins = 0.0
      hands = player.hands
      next if hands.bet == 0.0
      # insurance settlements
      if hands.insured then
        if @dealer.hands.blackjack then
          wins += hands.bet
        else
          wins -= hands.bet/2.0
        end
      end
      while hands do
        player_got = hands.bj_value
        win = hands.bet # assume player won
        if hands.blackjack then
          if @dealer.hands.blackjack then
            win = 0.0
          else
            win = win*1.5
          end
        elsif player_got > 21 then
          win = -win
        elsif dealer_got < 22 then
          if @dealer.hands.blackjack || (player_got < dealer_got) then
            win = -win
          elsif player_got == dealer_got then
            win = 0.0
          end
        end
        wins += win
        hands = hands.next
      end
      dealer_win -= wins
      player.bank += wins
      notify( SETTLE + player.name + "#{wins} #{player.bank}" )	if !@trials
    }
    @dealer.bank += dealer_win
    notify( SETTLE + DEALER + "#{dealer_win} #{@dealer.bank}" )	if !@trials
  end

  def trials(player,splitable)
    @deck.store(@hole_card,@peaked_for_ace,@peaked_for_ten) # store the current deck

    @trials = true
    player_bank = player.bank
    player_wins = Hash.new(0.0)
    dealer_bank = @dealer.bank
    dealer_wins = Hash.new(0.0)
    index = @deck.i # bookmark the current location in the deck

    now = Time.now
    count = 0
    while Time.now - now < 3.0  do
      count += 1
      @hole_card = @deck.shuffle(index) # shuffle remaining cards
      [STAND,DOUBLE,HIT,SPLIT].each { |first_choice|
        next if first_choice == SPLIT && !splitable
        @players.each{|p| p.store}
        @dealer.store
        actives = @actives
        trigger = false
        @players.each { |player2|
          if trigger  then
            player_choices(player2)
          elsif player2 == player then
            trigger = true
            @first_choice = first_choice
            player_choices(player2)
          end
        }
        dealer_reveals
        dealer_hits if @actives > 0
        settlements
        player_wins[first_choice] += player.bank - player_bank
        dealer_wins[first_choice] += @dealer.bank - dealer_bank
        @players.each{|p| p.restore}
        @dealer.restore
        @actives = actives
        @deck.i = index # go back to the point in the deck where the trial started
      }
    end

    @trials = false; pw = player_wins[STAND]; dw = dealer_wins[STAND]; pc = STAND; dc = STAND
    [STAND,DOUBLE,HIT,SPLIT].each{|first_choice|
      next if first_choice == SPLIT && !splitable
      notify( ALERT + TRIALS + "#{first_choice} #{round(player_wins[first_choice]/count.to_f)} #{round(dealer_wins[first_choice]/count.to_f)}")
      ((pc = first_choice) && (pw = player_wins[first_choice]))	if player_wins[first_choice] > pw
      ((dc = first_choice) && (dw = dealer_wins[first_choice]))	if dealer_wins[first_choice] < dw
    }
    notify( ALERT + TRIALS + "N #{count} #{pc}/#{dc}")

    @hole_card = @deck.restore # restore deck to that before trials.
  end

  def run
    configure
    while true do
      # SHUFFLE
      notify( ALERT + SHUFFLE )	if !@trials
      @deck.shuffle

      while @deck.remaining > 25 do
        notify( ALERT + START )	if !@trials
        stablish_bets
	disbursement_of_cards
	peaking_and_insurance

        if !@dealer.hands.blackjack then
          # PLAYER CHOICES
          @players.each { |player|
            player_choices(player)
          }
          dealer_reveals
          dealer_hits if @actives > 0
        end
        notify( ALERT + DEALER + @dealer.hands.bj_value.to_s )	if !@trials
        settlements

        ask( QUERY + QUIT )
        notify( ALERT + FINISH )	if !@trials
      end

    end
  end
end
