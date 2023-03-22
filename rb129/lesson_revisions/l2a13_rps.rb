class Player
  attr_reader :move

  def initialize(options)
    @options = options
  end

  def choose
    puts "choose an option by number:"
    options.each_with_index { |option, i| puts "#{i + 1}: #{option}" }
    input = nil
    loop do
      input = gets.chomp.to_i
      break if input.between?(1, options.size)
      puts "invalid response, try again!"
    end
    @move = Move.new(options[input - 1])
  end

  private

  attr_reader :options
end

class Computer < Player
  def choose
    @move = Move.new(options.sample)
  end
end

class Move
  PLAYS = [:rock, :paper, :scissors].freeze

  def initialize(play)
    @play = play
  end

  attr_reader :play

  def <=>(other)
    if play == other.play
      0
    elsif PLAYS.index(play) == (PLAYS.index(other.play) + 1) % 3
      1
    else
      -1
    end
  end

  def to_s
    play.to_s
  end
end

class RPSGame
  attr_reader :player, :computer, :winner

  def initialize
    potential_choices = Move::PLAYS
    @player = Player.new(potential_choices)
    @computer = Computer.new(potential_choices)
  end

  def play
    display_welcome
    player.choose
    computer.choose
    display_moves
    compare_moves
    display_winner
    display_goodbye
  end

  private

  def display_welcome
    puts "welcome to rock paper scissors!"
  end

  def display_moves
    puts "you chose #{player.move}"
    puts "the computer chose #{computer.move}"
  end

  def display_goodbye
    puts "thank you for playing! goodbye!"
  end

  def compare_moves
    @winner = case player.move <=> computer.move
              when 1 then :player
              when 0 then :tie
              when -1 then :computer
              end
  end

  def display_winner
    puts "the winner is #{winner}!"
  end
end

RPSGame.new.play
