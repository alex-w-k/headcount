require 'csv'

class District
  attr_reader :location, :year, :data_format, :data

  def initialize(args)
    @location = args[:location]
    @year = args[:timeframe]
    @data_format = args[:dataformat]
    @data = args[:data]
  end

end

