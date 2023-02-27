VALID_MOVES = %w[r p s]
KEY_TO_NAME = {'r' => 'rock', 'p' => 'paper', 's' => 'scissors'}
class Player
  attr_reader :choice, :is_human, :name
  
  def initialize(humanity)
    @is_human = humanity
    set_name
  end
  
  def set_name
    if is_human
      puts "What is your name?"
      @name = gets.chomp
    else
      @name = "R0-CH4M-80"
    end
  end
  
  def choose
    if is_human
      puts "==> (r)ock, (p)aper, or (s)cissors?"
      loop do
        self.choice = gets.chomp[0].downcase
        break if VALID_MOVES.include?(choice)
        puts "==> must enter (r)ock, (p)aper, or (s)cissors. Try again."
      end
    else
      self.choice = VALID_MOVES.sample
    end
  end
  
  private
  attr_writer :choice
end

class RPSGame
  attr_accessor :human, :comp
  
  def initialize
    @human = Player.new(true)
    @comp = Player.new(false)
  end
  
  def display_welcome
    puts "Welcome to Rock, Paper, Scissors!"
  end
  
  def display_goodbye
    puts "Thanks for playing! Goodbye!"
  end
  
  def display_winner
    puts "#{human.name} chose #{KEY_TO_NAME[human.choice]}"
    puts "#{comp.name} chose #{KEY_TO_NAME[comp.choice]}"
    human_index = VALID_MOVES.index(human.choice)
    comp_index = VALID_MOVES.index(comp.choice)
    case (human_index - comp_index) % 3
    when 1 then puts "You win!"
    when 2 then puts "You lose!"
    when 0 then puts "Tie game!"
    end
  end
  
  def play_again?
    puts "==> Play again? y/n"
    gets.chomp[0].downcase == 'y' ? true : false
  end
  
  def play
    display_welcome
    loop do
      human.choose
      comp.choose
      display_winner
      break unless play_again?
    end
    display_goodbye
  end
end

RPSGame.new.play