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
  	sum = district.enrollment.graduation_rate_by_year.reduce(0) do |a, b|
      a + b[1]
    end
    average = sum / district.enrollment.graduation_rate_by_year.length
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
    variation.round(3)
  end

  def kindergarten_participation_correlates_with_high_school_graduation(arg)
    if arg[:for] == 'STATEWIDE'
      statewide_correlation
    elsif arg[:for]
      district_correlation(arg[:for])
    elsif arg[:across]
      counter = 0
      arg[:across].each do |district|
        variation = kindergarten_participation_against_high_school_graduation(district)
        if variation > 0.6 && variation < 1.5
          counter += 1
        end
      end
      percent = counter / arg[:across].length
      if percent >= 0.7
        true
      else
        false
      end
    end
  end

  def district_correlation(state)
    variation = kindergarten_participation_against_high_school_graduation(state)
    if variation > 0.6 && variation < 1.5
      true
    else
      false
    end
  end

  def statewide_correlation
    counter = 0
      @dr.districts.each do |district|
        if district.name == 'COLORADO' 
          next
        end
        variation = kindergarten_participation_against_high_school_graduation(district.name)
        if variation > 0.6 && variation < 1.5
          counter += 1
        end
      end
      percent = counter / (@dr.districts.length - 1)
      if percent >= 0.7
        true
      else
        false
      end
    end

    def top_statewide_test_year_over_year_growth(args)
      districts_growth = []
      if args[:grade] == 3
        @dr.districts.each do |district|
          binding.pry
          if district.statewide_test.third_grade[1][args[:subject]] == 'N/A'
            next
          end
          growth = (district.statewide_test.third_grade.max[1][args[:subject]] - 
          district.statewide_test.third_grade.min[1][args[:subject]]) /
          (district.statewide_test.third_grade.max[0] - district.statewide_test.third_grade.min[0])
          districts_growth << [district.name, growth]
        end
        districts_growth
        binding.pry
      elsif args[:grade] == 8
        @dr.districts.collect do |district|
          growth = (district.statewide_test.eighth_grade.max[1][args[:subject]] - 
            district.statewide_test.eighth_grade.min[1][args[:subject]]) /
          (district.statewide_test.eighth_grade.max[0] - district.statewide_test.eighth_grade.min[0])
          [district.name, growth]
        end
      elsif args[:grade].nil?
        raise InsufficientInformationError
      else
        raise UnknownDataErrror
      end

    end


end