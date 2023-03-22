class SportsTeam
  attr_reader :members

  def initialize
    @members = []
  end
  
  def hire(player)
    if Player === player
      @members << player
    else
      puts "#{player} isn't a football player!"
    end
  end
  
  def to_s
    description = ''
    members.each { |member| description += member.to_s }
    description
  end
end

class Person
  attr_reader :role, :jersey
  
  def initialize
    @role = self.class.to_s.downcase
  end
  
  def run
    puts "running"
  end
  
  def to_s
    "a #{role} in a #{jersey} jersey "
  end
end

class Player < Person
  def initialize
    super
    @jersey = 'blue'
  end
  
  def shoot
    puts "shoots!"
  end
end

class Attacker < Player
  def lob
    puts "I'm lobbing it!"
  end
end

class Midfielder < Player
  def pass
    puts "passing now!"
  end
end

class Defender < Player
  def block
    puts "you're blocked!"
  end
end

class Goalkeeper < Player
  def initialize
    super
    @jersey = 'white with blue stripes'
  end
end

class Referee < Person
  def initialize
    super
    @jersey = 'black'
  end

  def whistle
    "phweee!"
  end
end

turtles = SportsTeam.new
raphael = Attacker.new
leonardo = Midfielder.new
donatello = Defender.new
michaelangelo = Goalkeeper.new
splinter = Referee.new
[raphael, leonardo, donatello, michaelangelo, splinter].each do |turtle|
  turtles.hire(turtle)
end

puts turtles
puts raphael.lob
puts raphael.run
puts leonardo.pass
puts donatello.block
puts splinter.whistle