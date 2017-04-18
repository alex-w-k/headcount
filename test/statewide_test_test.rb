require_relative 'test_helper'
require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/statewide_test'
require_relative '../lib/statewide_test_repository'


class StatewideTestTest < Minitest::Test

  def setup
    @str = StatewideTestRepository.new
    @str.load_data({
                  :statewide_testing => {
                    :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
                    :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
                    :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
                    :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
                    :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
                                        }
                  })
    @statewide_test = @str.find_by_name("ACADEMY 20")

  end

  def test_instance_of_statewide_test
    assert_instance_of StatewideTest, @statewide_test
  end

  def test_proficient_by_grade_method
    result = { 2008 => {:math => 0.857, :reading => 0.866, :writing => 0.671},
     2009 => {:math => 0.824, :reading => 0.862, :writing => 0.706},
     2010 => {:math => 0.849, :reading => 0.864, :writing => 0.662},
     2011 => {:math => 0.819, :reading => 0.867, :writing => 0.678},
     2012 => {:math => 0.830, :reading => 0.870, :writing => 0.655},
     2013 => {:math => 0.855, :reading => 0.859, :writing => 0.668},
     2014 => {:math => 0.834, :reading => 0.831, :writing => 0.639}
   }
   assert_equal result, @statewide_test.proficient_by_grade(3)

   assert_raises UnknownDataError do 
     @statewide_test.proficient_by_grade(4)
     @statewide_test.proficient_by_grade(9)
     @statewide_test.proficient_by_grade(2)
    end
  end

  def test_proficient_by_race_or_ethnicity_method
    result = { 2011 => {math: 0.816, reading: 0.897, writing: 0.826},
     2012 => {math: 0.818, reading: 0.893, writing: 0.808},
     2013 => {math: 0.805, reading: 0.901, writing: 0.810},
     2014 => {math: 0.800, reading: 0.855, writing: 0.789},
              }
    assert_equal result, @statewide_test.proficient_by_race_or_ethnicity(:asian)
    assert_raises UnknownRaceError do 
      @statewide_test.proficient_by_race_or_ethnicity(:clown)
    end
  end

  def test_proficient_for_subject_by_grade_in_year_method
    assert_equal 0.857, @statewide_test.proficient_for_subject_by_grade_in_year(:math, 3, 2008)

    assert_raises UnknownDataError do 
     @statewide_test.proficient_for_subject_by_grade_in_year(:math, 5, 2008)
     @statewide_test.proficient_for_subject_by_grade_in_year(:math, 2, 2008)
     @statewide_test.proficient_for_subject_by_grade_in_year(:math, 9, 2008)
    end
  end
  
  def test_proficient_for_subject_by_race_in_year_method
    assert_equal 0.818, @statewide_test.proficient_for_subject_by_race_in_year(:math, :asian, 2012)

    assert_raises UnknownDataError do 
      @statewide_test.proficient_for_subject_by_race_in_year(:math, :whote, 2012)
    end
  end

end


