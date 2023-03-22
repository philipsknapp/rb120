class Player
  attr_reader :mark

  def choose_mark
    puts "Enter a character to use as your marker"
    choice = nil
    loop do
      choice = gets.chomp[0]
      break unless choice.nil? || choice.strip == ''
      puts "Must enter a character!"
    end
    @mark = choice
  end

  def move(options)
    puts "choose a square from the numbered squares on the board"
    choice = nil
    loop do
      choice = gets.chomp.to_i
      break if options.include?(choice)
      puts 'must choose a square from those on the board'
    end
    [choice, mark]
  end
end

class Computer < Player
  def choose_mark(choice = 'O')
    @mark = choice
  end

  def move(options)
    puts "computer moves!"
    [options.sample, mark]
  end
end

class Board
  attr_reader :squares

  def initialize
    @squares = {}
    (1..9).each { |k| squares[k] = Square.new }
  end

  def mark(position, marker)
    squares[position].mark = marker
  end

  def empty_positions
    (1..9).to_a.select { |pos| squares[pos].empty? }
  end

  def full?
    empty_positions.empty?
  end

  def to_s
    print_row(1, 2, 3) +
      "----------- \n" +
      print_row(4, 5, 6) +
      "----------- \n" +
      print_row(7, 8, 9)
  end

  private

  def print_row(pos1, pos2, pos3)
    " #{print_position(pos1)} |" \
      " #{print_position(pos2)} |" \
      " #{print_position(pos3)} \n"
  end

  def print_position(pos)
    squares[pos].mark || pos.to_s
  end
end

class Square
  attr_accessor :mark

  def initialize(mark = nil)
    @mark = mark # initialize to a default value
  end

  def empty?
    !mark
  end

  def to_s
    mark
  end
end

class TTTGame
  WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9], [1, 4, 7],
                   [2, 5, 8], [3, 6, 9], [1, 5, 9], [3, 5, 7]]

  def initialize
    @player = Player.new
    @computer = Computer.new
    @board = Board.new
    @winning_lines = set_winning_lines
    @active_player = player
  end

  def play
    greet_message
    setup
    loop do
      display_state
      mark_board
      break if game_over
    end
    display_winner
    goodbye_message
  end

  private

  attr_reader :player, :computer, :board, :winning_lines
  attr_accessor :active_player

  def set_winning_lines
    WINNING_LINES.map do |line|
      line.map { |position| board.squares[position] }
    end
  end

  def greet_message
    puts "Welcome to Tic Tac Toe!"
  end

  def setup
    player.choose_mark
    if player.mark == 'O'
      computer.choose_mark('X')
    else
      computer.choose_mark
    end
  end

  def display_state
    puts "You are #{player.mark}. Computer is #{computer.mark}."
    puts board
    puts
  end

  def mark_board
    options = board.empty_positions
    position, marker = active_player.move(options)
    board.mark(position, marker)
    system('clear') if active_player == player
    self.active_player = (active_player == player ? computer : player)
  end

  def game_over
    board.full? || winner
  end

  def winner
    winning_mark = nil
    winning_lines.any? do |line|
      line_marks = line.map(&:mark)
      first_mark = line_marks[0]
      winning_mark = first_mark if line_marks.count(first_mark) == 3
    end
    winning_mark
  end

  def display_winner
    system("clear")
    puts board
    puts
    puts case winner
         when player.mark then "You win!"
         when computer.mark then "Computer wins!"
         else "Tie game!"
         end
  end

  def goodbye_message
    puts "Thanks for playing Tic Tac Toe! Goodbye!"
  end
end

TTTGame.new.play
