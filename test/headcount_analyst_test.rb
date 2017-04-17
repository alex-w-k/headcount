require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/headcount_analyst'

class HeadcountAnalystTest < Minitest::Test

  def setup
    @dr = DistrictRepository.new
    @dr.load_data({
                    :enrollment => {
                    :kindergarten => "./data/Kindergartners in full-day program.csv",
                    :high_school_graduation => "./data/High school graduation rates.csv"
                    }
                  })
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

  # def test_high_school_graduation_rate_variation_trend
  #   trend = @ha.high_school_graduation_rate_variation_trend('ACADEMY 20', :against => 'COLORADO')
  #   assert_equal 0.717, trend[2008]
  # end
end