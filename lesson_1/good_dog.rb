class Animal
  def speak
    "Hello!"
  end
end

class GoodDog < Animal
  DOG_YEARS = 7
  @@number_of_dogs = 0
  
  def self.total_dogs
    @@number_of_dogs
  end
  
  def self.dog_years
    DOG_YEARS
  end
  
  attr_accessor :name, :height, :weight, :age
  
  def initialize(n, h, w, age)
    self.name = n
    self.height = h
    self.weight = w
    @age = age * DOG_YEARS
    @@number_of_dogs += 1
  end
  
  def change_info(n, h, w)
    self.name   = n
    self.height = h
    self.weight = w
  end

  def info
    "#{self.name} weighs #{self.weight} and is #{self.height} tall."
  end
  
  def change_height(h)
    self.height = h
  end
  

  def to_s
    "My name is #{self.name} and I'm #{age} in dog years! \ 
    I'm one of #{self.total_dogs} dogs."
  end
  
end


class Cat < Animal
end

fido = GoodDog.new('fido', 12, 30, 2)
puts fido.speak

mittens = Cat.new
puts mittens.speak

