module Language
  def self.joinor(arr, punct = ', ', conjunction = 'or')
    speech = ''
    case arr.length
    when 0 then speech = ''
    when 1 then speech = arr[0].to_s
    when 2 then speech = "#{arr[0]} #{conjunction} #{arr[1]}"
    else
      arr.each_with_index do |el, i|
        speech << (i == arr.size - 1 ? "#{conjunction} #{el}" : "#{el}#{punct}")
      end
    end
    speech
  end
end

class Competitor
  attr_reader :hand

  def initialize
    @hand = Hand.new
  end
  
  def draw(deck, number = 1)
    @hand.draw(deck, number)
  end
  
  def take_turn(deck)
    puts "would you like to hit or stay?"
  end
  
  def show_hand
    Language.joinor(hand.cards, ', the ', 'and the')
  end
  
  def hit(deck)
  end
  
  def stay(deck)
  end
end

class Dealer < Competitor
  def take_turn
  end
  
  def partial_show_hand
    "the #{hand.cards[0]} and #{hand.cards.size - 1} other cards"
  end
end

class CardSet
  attr_accessor :cards

  def initialize
    @cards = []
  end
end

class Hand < CardSet
  def draw(deck, number = 1)
    number.times { self.cards << deck.cards.pop }
  end
  
  def total_score(target_val)
    score = cards.map(&:score).sum # total card totals
    cards.map(&:rank).count(:ace).times do
      if target_val - score >= 10# option to add 10 for each Ace
        score += 10
      end
    end
    score
  end
  
  def <=>(other)
    total_score <=> other.total_score 
  end
end

class Deck < CardSet
  def initialize
    super()
    ranks = [2, 3, 4, 5, 6, 7, 8, 9, 10, :jack, :queen, :king, :ace]
    suits = [:clubs, :diamonds, :hearts, :spades]
    ranks.each do |rank|
      suits.each do |suit|
        cards << Card.new(rank, suit)
      end
    end
    shuffle
  end
  
  def shuffle
    cards.shuffle!
  end
end

class Discard < CardSet
end

class Card
  DEFAULT_CARD_VALUES = { 2 => 2, 3 => 3, 4 => 4, 5 => 5, 6 => 6, 7 => 7,
                          8 => 8, 9 => 9, 10 => 10, :jack => 10, :queen => 10,
                          :king => 10, :ace => 1 }

  attr_reader :rank, :suit, :score

  def initialize(rank, suit, scoring = DEFAULT_CARD_VALUES)
    @rank = rank
    @suit = suit
    @score = calculate_score(scoring)
  end
  
  def calculate_score(scoring)
    value = scoring[rank]
    if value == nil
      raise ArgumentError.new("card has an illegal rank")
    else
      value
    end
  end
  
  def to_s
    "#{rank.to_s.capitalize} of #{suit.to_s.capitalize}"
  end
end

class TwentyOneGame
  TARGET_VALUE = 21
  
  def initialize
    @player = Competitor.new
    @dealer = Dealer.new
    @deck = Deck.new
    @discard = Discard.new
  end
  
  def start
    setup
    display_welcome_message
    display_game_state
    # player_turn
    # dealer_turn
    # determine_winner
    # display_winner
    display_goodbye_message
  end
  
  private
  
  attr_reader :player, :dealer, :deck, :discard
  
  def setup
    player.draw(deck, 2)
    dealer.draw(deck, 2)
  end
  
  def display_welcome_message
    puts "Welcome to #{TARGET_VALUE}!"
  end
  
  def display_game_state
    puts "You have the #{player.show_hand}"
    puts "The dealer has #{dealer.partial_show_hand}"
    puts "Your score is #{player.hand.total_score(TARGET_VALUE)}."
  end
  
  def display_goodbye_message
    puts "Thanks for playing #{TARGET_VALUE}. Goodbye!"
  end
end

TwentyOneGame.new.start