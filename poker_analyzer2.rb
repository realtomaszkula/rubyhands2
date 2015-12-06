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
 	highcard(cards, uniqness)
 elsif (uniqness == 4)
 	onepair(cards, uniqness)
 elsif 	(uniqness == 2)
 	quads(cards, uniqness)
 else
 	fullhouse(cards, uniqness) if (card_counting.min == 2 && card_counting.max == 3)
 	trips(cards, uniqness)	if (card_counting.min == 1 && card_counting.max == 3)
 	twopair(cards, uniqness)	if (card_counting.count(2) == 4)
end

def quads (cards, uniqness)
	2.times do |x| 
	return 7000 + uniqness[x] if (cards.count(uniqness[x]) == 4) 
	end
end

def fullhouse (cards, uniqness)
	3.times do |x| 
	return 6000 + uniqness[x] if (cards.count(uniqness[x]) == 3) 
	end
end

def trips (cards, uniqness)
	3.times do |x| 
	return 3000 + uniqness[x] if (cards.count(uniqness[x]) == 3) 
	end
end
	
def twopair (cards, uniqness)
	pairs = []
	3.times do |x| 	
		pairs << uniqness[x] if (cards.count(uniqness[x]) == 2) 
	end

	kicker = cards.keep_if {|x| (x != pairs.min) && (x != pairs.max) }

	 1000 + pairs.max * 100 + pairs.min * 10 + kicker[0]
end


def onepair (cards, uniqness)
	pair = 0
	kicker_array = []

	4.times do |x|
	pair = uniqness[x] if (cards.count(uniqness[x]) == 2) 
	end

	kicker_array = cards.delete_if{|x| x == pair}
	kicker_array.sort!


	(1000 * pair + 100 * kicker_array[0] + 10 * kicker_array[1] + kicker_array[2]) / 10
end


def highcard (cards)
	sum = 0.0
	val = 10000
	cards.each do
		|x| sum += x * val	
		val /= 10
	end
	sum = sum / 1000
end
