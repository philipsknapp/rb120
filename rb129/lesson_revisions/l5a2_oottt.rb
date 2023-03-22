class Player
  def initialize
    @marker = nil # assign or choose a marker
  end
  
  def mark
  end
  
  def win
  end
end

class Board
  def initialize
    @squares = nil # some set of Squares
  end
end

class Square
  def initialize(position)
    @mark = nil # initialize to a default value 
    @position = position # if we want square to hold its position
  end
  # just brainstorming here that the winning lines could be
  # collections of Square objects - you'd just have to check that they
  # all had the same @mark value
end

class TTTGame
  attr_reader :player, :computer
  
  def initialize
    @player = Player.new
    @computer = Computer.new
    @board = Board.new
  end
  
  def play
    greet_message
    loop do
      display_board
      player.mark
      computer.mark
      break if game_over # someone won or board is full
    end
    display_winner
    goodbye_message
  end
end