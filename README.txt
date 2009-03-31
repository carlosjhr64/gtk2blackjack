Ruby-Gnome BlackJack

A seven player game of 21.
With running counts.
And Monte-Carlo testing.

Betting:
Click on the coin to bet 25, 10, or 5 units for each player.
Click on the baby penguin to not bet.
Click on the arrow to bet the same for all remaining players.

'S' => Stand
'H' => Hit
'D' => Double
'P' => sPlit

'R':
Click 'R' to get the Monte-Carlo suggested play.
'N' line shows the total number of plays and the individual/table best choice.
's' line shows the resulting payoff for the player and the table if player chooses to stand.
'h' ditto for the choice to hit.
etc...

The running counts are shown on the top-left of the playing field.
A's => total Aces seen.
2's => total Twos seen.
3-6 => total cards seen from 3 to 6.
5's => total Fives seen.
7's => total Senves seen.
8-9 => total cards seen which were an 8 or a nine.
X's => total ten value cards seen.
And some formula totals:
D   => The adjusted ten count
P   => A complicated but inaccurate probablity of winning :)
C   => Plus/Minus count
Finally, what the basic strategy says to do.

A possible problem...
Ruby-Gnome BlackJack uses three pipe communicating ruby processes.
If you have multiple ruby versions, one of processes may be running the wrong ruby.
To fix that, set all system ruby calls in /<path to>/gems/gtk2blackjack-0.0.0/bin/gtk2blackjack to the correct ruby.
For example:
"/usr/bin/ruby ./bin/bjserver #{decks}" instead of "/usr/bin/env ruby ./bin/bjserver #{decks}"
and
"/usr/bin/ruby ./bin/gtk2fixed_client" instead of "/usr/bin/env ruby ./bin/gtk2fixed_client"
