require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/headcount_analyst'

class HeadcountAnalystTest < Minitest::Test

  def setup
    @dr = DistrictRepository.new
    @dr.load_data({
                  :enrollment => {
                    :kindergarten => "./data/Kindergartners in full-day program.csv"
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
    result = {2004=>1.257, 2005=>0.96, 2006=>1.05, 2007=>0.992, 2008=>0.717, 2009=>0.652, 2010=>0.681, 2011=>0.727, 2012=>0.688, 2013=>0.694, 2014=>0.661}
    assert_equal result, trend
  end
end