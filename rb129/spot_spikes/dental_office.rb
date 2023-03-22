class DentalOffice
  attr_reader :name, :staff
  
  def initialize(name, staff)
    @name = name
    @staff = staff
  end
end

class Dentist
  def initialize
    @dental_school_graduate = true
  end
end

module Puller
  def pull_teeth
    puts "The patient says, 'aaaaugh!'"
  end
end

=begin
Another way to handle the fact that only the Orthodontist can't pull teeth would
be to make it an instance method of Dentist, then override pull_teeth in the
Orthodontist class definition to raise an error or output a message.
=end

class OralSurgeon < Dentist
  include Puller
  
  def place_implants
    puts "Implanted some implants!"
  end
end

class Orthodontist < Dentist
  def straighten_teeth
    puts "Those look nice and straight!"
  end
end

class GeneralDentist < Dentist
  include Puller

  def fill_teeth
    puts "Get out of here, cavity!"
  end
end

alpha = OralSurgeon.new
beta = OralSurgeon.new
gamma = Orthodontist.new
delta = Orthodontist.new
epsilon = GeneralDentist.new

staff = [alpha, beta, gamma, delta, epsilon]
d_p_i = DentalOffice.new("Dental People Inc.", staff)

p d_p_i.name
p d_p_i.staff
d_p_i.staff[0].pull_teeth
d_p_i.staff[1].place_implants
d_p_i.staff[2].straighten_teeth
d_p_i.staff[3]
d_p_i.staff[4].pull_teeth
d_p_i.staff[4].fill_teeth