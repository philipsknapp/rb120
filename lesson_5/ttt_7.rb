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

class Board
  WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9],
                   [1, 4, 7], [2, 5, 8], [3, 6, 9],
                   [1, 5, 9], [3, 5, 7]]

  attr_reader :squares

  def initialize
    @squares = {}
    reset
  end

  def reset
    (1..9).each do |num|
      @squares[num] = Square.new
    end
  end
  
  def [](key)
    squares[key]
  end

  def []=(key, marker)
    squares[key].mark = marker
  end

  def draw_row(row_keys)
    puts  '     |     |     '
    print "  #{squares[row_keys[0]]}  |"
    print "  #{squares[row_keys[1]]}  |"
    puts  "  #{squares[row_keys[2]]}  "
    puts  '     |     |     '
  end

  def draw
    draw_row([1, 2, 3])
    puts '-----+-----+-----'
    draw_row([4, 5, 6])
    puts '-----+-----+-----'
    draw_row([7, 8, 9])
  end

  def available_moves
    squares.select { |_, v| v.unmarked? }.keys
  end

  def full?
    available_moves.empty?
  end

  def winning_marker
    markers = squares.values.delete_if(&:unmarked?).map(&:mark).uniq
    WINNING_LINES.each do |line|
      markers.each do |marker|
        return marker if squares.values_at(*line).map(&:mark).count(marker) == 3
      end
    end
    nil
  end
  
  def potential_winning_square(marker)
    WINNING_LINES.each do |line|
      line_marks = squares.values_at(*line).map(&:mark)
      if line_marks.count(marker) == 2 && line_marks.count(Square::INITIAL_MARKER) == 1
        return squares.select { |k, v| line.include?(k) && v.unmarked? }.keys[0]
      end
    end
    nil
  end
end

class Square
  INITIAL_MARKER = ' '

  attr_accessor :mark

  def initialize(mark = INITIAL_MARKER)
    @mark = mark
  end

  def to_s
    mark.to_s
  end

  def unmarked?
    mark == INITIAL_MARKER
  end
end

class Player
  attr_reader :marker, :name, :games_won

  def initialize
    @games_won = 0
  end

  def choose_name
    puts "What is your name?"
    @name = gets.chomp
  end

  def choose_marker
    puts "Enter a character to use as your marker."
    choice = nil
    loop do
      choice = gets.chomp
      break unless choice.strip.empty?
      puts "Must input some character!"
    end
    @marker = choice[0]
  end

  def move(board)
    options = board.available_moves
    puts "Please enter your move! Possible plays are:"
    puts Language.joinor(options)

    choice = nil
    loop do
      choice = gets.chomp.to_i
      break if options.include?(choice)
      puts "Invalid input! Try again."
    end
    choice.to_i
  end

  def increment_wins
    @games_won += 1
  end

  def reset_wins
    @games_won = 0
  end
end

class Computer < Player
  def choose_name(taken_names: [])
    @name = (%w(Hal R2D2 Data) - taken_names).sample
  end

  def choose_marker(taken_markers: [])
    @marker = (%w(O X) - taken_markers).first
  end

  def move(board) # note that this returns the number of the square to mark
    opponent_marker = (board.squares.values.map(&:mark).uniq - [@marker, ' '])[0]
    if opponent_marker
      [marker, opponent_marker].each do |player_marker|
        priority_play = board.potential_winning_square(player_marker)
        return priority_play if priority_play
      end
    end
    if board[5].unmarked?
      return 5
    else
      return board.available_moves.sample #make a random move
    end
  end
end

class TTTGame
  GAMES_TO_WIN = 5

  attr_reader :board, :human, :computer, :first_player
  attr_accessor :current_player

  def initialize
    @board = Board.new
    @human = Player.new
    @computer = Computer.new
  end

  def play
    display_welcome_message
    setup
    main_game
    display_goodbye_message
  end

  private

  def clear
    system 'clear'
  end

  def display_welcome_message
    puts "Welcome to Tic Tac Toe!"
    puts
  end

  def setup
    human.choose_name
    human.choose_marker
    computer.choose_name(taken_names: [human.name])
    computer.choose_marker(taken_markers: [human.marker])
    choose_first
  end

  def choose_first
    options = %w(y o c)
    puts "Who do you want to go first? (y)ou or your (o)pponent?"
    puts "Enter c to have the (c)omputer choose instead."
    choice = nil
    loop do
      choice = gets.chomp[0].downcase
      break if options.include?(choice)
      puts "Must input #{Language.joinor(options)}!"
    end
    @first_player = case choice
                    when 'y' then human
                    when 'o' then computer
                    when 'c'
                      choice = [human, computer].sample
                      puts "#{computer.name} decides that #{choice.name} will play first"
                      choice
                    end
    self.current_player = @first_player
  end

  def display_board
    puts "You are #{human.marker}. Computer is #{computer.marker}."
    puts
    board.draw
    puts
  end

  def clear_screen_and_display_board
    clear
    display_board
  end

  def current_player_moves
    play = current_player.move(board)
    board[play] = current_player.marker
    switch_turns
  end

  def switch_turns
    self.current_player = (human_turn? ? computer : human)
  end

  def human_turn?
    current_player == human
  end

  def display_result
    clear_screen_and_display_board
    winning_marker = board.winning_marker
    if winning_marker == human.marker
      puts "You win!"
      human.increment_wins
    elsif winning_marker == computer.marker
      puts "Computer wins!"
      computer.increment_wins
    else
      puts "Tie game!"
    end
  end

  def display_scores
    puts "You have won #{human.games_won} games. " \
         "The computer has won #{computer.games_won} games."
    puts "Press Enter to continue."
  end

  def match_complete?
    [human.games_won, computer.games_won].max >= GAMES_TO_WIN
  end

  def play_again?
    puts "Would you like to play again? (y/n)"
    choice = nil
    loop do
      choice = gets.chomp[0].downcase
      break if %w(y n).include?(choice)
      puts "Sorry, must be y or n"
    end
    choice == 'y'
  end

  def reset
    board.reset
    self.current_player = first_player
    clear
  end

  def reset_win_count
    human.reset_wins
    computer.reset_wins
  end

  def display_reset_message
    puts "Let's play again!"
    puts
  end

  def display_match_complete_message
    winner_name = (human.games_won >= GAMES_TO_WIN ? human.name : computer.name)
    puts "The match is over! #{winner_name} is our grand winner!"
  end

  def display_goodbye_message
    clear
    puts "Thanks for playing Tic Tac Toe! Goodbye!"
  end

  def main_game
    loop do
      game_round
      display_match_complete_message
      break unless play_again?
      reset
      reset_win_count
      display_reset_message
    end
  end

  def game_round
    loop do
      display_board
      player_move
      display_result
      display_scores
      gets
      break if match_complete?
      reset
      display_reset_message
    end
  end

  def player_move
    loop do
      current_player_moves
      break if board.winning_marker || board.full?
      clear_screen_and_display_board if human_turn?
    end
  end
end

game = TTTGame.new
game.play
