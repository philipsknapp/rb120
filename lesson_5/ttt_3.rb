class Board
  WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9],
                   [1, 4, 7], [2, 5, 8], [3, 6, 9],
                   [1, 5, 9], [3, 5, 7]]
                     
  attr_reader :squares
  
  def initialize
    @squares = {}
    clear
  end
  
  def clear
    (1..9).each do |num|
      @squares[num] = Square.new
    end
  end
  
  def mark(key, marker)
    squares[key].mark = marker
  end
  
  def get_square_at(key)
    squares[key]
  end

  def free_squares
    squares.select { |_, v| v.unmarked? }.keys
  end
  
  # def positions_by_player
  #   result = {}
  #   marked_squares = squares.select{ |_, square| !square.unmarked? }
  #   marked_squares.each do |position, square|
  #     if result.key?(square.mark)
  #       result[square.mark] << position
  #     else
  #       result[square.mark] = [position]
  #     end
  #   end
  #   result
  # end
  
  # def winner
  #   winner = nil
  #   positions_by_player.each do |marker, position_set|
  #     winner = marker if WINNING_LINES.any? do |line|
  #                         line.all? do |position|
  #                           position_set.include?(position)
  #                         end
  #                       end
  #   end
  #   winner
  # end
  
  def winner
    WINNING_LINES.each do |line|
      [TTTGame::HUMAN_MARKER, TTTGame::COMPUTER_MARKER].each do |marker|
        return marker if squares.values_at(*line).map(&:mark).count(marker) == 3
      end
    end
    nil
  end
  
  def full?
    free_squares.empty?
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
  attr_reader :marker
  
  def initialize(marker)
    @marker = marker
  end
  
  def move(options)
    puts "Please enter your move! Possible plays are:"
    p options

    choice = nil
    loop do 
      choice = gets.chomp.to_i
      break if options.include?(choice)
      puts "Invalid input! Try again." 
    end
    choice.to_i
  end
end

class Computer < Player
  def initialize(marker)
    super
  end
  
  def move(options)
    options.sample
  end
end

class TTTGame
  HUMAN_MARKER = 'X'
  COMPUTER_MARKER = 'O'

  attr_reader :board, :human, :computer
  
  def initialize
    @board = Board.new
    @human = Player.new(HUMAN_MARKER)
    @computer = Computer.new(COMPUTER_MARKER)
  end
  
  def display_welcome_message
    puts "Welcome to Tic Tac Toe!"
    puts
  end
  
  def display_row(squares)
    puts  '     |     |     '
    print "  #{board.get_square_at(squares[0])}  |"
    print "  #{board.get_square_at(squares[1])}  |"
    puts  "  #{board.get_square_at(squares[2])}  "
    puts  '     |     |     '
  end
  
  def display_board(clearing = true)
    system 'clear' if clearing
    puts
    display_row([1, 2, 3])
    puts '-----+-----+-----'
    display_row([4, 5, 6])
    puts '-----+-----+-----'
    display_row([7, 8, 9])
    puts
  end
  
  def human_moves
    play = human.move(board.free_squares)
    board.mark(play, human.marker)
  end
  
  def computer_moves
    play = computer.move(board.free_squares)
    board.mark(play, computer.marker)
  end
  
  def display_result
    display_board
    winner = board.winner
    if winner == HUMAN_MARKER
      puts "You win!"
    elsif winner == COMPUTER_MARKER
      puts "Computer wins!"
    else
      puts "Tie game!"
    end
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
  
  def display_goodbye_message
    puts "Thanks for playing Tic Tac Toe! Goodbye!"
  end
  
  def play
    display_welcome_message
    loop do
      display_board(false)
      loop do
        human_moves
        break if board.winner || board.full?
  
        computer_moves
        display_board
        break if board.winner || board.full?
      end
      display_result
      break unless play_again?
      board.clear
      puts "Let's play again!"
    end
    display_goodbye_message
  end
end

game = TTTGame.new
game.play