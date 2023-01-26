class Vehicle
  @@number_of_vehicles = 0
  
  def self.gas_mileage(miles, gallons)
    "#{miles.fdiv(gallons).round(2)} miles per gallon"
  end
  
  attr_accessor :color, :speed
  attr_reader :year
  
  def initialize(year, color)
    @year = year
    @color = color
    @speed = 0
    @@number_of_vehicles += 1
  end

  def spray_paint(col)
    self.color = col
    puts "Spray-painted your #{@model} #{color}!"
  end
  
  def speed_up
    @speed += 5
    puts "Speeding up! Current speed is #{@speed}"
  end
  
  def brake
    @speed -= 5
    puts "Braking! Current speed is #{@speed}"
  end
  
  def turn_off
    @speed = 0
    puts "Turning off! Current speed is #{@speed}"
  end
  
  def to_s
    "A #{year} vehicle going #{speed} miles per hour."
  end
  
  def how_old
    "This vehicle is #{age} years old"
  end
  
  def self.how_many_vehicles
    puts "#{@@number_of_vehicles} created!"
  end

  private
  
  def age
    Time.new.year - self.year
  end

end

module Loadable
  def bears_load?(weight)
    weight <= max_load
  end
end

class MyCar < Vehicle
  NUMBER_OF_WHEELS = 4
  attr_reader :model
  
  def initialize(year, color, model)
    super(year, color)
    @model = model
  end
  
  def to_s
    super + " It's a #{model}. Like all cars, it has #{NUMBER_OF_WHEELS} wheels."
  end
  
end

class MyTruck < Vehicle
  include Loadable
  NUMBER_OF_WHEELS = 18
  
  attr_reader :max_load
  
  def initialize(year, color, max_load)
    super(year, color)
    @max_load = max_load
  end
  
  def to_s
    super + "It's an #{NUMBER_OF_WHEELS}-wheeler with a max load of #{max_load} lbs."
  end
end

car = MyCar.new(1992, 'maroon', 'camry')
car2 = MyCar.new(2010, 'silver', 'impala')
jet = Vehicle.new(1977, 'white')
semi = MyTruck.new(1988, 'white', 20000)

puts semi