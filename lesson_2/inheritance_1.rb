class Animal
  def speak
    'bark!'
  end
  
  
  def run
    'running!'
  end

  def jump
    'jumping!'
  end

end

class Dog < Animal
  def swim
    'swimming!'
  end

  def fetch
    'fetching!'
  end
end

class Bulldog < Dog
  def swim
    "can't swim!"
  end
end

class Cat < Animal
end

johnathan_mittens = Cat.new
puts johnathan_mittens.run

teddy = Bulldog.new
puts teddy.speak           # => "bark!"
puts teddy.swim           # => "swimming!"