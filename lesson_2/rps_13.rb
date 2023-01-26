class Player
  attr_reader :choice

  def choose
    puts "==> (r)ock, (p)aper, or (s)cissors?"
  end
end

class Move
end

class Rule
end

def compare(move1, move2)
end

class RPSGame
  attr_accessor :human, :comp
  
  def initialize
    human = Player.new
    comp = Player.new
  end
  
  def play
    display_welcome
    human.choose
    comp.choose
    display_winner
    display_goodbye
  end
end