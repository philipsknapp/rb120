module FrenchSuits
  RANKS = [2, 3, 4, 5, 6, 7, 8, 9, 10, :jack, :queen, :king, :ace].freeze
  SUITS = [:clubs, :diamonds, :hearts, :spades].freeze
end

module CardScores
  def total_score
    total = cards.map { |card| score(card.rank) }.sum
    cards.count { |card| card.rank == :ace }.times do
      total += 10 if total <= (21 - 10)
    end
    total
  end

  def score(rank)
    case rank
    when 2..10 then rank
    when :jack, :queen, :king then 10
    when :ace then 1
    end
  end
end

class Card
  attr_reader :rank, :suit

  def initialize(rank, suit)
    @rank = rank
    @suit = suit
  end

  def to_s
    "the #{rank.to_s.capitalize} of #{suit.capitalize}"
  end
end

class CardSet
  include FrenchSuits

  attr_reader :cards

  def initialize
    @cards = []
  end

  def <<(other)
    cards << other
  end
end

class Deck < CardSet
  def initialize
    super
    reset
  end

  def deal
    reset if cards.empty?
    cards.pop
  end

  def reset
    RANKS.each do |rank|
      SUITS.each do |suit|
        cards << Card.new(rank, suit)
      end
    end
    cards.shuffle!
  end
end

class Hand < CardSet
  include Comparable, CardScores

  def <=>(other)
    total_score <=> other.total_score
  end
end

class Player
  attr_reader :hand

  def initialize
    @hand = Hand.new
  end

  def hit(card)
    puts "You hit! You draw #{card}."
    hand << card
  end

  def busted?
    hand.total_score > 21
  end

  def show_cards
    puts hand.cards
  end
end

class Dealer < Player
  def show_one_card
    puts "#{hand.cards[0]} and #{hand.cards.size - 1} other cards."
  end

  def hit(card)
    puts "Dealer hits!"
    hand << card
  end
end

class TwentyOneGame
  def initialize
    @deck = Deck.new
    @player = Player.new
    @dealer = Dealer.new
    @winner = nil
  end

  def play
    setup
    player_turn
    dealer_turn unless player.busted?
    display_busts
    decide_winner
    display_final_hands unless player.busted? || dealer.busted?
    display_winner
  end

  private

  attr_reader :deck, :player, :dealer
  attr_accessor :winner

  def setup
    2.times do
      [player, dealer].each do |participant|
        participant.hand << deck.deal
      end
    end
  end

  def player_turn
    loop do
      display_hands
      hit_or_stay = get_char_choice("Will you (h)it or (s)tay?", %w(h s))
      break if hit_or_stay == 's'
      clear
      player.hit(deck.deal)
      break if player.busted?
    end
  end

  def dealer_turn
    clear
    puts "Dealer's turn!"
    loop do
      display_dealer_hand
      if dealer.hand.total_score >= 17
        puts "Dealer stays!" unless dealer.busted?
        break
      end
      dealer.hit(deck.deal)
    end
  end

  def display_busts
    clear
    if player.busted?
      puts "You bust!"
    elsif dealer.busted?
      puts "Dealer busts!"
    end
  end

  def decide_winner
    self.winner = if player.busted?
                    :dealer
                  elsif dealer.busted?
                    :player
                  else
                    compare_hands(player, dealer)
                  end
  end

  def display_winner
    case winner
    when :player then puts "You win!"
    when :dealer then puts "Dealer wins!"
    when :tie then puts "It's a tie!"
    end
  end

  def compare_hands(player, dealer)
    case player.hand <=> dealer.hand
    when 1 then :player
    when 0 then :tie
    when -1 then :dealer
    end
  end

  def clear
    system "clear"
  end

  def display_hands
    display_player_hand
    display_dealer_hand
  end

  def display_final_hands
    puts
    puts "The final hands are as follows:"
    display_player_hand
    display_full_dealer_hand
  end

  def display_player_hand
    puts "Your cards are:"
    player.show_cards
    puts "Your score is #{player.hand.total_score}"
    puts
  end

  def display_dealer_hand
    puts "The dealer's cards are:"
    dealer.show_one_card
    puts
  end

  def display_full_dealer_hand
    puts "The dealer's cards are:"
    dealer.show_cards
    puts "The dealer's score is #{dealer.hand.total_score}"
    puts
  end

  def get_char_choice(message, valid_responses)
    puts message
    choice = nil
    loop do
      choice = gets[0].downcase
      break if valid_responses.include?(choice)
      puts "Invalid response! Choose one of: #{valid_responses.join(', ')}."
    end
    choice
  end
end

TwentyOneGame.new.play
