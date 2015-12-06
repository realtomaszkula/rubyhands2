$highcard_count = 0
$one_pair_count = 0
$two_pair_count = 0
$trips_count = 0
$fullhouse_count = 0
$quads_count = 0
$flush_count = 0
$straight_count = 0
$straight_flush_count = 0

def preparing_the_hand(hand)
	### spliting the hand into two arrays, one for suits and one for handvalue
	figures_and_colors = hand.split("")
	
	cards = []
	suits = []
	
	10.times do |x|
		(x % 2 == 0) ? cards << figures_and_colors[x] : suits << figures_and_colors[x]
	end
	
	### converting T-A into 11-14, converting to fixnum and sorting
	
	cards.collect! do |x|
		if x == "T"
			x = "10"
		elsif x == "J"
			x = "11"
		elsif x == "Q"
			x = "12"
		elsif x == "K"
			x = "13"
		elsif x == "A"
			x = "14"
		else x = x
		end
	
		x = x.to_i
	end
	
	cards.sort!

	hand_strength = 0
	hand_strength = straightflush(suits,cards)
	hand_strength = checkforuniq(cards) if (hand_strength == 0)

	hand_strength
end
### flushes straights and straightflushes
def straightflush(suits, cards)
	x = flush(suits, cards)	
	y = straight(suits, cards) 

	if (x > 0 && y > 0)
		$straight_flush_count += 1
		return x + y
	elsif (x > 0 && y == 0)
		$flush_count += 1
		return x
	elsif( y > 0 && x == 0)
		$straight_count += 1 
		return y
	end
	0
end

def straight(suits, cards)
	if ((cards[0] == cards[1] - 1 )&& (cards[1] == cards[2] - 1) && (cards[2] == cards[3] - 1) && (cards[3] == cards[4] - 1)) 
		return 4000 + cards[4] 
	end
	0
end

def flush(suits,cards)
	if (suits.uniq.length == 1)
		return 5000 + cards[4] 
	end
	0
end

### paired hands and ace highs
def checkforuniq (cards)
	uniqness = cards.uniq
	result = 0

	card_counting = []
	5.times do |x|
	card_counting[x] = cards.count(cards[x])
	end
	
	if (uniqness.length == 5)
	 	result = highcard(cards)
	elsif (uniqness.length == 4)
	 	result = onepair(cards, uniqness)
	elsif (uniqness.length == 3)
	 	if (card_counting.min == 1 && card_counting.max == 3)
	 		result = trips(cards, uniqness)	
	 	else (card_counting.count(2) == 4)
	 		result = twopair(cards, uniqness)	
	 	end 
	elsif (uniqness.length == 2)
		if (card_counting.max  == 4) 
	 		result = quads(cards, uniqness)
	 	else
	 		result = fullhouse(cards, uniqness)
	 	end
	end

	result
end

def quads (cards, uniqness)
	# $quads_count += 1
	2.times do |x| 
	return 7000 + uniqness[x] if (cards.count(uniqness[x]) == 4) 
	end
end

def fullhouse (cards, uniqness)
	$fullhouse_count += 1
	2.times do |x| 
	return 6000 + uniqness[x] if (cards.count(uniqness[x]) == 3) 
	end
end

def trips (cards, uniqness)
	$trips_count += 1
	3.times do |x| 
	return 3000 + uniqness[x] if (cards.count(uniqness[x]) == 3) 
	end
end
	
def twopair (cards, uniqness)
	$two_pair_count += 1
	pairs = []
	3.times do |x| 	
		pairs << uniqness[x] if (cards.count(uniqness[x]) == 2) 
	end

	kicker = cards.keep_if {|x| (x != pairs.min) && (x != pairs.max) }
	1000 + (pairs.max * 100) + (pairs.min * 10) + kicker[0]
end


def onepair (cards, uniqness)
	$one_pair_count += 1
	pair = 0
	kicker_array = []

	5.times do |x|
	pair = uniqness[x] if (cards.count(uniqness[x]) == 2) 
	end

	kicker_array = cards.delete_if{|x| x == pair}
	kicker_array.sort!

	(1000 * pair + 100 * kicker_array[0] + 10 * kicker_array[1] + kicker_array[2]) / 10
end


def highcard (cards)
	$highcard_count += 1
	cards.reverse!

	sum = 0.0
	val = 10000
	cards.each do
		|x| sum += x * val	
		val /= 10
	end

	sum = sum / 1000
end




lines = File.readlines(ARGV[0]);

### making an array of hands for each player
player_one = []
player_two = []

lines.each do |x|
 	z = x.to_s.split.join
 	player_one << z[0..9]
 	player_two << z[10..19]
end

### check hand strength
player_one_wins = 0
player_two_wins = 0

	1000.times do |x|
		player_one_hand_rank = preparing_the_hand(player_one[x]).to_f
		player_two_hand_rank = preparing_the_hand(player_two[x]).to_f

		(player_one_hand_rank > player_two_hand_rank) ? (player_one_wins += 1) : (player_two_wins += 1)
	end

puts player_one_wins
puts player_two_wins

puts "highcard = #{$highcard_count}" 
puts "one pair = #{$one_pair_count}"
puts "two pair = #{$two_pair_count}" 
puts "trips = #{$trips_count}"
puts "fullhouse = #{$fullhouse_count}"
puts "quads = #{$quads_count}"
puts "flush = #{$flush_count}"
puts "straight = #{$straight_count}"
puts "straightflush = #{$straight_flush_count}"

