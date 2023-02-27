class Player
  
  def initialize
    @mark = 'X' # or whatever
  end
  
  def move
  end
end

class Board
  attr_reader :position
  
  def initialize
    # basic board state
    @position = [['', '', ''],
                 ['', '', ''],
                 ['', '', '']]
  end
  
  def mark(row, col, player)
    @position[row][col] = player.mark
  end
  
  def winner?
  end
  
  private
  attr_writer :position
end

def TTTGame
  def initialize
    board = Board.new
  end
  
  def play
    display_welcome
    choose_mark
    loop do
      human.move
      board.display
      break if board.winner?
      comp.move
      board.display
      break if board.winner?
    end
    display_winner 
    display_goodbye
  end
end

TTTGame.new.play