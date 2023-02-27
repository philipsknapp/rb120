class Player
  attr_reader :move, :name
  attr_accessor :score

  def initialize
    @score = 0
  end

  def choose
    puts "==> (r)ock, (p)aper, s(c)issors, (l)izard, or (s)pock?"
    loop do
      attempt = gets.chomp[0].downcase
      if Move::VALID_MOVES.include?(attempt)
        @move = Move.new(attempt)
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
  BEHAVIORS_BY_NAME = { 'R2D2' => %w(r p c),
                        'Hal' => %w(s),
                        'Chappie' => %w(r r r r p c l s),
                        'Sonny' => %w(r p p c l l l s),
                        'Number_5' => %w(r p c l s),
                      }
  def initialize
    super
    @name = BEHAVIORS_BY_NAME.keys.sample
    @behavior = BEHAVIORS_BY_NAME[@name]
  end

  def choose
    @move = Move.new(@behavior.sample)
  end
end

class Move
  include Comparable

  VALID_MOVES = %w(r p c l s)
  WINNING_MOVES = {'r' => ['l', 'c'],
                'p' => ['r', 's'],
                'c' => ['p', 'l'],
                'l' => ['s', 'p'],
                's' => ['c', 'r']
                }

  attr_accessor :choice

  def initialize(c)
    @choice = c
  end

  def beats(other)
    WINNING_MOVES[choice].include?(other.choice)
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
    { 'r' => 'rock', 'p' => 'paper', 'c' => 'scissors', 'l' => 'lizard',
      's' => 'spock' }[choice]
  end
end

class Round
  @@rounds_played = 0
  
  def initialize(player_name, comp_name, player_choice, comp_choice, winner, 
                 player_score, comp_score)
    @player_name = player_name
    @comp_name = comp_name
    @@rounds_played += 1
    @round_number = @@rounds_played
    @player_choice = player_choice
    @comp_choice = comp_choice
    @winner = winner
    @player_score = player_score
    @comp_score = comp_score
  end
  
  def winner_identity
    case @winner
    when :human then "#{@player_name} won. "
    when :tie then "Tie game. "
    when :comp then "#{@comp_name} won. "
    end
  end
  
  def to_s
    "Round #{@round_number}: #{@player_name} played #{@player_choice}. " +
    "#{@comp_name} played #{@comp_choice}. " + winner_identity +
    "The score was #{@player_score} - #{@comp_score}."
  end
end

class RPSGame
  GAMES_TO_WIN = 5
  attr_accessor :human, :comp, :history

  def initialize
    @human = Human.new
    @comp = Computer.new
    @history = []
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
  
  def add_round(winner)
    @history << Round.new(human.name, comp.name, human.move, comp.move, winner, 
                 human.score, comp.score)
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
  
  def check_history
    puts "==> Would you like to see the rounds played so far? y/n"
    if gets.chomp[0].downcase == 'y'
      display_history
    end
  end
  
  def display_history
    history.each do |round|
      puts round
      puts
    end
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
        add_round(winner)
        check_history
      end
      display_grand_winner
      reset_scores
      break unless play_again?
    end
    display_goodbye
  end
end

RPSGame.new.play
