lines = File.readlines(ARGV[0]);

### making an array of hands for each player
player_one = []
player_two = []

lines.each do |x|
 	z = x.to_s.split.join
 	player_one << z[0..9]
 	player_two << z[10..19]
end

### spliting the hand into two arrays, one for suits and one for handvalue
figures_and_colors = player_one[0].split("")

cards = []
suits = []

10.times do |x|
	(x % 2 == 0) ? cards << figures_and_colors[x] : suits << figures_and_colors[x]
end

### converting J-A into 11-14, converting to fixnum and sorting

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

### hand strength
handstr = fixnum.new

### flushes straights and straightflushes


def straight(cards)
	return 4000 + cards[4] if (cards[0] == cards[1] - 1 && cards[1] == cards[2] - 1 && cards[2] == cards[3] - 1 && cards[3] == cards[4] - 1) 
	return 4000 + cards[3] if (cards[4] == 14 && cards[0] == 2 && cards[1] == 3 && cards[2] == 4 && cards[3] == 5)
	false
end

def flush(cards)
	return 5000 + cards[4] if (cards.uniq.length == 1)
	false
end

def straightflush(suits, cards)
	return have_flush(suits) + have_straight(cards) if have_flush(suits) && have_straight(cards)
	false
end

### 
uniqness = cards.uniq
card_counting = []

5.times do |x|
card_counting[x] = cards.count(cards[x])
end


 if (uniqness == 5)
 	highcard(cards)
 elsif 	(uniqness == 2)
 	quads(cards)
 else
 	fullhouse(cards) if (card_counting.min == 2 && card_counting.max == 3)
 	trips(cards)	if (card_counting.min == 1 && card_counting.max == 3)
 	twopair(cards)	if (card_counting.count(2) == 4)
 	pair(cards)	if (card_counting.count(2) == 2)
end
