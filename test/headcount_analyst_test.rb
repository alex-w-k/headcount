require_relative 'test_helper'
require_relative '../lib/headcount_analyst'


class HeadcountAnalystTest < Minitest::Test

  def setup
    @dr = DistrictRepository.new
    @dr.load_data({
                  :enrollment => {
                    :kindergarten => "./data/Kindergartners in full-day program.csv",
                    :high_school_graduation => "./data/High school graduation rates.csv"
                  },
                  :statewide_testing => {
                    :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
                    :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
                    :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
                    :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
                    :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
                  }
                }
                )
    @ha = HeadcountAnalyst.new(@dr)
  end

  def test_instance_exists
    assert_instance_of HeadcountAnalyst, @ha
  end

  def test_kindergarten_participation_rate_for_one_district
    avg = @ha.average_kindergarten_participation_for_district("ACADEMY 20")
    assert_equal 0.406, avg    
  end

  def test_kindergarten_participation_rate_variation
    var_1 = @ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'COLORADO')
    assert_equal 0.766, var_1
    var_2 = @ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'YUMA SCHOOL DISTRICT 1')
    assert_in_delta 0.447, var_2, 0.005
  end

  def test_kindergarten_participation_rate_variation_trend
    trend = @ha.kindergarten_participation_rate_variation_trend('ACADEMY 20', :against => 'COLORADO')
    assert_equal 0.717, trend[2008]
  end

  def test_high_school_graduation_rate_for_one_district
    avg = @ha.average_high_school_graduation_rates_for_district('ACADEMY 20')
    assert_equal 0.898, avg 
  end

  def test_high_school_graduation_rate_variation
    var_1 = @ha.high_school_graduation_rate_variation('ACADEMY 20', :against => 'COLORADO')
    assert_equal 1.195, var_1
    var_2 = @ha.high_school_graduation_rate_variation('ACADEMY 20', :against => 'YUMA SCHOOL DISTRICT 1')
    assert_in_delta 1.011, var_2, 0.005
  end

  def test_kindergarten_participation_against_high_school_graduation
    var = @ha.kindergarten_participation_against_high_school_graduation('ACADEMY 20')
    assert_equal 0.641, var
  end

  def test_kindergarten_participation_correlates_with_high_school_graduation_by_district
    result = @ha.kindergarten_participation_correlates_with_high_school_graduation(for: 'ACADEMY 20')
    assert result
  end

  def test_kindergarten_participation_correlates_with_high_school_graduation_statewide
    result = @ha.kindergarten_participation_correlates_with_high_school_graduation(for: 'STATEWIDE')
    refute result
  end

  def test_kindergarten_participation_correlates_with_high_school_graduation_for_subset_of_districts
    districts = ['ACADEMY 20', 'PARK (ESTES PARK) R-3', 'YUMA SCHOOL DISTRICT 1']
    result = @ha.kindergarten_participation_correlates_with_high_school_graduation(across: districts)
    assert result
  end

  def test_top_statewide_test_year_over_year_growth
    result = @ha.top_statewide_test_year_over_year_growth(grade: 3, subject: :math)
    assert_equal ["WILEY RE-13 JT", 0.3], result
    result_1 = @ha.top_statewide_test_year_over_year_growth(grade: 3, subject: :reading)
    assert_equal ["CENTENNIAL R-1", 0.114], result_1
    result_2 = @ha.top_statewide_test_year_over_year_growth(grade: 8, subject: :math)
    assert_equal ["OURAY R-1", 0.242], result_2
    result_3 = @ha.top_statewide_test_year_over_year_growth(grade: 8, subject: :reading)
    assert_equal ["COTOPAXI RE-3", 0.13], result_3
    result_4 = @ha.top_statewide_test_year_over_year_growth(grade: 3, subject: :writing)
    assert_equal ["BETHUNE R-5", 0.148], result_4
    assert_raises InsufficientInformationError do 
      @ha.top_statewide_test_year_over_year_growth(subject: :reading)
    end
    assert_raises UnknownDataError do 
      @ha.top_statewide_test_year_over_year_growth(grade: 9, subject: :reading)
    end
  end

  def test_top_statewide_test_year_over_year_multiple_districts
    result = @ha.top_statewide_test_year_over_year_growth(grade: 3, top: 3, subject: :math)
    expected = [["WILEY RE-13 JT", 0.3], ["WESTMINSTER 50", 0.12], ["SANGRE DE CRISTO RE-22J", 0.071]]
    assert_equal expected, result
  end

  def test_top_statewide_test_year_over_year_average_of_subjects
    result = @ha.top_statewide_test_year_over_year_growth(grade: 3)
    expected = ["SANGRE DE CRISTO RE-22J", 0.071]
    assert_equal expected, result

    result_1 = @ha.top_statewide_test_year_over_year_growth(grade: 8)
    expected_1 = ["OURAY R-1", 0.11]
    assert_equal expected_1, result_1
  end

  def test_top_statewide_test_year_over_year_average_of_subjects_weighted
    result = @ha.top_statewide_test_year_over_year_growth(grade: 8, :weighting => {:math => 0.5, :reading => 0.5, :writing => 0.0})
    expected = ["OURAY R-1", 0.153]
    assert_equal expected, result
  end


  # def test_high_school_graduation_rate_variation_trend
  #   trend = @ha.high_school_graduation_rate_variation_trend('ACADEMY 20', :against => 'COLORADO')
  #   assert_equal 0.717, trend[2008]
  # end
end