require 'pry'
require 'csv'

class Enrollment
  attr_reader :name, :kindergarten_participation
  attr_accessor :high_school_graduation_rates

  def initialize(args)
    @name = args[:name]
    @kindergarten_participation = args[:kindergarten_participation]
    @high_school_graduation_rates = args[:high_school_graduation]
    if @high_school_graduation_rates.nil?
      @high_school_graduation_rates = Hash.new([])
    end
  end

  def kindergarten_participation_by_year
    @kindergarten_participation.reduce({}) do |key, value|
      key.merge(value.first => truncate_to_3_decimal_points(value.last))
    end
  end

  def kindergarten_participation_in_year(year)
    kindergarten_participation_by_year[year]
  end

  def truncate_to_3_decimal_points(num)
    (num.to_f*1000).floor/1000.0
  end

end

# binding.pry
# ""