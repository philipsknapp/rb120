class Player
  attr_reader :move, :name

  def initialize
    puts "What is your name?"
    @name = gets.chomp
  end

  def choose
    puts "==> (r)ock, (p)aper, or (s)cissors?"
    loop do
      attempt = gets.chomp[0].downcase
      if Move::VALID_MOVES.include?(attempt)
        @move = Move.new(attempt)
        break
      end
      puts "==> must enter (r)ock, (p)aper, or (s)cissors. Try again."
    end
  end

  private

  attr_writer :move
end

class Human < Player
  def initialize
    puts "What is your name?"
    @name = gets.chomp
  end
end

class Computer < Player
  def initialize
    @name = "R0-CH4M-80"
  end

  def choose
    @move = Move.new(Move::VALID_MOVES.sample)
  end
end

class Move
  include Comparable

  VALID_MOVES = %w(r p s)

  attr_accessor :choice

  def initialize(c)
    @choice = c
  end

  def beats(other)
    (choice == 'r' && other.choice == 's') ||
      (choice == 's' && other.choice == 'p') ||
      (choice == 'p' && other.choice == 'r')
  end

  def <=>(other)
    if choice == other.choice
      0
    elsif beats(other)
      1
    else
      -1
    end
  end

  def to_s
    { 'r' => 'rock', 'p' => 'paper', 's' => 'scissors' }[choice]
  end
end

class RPSGame
  attr_accessor :human, :comp

  def initialize
    @human = Human.new
    @comp = Computer.new
  end

  def display_welcome
    puts "Welcome to Rock, Paper, Scissors!"
  end

  def display_goodbye
    puts "Thanks for playing! Goodbye!"
  end

  def display_moves
    puts "#{human.name} chose #{human.move}"
    puts "#{comp.name} chose #{comp.move}"
  end

  def display_winner
    if human.move > comp.move
      puts "You win!"
    elsif human.move == comp.move
      puts "Tie game!"
    else
      puts "Computer wins!"
    end
  end

  def play_again?
    puts "==> Play again? y/n"
    gets.chomp[0].downcase == 'y'
  end

  def play
    display_welcome
    loop do
      human.choose
      comp.choose
      display_moves
      display_winner
      break unless play_again?
    end
    display_goodbye
  end
end

RPSGame.new.play
