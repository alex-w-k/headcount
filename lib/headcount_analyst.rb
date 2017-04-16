require 'pry'
require_relative '../lib/district_repository'

class HeadcountAnalyst
  attr_reader :dr

  def initialize(dr)
    @dr = dr
  end
  
  def average_kindergarten_participation_for_district(name)
    district = @dr.find_by_name(name)
    sum = district.enrollment.kindergarten_participation_by_year.reduce(0) do |a, b|
      a + b[1]
    end
    average = sum / district.enrollment.kindergarten_participation_by_year.length
    (average.to_f*1000).floor/1000.0
  end

  def kindergarten_participation_rate_variation(name, arg)
    district_1 = average_kindergarten_participation_for_district(name)
    district_2 = average_kindergarten_participation_for_district(arg[:against])
    variation = district_1 / district_2
    (variation.to_f*1000).floor/1000.0
  end

  def kindergarten_participation_rate_variation_trend(name, arg)
    district_1 = @dr.find_by_name(name)
    district_1_data = district_1.enrollment.kindergarten_participation_by_year
    district_2 = @dr.find_by_name(arg[:against])
    district_2_data = district_2.enrollment.kindergarten_participation_by_year
    variation = district_1_data.merge(district_2_data) do |key, oldval, newval| 
    	variation = oldval / newval
    	(variation.to_f*1000).floor/1000.0
    end
  end

  def average_high_school_graduation_rates_for_district(name)
  	district = @dr.find_by_name(name)
  	sum = district.enrollment.graduation_by_year.reduce(0) do |a, b|
      a + b[1]
    end
    average = sum / district.enrollment.graduation_by_year.length
    (average.to_f*1000).floor/1000.0
  end

  def high_school_graduation_rate_variation(name, arg)
    district_1 = average_high_school_graduation_rates_for_district(name)
    district_2 = average_high_school_graduation_rates_for_district(arg[:against])
    variation = district_1 / district_2
    (variation.to_f*1000).floor/1000.0
  end

  def kindergarten_participation_against_high_school_graduation(name)
    variation = kindergarten_participation_rate_variation(name, :against => 'COLORADO') /
    high_school_graduation_rate_variation(name, :against => 'COLORADO')
    (variation.to_f*1000).floor/1000.0
  end

  def kindergarten_participation_correlates_with_high_school_graduation(arg)
    if arg[:for] = 'STATEWIDE'

    variation = kindergarten_participation_against_high_school_graduation(arg[:for])
    if variation > 0.5 && variation < 1.5
      true
    else
      false
    end
  end

end