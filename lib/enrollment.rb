require 'csv'

class Enrollment
  attr_reader :name, :year, :data_format, :data

  def initialize(args)
    @name = args[:name]
    @year = args[:timeframe]
    @data_format = args[:dataformat]
    @data = args[:data]
  end

end