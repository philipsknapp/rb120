class Player
  attr_reader :move, :name
  attr_accessor :score

  def initialize
    @score = 0
  end

  def choose
    valid_moves = %w(r p c l s)
    move_names = {'r' => Rock,
                'p' => Paper,
                'c' => Scissors,
                'l' => Lizard,
                's' => Spock
                }
    puts "==> (r)ock, (p)aper, s(c)issors, (l)izard, or (s)pock?"
    loop do
      attempt = gets.chomp[0].downcase
      if valid_moves.include?(attempt)
        @move = move_names[attempt].new
        break
      end
      puts "==> must enter (r)ock, (p)aper, s(c)issors, (l)izard, or (s)pock. \\
      Try again."
    end
  end

  private

  attr_writer :move
end

class Human < Player
  def initialize
    super
    puts "What is your name?"
    @name = gets.chomp
  end
end

class Computer < Player
  def initialize
    super
    @name = "R0-CH4M-80"
  end

  def choose
    @move = [Rock, Paper, Scissors, Lizard, Spock].sample.new
  end
end

class Move
  include Comparable

  def <=>
    puts "Must call this on a specific move type!"
  end

  def to_s
    "#{self.class}".downcase
  end
end


class Rock < Move
  def <=>(other)
    case other
    when Rock then 0
    when Paper then -1
    when Scissors then 1
    when Lizard then 1
    when Spock then -1
    else puts "invalid comparison!" 
    end
  end
end

class Paper < Move
  def <=>(other)
    case other
    when Rock then 1
    when Paper then 0
    when Scissors then -1
    when Lizard then -1
    when Spock then 1
    else puts "invalid comparison!" 
    end
  end
end

class Scissors < Move
  def <=>(other)
    case other
    when Rock then -1
    when Paper then 1
    when Scissors then 0
    when Lizard then 1
    when Spock then -1
    else puts "invalid comparison!" 
    end
  end
end

class Lizard < Move
  def <=>(other)
    case other
    when Rock then -1
    when Paper then 1
    when Scissors then -1
    when Lizard then 0
    when Spock then 1
    else puts "invalid comparison!" 
    end
  end
end

class Spock < Move
  def <=>(other)
    case other
    when Rock then 1
    when Paper then -1
    when Scissors then 1
    when Lizard then -1
    when Spock then 0
    else puts "invalid comparison!" 
    end
  end
end

class RPSGame
  GAMES_TO_WIN = 10
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

  def evaluate_winner
    case human.move <=> comp.move
    when 1 then :human
    when 0 then :tie
    when -1 then :comp
    end
  end
  
  def display_winner(winner)
    case winner
    when :human then puts "#{human.name} wins!"
    when :tie then puts "Tie game!"
    when :comp then puts "#{comp.name} wins!"
    end
  end
  
  def increment_scores(winner)
    case winner
    when :human then human.score += 1
    when :comp then comp.score += 1
    end
  end
  
  def display_scores
    puts "#{human.name}'s score is #{human.score}"
    puts "#{comp.name}'s score is #{comp.score}"
  end

  def display_grand_winner
    print (human.score >= GAMES_TO_WIN ? human.name : comp.name)
    puts " wins our first-to-#{GAMES_TO_WIN} match!"
  end
  
  def reset_scores
    human.score = 0
    comp.score = 0
  end

  def play_again?
    puts "==> Play again? y/n"
    gets.chomp[0].downcase == 'y'
  end

  def play
    display_welcome
    loop do
      until [human.score, comp.score].max >= GAMES_TO_WIN
        human.choose
        comp.choose
        display_moves
        winner = evaluate_winner
        display_winner(winner)
        increment_scores(winner)
        display_scores
      end
      display_grand_winner
      reset_scores
      break unless play_again?
    end
    display_goodbye
  end
end

RPSGame.new.play
