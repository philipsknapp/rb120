module Supervise
  def supervise
    puts "supervising a class"
  end
end

class Person
  def eat_lunch
    puts "eating lunch"
  end
end

class Child < Person
  def learn
    puts "learning!"
  end

  def play
    puts "time for play!"
  end
end

class ClassStaff < Person
  def help(child)
    puts "helping with schoolwork"
  end

  def watch(child)
    puts "watching on the playground"
  end
end

class Teacher < ClassStaff
  include Supervise

  def teach
    puts "teaching"
  end
end

class Assistant < ClassStaff
  def bathroom_help
    puts "helping with an emergency"
  end
end

class Principal < Person
  include Supervise

  def expel(child)
    puts "get that ass banned"
  end
end

class Janitor < Person
  def clean
    puts "someone has to clean around here"
  end
end

class CafeteriaWorker < Person
  def serve
    puts "serving food"
  end
end

clem = Janitor.new

clem.eat_lunch

sylvie = Principal.new
sylvie.supervise

michael = Assistant.new
michael.bathroom_help
michael.help('bill')
michael.watch('bill')