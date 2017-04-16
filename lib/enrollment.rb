require 'pry'
require 'csv'

##
# The Enrollment class creates all the Enrollment objects with the kindergarten
# participation and highschool graduation data as well as functions to access
# said data.

class Enrollment
  attr_reader :name
  attr_accessor :high_school_graduation_rates, :kindergarten_participation

  def initialize(args)
    @name = args[:name]
    @kindergarten_participation = args[:kindergarten_participation]
    if @kindergarten_participation.nil?
      @kindergarten_participation = Hash.new
    end
    @high_school_graduation_rates = args[:high_school_graduation]
    if @high_school_graduation_rates.nil?
      @high_school_graduation_rates = Hash.new
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

  def graduation_by_year
    @high_school_graduation_rates.reduce({}) do |key, value|
      key.merge(value.first => truncate_to_3_decimal_points(value.last))
    end
  end

  def graduation_rate_in_year(year)
    graduation_by_year[year]
  end

  private

  def truncate_to_3_decimal_points(num)
    (num.to_f*1000).floor/1000.0
  end

end

# binding.pry
# ""
