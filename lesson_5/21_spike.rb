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

  def self.pluralize(num)
    num > 1 ? 's' : ''
  end
end

class Competitor
  attr_reader :hand

  def initialize(target_value)
    @hand = Hand.new(target_value)
  end

  def draw(deck, number = 1)
    hand.draw(deck, number)
  end

  def show_hand
    Language.joinor(hand.cards, ', ', 'and')
  end

  def last_drawn_card
    hand.cards[-1]
  end

  def hit(deck)
    hand.draw(deck)
  end

  def busted?
    hand.total_score > hand.target_value
  end
end

class Dealer < Competitor
  def partial_show_hand
    facedown_cards = hand.cards.size - 1
    "#{last_drawn_card} and #{facedown_cards} other card" +
      Language.pluralize(facedown_cards)
  end
end

class CardSet
  attr_accessor :cards

  def initialize
    @cards = []
  end

  def shuffle!
    cards.shuffle!
  end
end

class Hand < CardSet
  attr_accessor :target_value

  def initialize(target_value = 21)
    super()
    @target_value = target_value
  end

  def draw(deck, number = 1)
    number.times { cards << deck.cards.pop }
  end

  def total_score
    score = cards.map(&:score).sum # total card totals
    cards.map(&:rank).count(:ace).times do
      if target_value - score >= 10 # option to add 10 for each Ace
        score += 10
      end
    end
    score
  end

  def last_drawn_card
    cards[-1]
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
    shuffle!
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
    raise(ArgumentError, "card has an illegal rank") if value.nil?
    value
  end

  def to_s
    "the #{rank.to_s.capitalize} of #{suit.to_s.capitalize}"
  end
end

class TwentyOneGame
  TARGET_VALUE = 21

  def initialize
    @player = Competitor.new(TARGET_VALUE)
    @dealer = Dealer.new(TARGET_VALUE)
    @deck = Deck.new
    @discard = Discard.new
  end

  def start
    setup
    display_welcome_message
    player_turn
    if player.busted?
      puts "You bust!"
    else
      dealer_turn
      if dealer.busted?
        puts "Dealer busts!"
      else
        display_final_game_state
      end
    end
    display_winner
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

  def player_turn
    display_game_state
    loop do
      choice = choose_play
      if choice == 'h'
        player.hit(deck)
        puts "You drew #{player.last_drawn_card}."
        puts "Your score is #{player.hand.total_score}."
        break if player.busted?
      elsif choice == 's'
        break
      end
    end
  end

  def display_game_state
    puts "You have #{player.show_hand}"
    puts "The dealer has #{dealer.partial_show_hand}"
    puts "Your score is #{player.hand.total_score}."
  end

  def display_final_game_state
    puts "You have #{player.show_hand}"
    puts "Your score is #{player.hand.total_score}."
    puts "The dealer has #{dealer.show_hand}"
    puts "The dealer's score is #{dealer.hand.total_score}."
  end

  def choose_play
    puts "Would you like to (h)it or (s)tay?"
    choice = nil
    loop do
      choice = gets.chomp[0].downcase
      break if %w(s h).include?(choice)
      puts "Please enter h to hit or s to stay."
    end
    choice
  end

  def dealer_turn
    while dealer.hand.total_score < (dealer.hand.target_value - 4)
      dealer.hit(deck)
      puts "Dealer hits!"
    end
  end

  def display_winner
    case determine_winner
    when :player then puts "You win!"
    when :dealer then puts "Dealer wins!"
    when :tie then puts "Tie game!"
    end
  end

  def determine_winner
    if player.busted?
      :dealer
    elsif dealer.busted?
      :player
    else
      case player.hand <=> dealer.hand
      when 1 then :player
      when 0 then :tie
      when -1 then :dealer
      end
    end
  end

  def display_goodbye_message
    puts "Thanks for playing #{TARGET_VALUE}. Goodbye!"
  end
end

TwentyOneGame.new.start
