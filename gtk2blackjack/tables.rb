module BJTables
  ### Split? ###
  SPL	= -1
  SPLIT	= []
  ##############
  SPLIT[1+SPL]		= [true, true,		true, true, true, 	true, true, true,	true, true]
  SPLIT[2+SPL]		= [false,true,		true, true, true,	true, false,false,	false,false]
  SPLIT[3+SPL]		= [false,false,		true, true, true,	true, false,false,	false,false]
  SPLIT[4+SPL]		= [false,false,		false,false,false,	false,false,false,	false,false]
  SPLIT[5+SPL]		= [false,false,		false,false,false,	false,false,false,	false,false]
  SPLIT[6+SPL]		= [true, true,		true, true, true, 	false,false,false,	false,false]
  SPLIT[7+SPL]		= [true, true,		true, true, true, 	true, false,false,	false,false]
  SPLIT[8+SPL]		= [true, true,		true, true, true, 	true, true, true, 	true, true]
  SPLIT[9+SPL]		= [true, true,		true, true, true, 	false,true, true, 	false,false]
  SPLIT[10+SPL]		= [false,false,		false,false,false,	false,false,false,	false,false]

  ### Soft hands ###
  SFT	= -12

  ### Soft Doubling ###
  SOFTD	= []
  ###################
  SOFTD[12+SFT]		= [false,false,		false,false,false,	false,false,false,	false,false]
  SOFTD[13+SFT]		= [false,false,		true, true, true, 	false,false,false,	false,false]
  SOFTD[14+SFT]		= [false,false,		true, true, true, 	false,false,false,	false,false]
  SOFTD[15+SFT]		= [false,false,		true, true, true, 	false,false,false,	false,false]
  SOFTD[16+SFT]		= [false,false,		true, true, true, 	false,false,false,	false,false]
  SOFTD[17+SFT]		= [true ,true ,		true, true, true, 	false,false,false,	false,false]
  SOFTD[18+SFT]		= [false,true ,		true, true, true, 	false,false,false,	false,false]
  SOFTD[19+SFT]		= [false,false,		false,false,true, 	false,false,false,	false,false]
  SOFTD[20+SFT]		= [false,false,		false,false,false,	false,false,false,	false,false]
  SOFTD[21+SFT]		= [false,false,		false,false,false,	false,false,false,	false,false]

  ### Soft Hiting ###
  SOFTH	= []
  ###################
  SOFTH[12+SFT]		= [true, true, 		true, true, true, 	true, true, true, 	true, true]
  SOFTH[13+SFT]		= [true, true, 		true, true, true, 	true, true, true, 	true, true]
  SOFTH[14+SFT]		= [true, true, 		true, true, true, 	true, true, true, 	true, true]
  SOFTH[15+SFT]		= [true, true, 		true, true, true, 	true, true, true, 	true, true]
  SOFTH[16+SFT]		= [true, true, 		true, true, true, 	true, true, true, 	true, true]
  SOFTH[17+SFT]		= [true, true, 		true, true, true, 	true, true, true, 	true, true]
  SOFTH[18+SFT]		= [false,false,		false,false,false,	false,false,true, 	true, false]
  SOFTH[19+SFT]		= [false,false,		false,false,false,	false,false,false,	false,false]
  SOFTH[20+SFT]		= [false,false,		false,false,false,	false,false,false,	false,false]
  SOFTH[21+SFT]		= [false,false,		false,false,false,	false,false,false,	false,false]

  ### Double? ###
  DBL	= -4
  DOUBLE= []
  ###############
  DOUBLE[4+DBL]		= [false,false,		false,false,false,	false,false,false,	false,false]
  DOUBLE[5+DBL]		= [false,false,		false,false,false,	false,false,false,	false,false]
  DOUBLE[6+DBL]		= [false,false,		false,false,false,	false,false,false,	false,false]
  DOUBLE[7+DBL]		= [false,false,		false,false,false,	false,false,false,	false,false]
  DOUBLE[8+DBL]		= [false,false,		false,true, true, 	false,false,false,	false,false]
  DOUBLE[9+DBL]		= [true, true, 		true, true, true, 	false,false,false,	false,false]
  DOUBLE[10+DBL]	= [true, true, 		true, true, true,	true, true, true, 	false,false]
  DOUBLE[11+DBL]	= [true, true, 		true, true, true,	true, true, true, 	true, true]
  DOUBLE[12+DBL]	= [false,false,		false,false,false,	false,false,false,	false,false]
  DOUBLE[13+DBL]	= [false,false,		false,false,false,	false,false,false,	false,false]
  DOUBLE[14+DBL]	= [false,false,		false,false,false,	false,false,false,	false,false]
  DOUBLE[15+DBL]	= [false,false,		false,false,false,	false,false,false,	false,false]
  DOUBLE[16+DBL]	= [false,false,		false,false,false,	false,false,false,	false,false]
  DOUBLE[17+DBL]	= [false,false,		false,false,false,	false,false,false,	false,false]
  DOUBLE[18+DBL]	= [false,false,		false,false,false,	false,false,false,	false,false]
  DOUBLE[19+DBL]	= [false,false,		false,false,false,	false,false,false,	false,false]
  DOUBLE[20+DBL]	= [false,false,		false,false,false,	false,false,false,	false,false]
  DOUBLE[21+DBL]	= [false,false,		false,false,false,	false,false,false,	false,false]

  ### Hit? ###
  HT	= -4
  HIT	= []
  ############
  HIT[4+HT]	= [true, true, 		true, true, true, 	true, true, true, 	true, true]
  HIT[5+HT]	= [true, true, 		true, true, true,	true, true, true, 	true, true]
  HIT[6+HT]	= [true, true, 		true, true, true,	true, true, true, 	true, true]
  HIT[7+HT]	= [true, true, 		true, true, true, 	true, true, true, 	true, true]
  HIT[8+HT]	= [true, true, 		true, true, true, 	true, true, true, 	true, true]
  HIT[9+HT]	= [true, true, 		true, true, true, 	true, true, true, 	true, true]
  HIT[10+HT]	= [true, true, 		true, true, true, 	true, true, true, 	true, true]
  HIT[11+HT]	= [true, true, 		true, true, true, 	true, true, true, 	true, true]
  HIT[12+HT]	= [true, true, 		false,false,false,	true, true, true, 	true, true]
  HIT[13+HT]	= [false,false,		false,false,false,	true, true, true, 	true, true]
  HIT[14+HT]	= [false,false,		false,false,false,	true, true, true, 	true, true]
  HIT[15+HT]	= [false,false,		false,false,false,	true, true, true, 	true, true]
  HIT[16+HT]	= [false,false,		false,false,false,	true, true, true, 	true, true]
  HIT[17+HT]	= [false,false,		false,false,false,	false,false,false,	false,false]
  HIT[18+HT]	= [false,false,		false,false,false,	false,false,false,	false,false]
  HIT[19+HT]	= [false,false,		false,false,false,	false,false,false,	false,false]
  HIT[20+HT]	= [false,false,		false,false,false,	false,false,false,	false,false]
  HIT[21+HT]	= [false,false,		false,false,false,	false,false,false,	false,false]

  def BJTables.splits?(pv,dv)
    # pv must be single card value, ACE-ACE => 1, 2-2 => 2, ..., X-X => 10.
    return (SPLIT[pv+SPL][dv-2])
  end

  def BJTables.doubles?(pv,dv,soft=false)
    # ...but here, pv is bj_value of the hand
    return (soft)?  (SOFTD[pv+SFT][dv-2]): (DOUBLE[pv+DBL][dv-2])
  end

  def BJTables.hits?(pv,dv,soft=false)
    return (soft)? (SOFTH[pv+SFT][dv-2]): (HIT[pv+HT][dv-2])
  end
end
