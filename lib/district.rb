require_relative 'enrollment'
require 'csv'

class District
  attr_reader :name
  attr_accessor :enrollment, :statewide_test

  def initialize(args)
    @name = args[:name]
    @enrollment = nil
    @statewide_test = nil
  end

end