require 'csv'

class Enrollment
  attr_reader :name
  attr_accessor :high_school_graduation_rates, :kindergarten_participation

  def initialize(args)
    @name = args[:name]
    @kindergarten_participation = args[:kindergarten_participation] || Hash.new
    @high_school_graduation_rates = args[:high_school_graduation] || Hash.new
  end

  def kindergarten_participation_by_year
    @kindergarten_participation.reduce({}) do |key, value|
      key.merge(value.first => value.last)
    end
  end

  def kindergarten_participation_in_year(year)
    kindergarten_participation_by_year[year]
  end

  def graduation_rate_by_year
    @high_school_graduation_rates.reduce({}) do |key, value|
      key.merge(value.first => value.last)
    end
  end

  def graduation_rate_in_year(year)
    graduation_rate_by_year[year]
  end
end
