require 'csv'

class District
  attr_reader :name, :year, :data_format, :data

  def initialize(args)
    @name = args[:name]
    @enrollment = {}
    # @year = args[:timeframe]
    # @data_format = args[:dataformat]
    # @data = args[:data]
  end

end

