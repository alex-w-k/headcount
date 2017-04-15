require_relative 'enrollment'
require 'csv'

class District
  attr_reader :name
  attr_accessor :enrollment

  def initialize(args)
    @name = args[:name]
    @enrollment = nil
  end

end

