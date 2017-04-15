require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/headcount_analyst'

class HeadcountAnalystTest < Minitest::Test

  def setup
    @ha = HeadcountAnalyst.new
  end

  def test_instance_exists
    assert_instance_of HeadcountAnalyst, @ha
  end

  def test_kindergarten_participation_rate_for_one_district
    avg = @ha.average_kindergarten_participation_for_district("ACADEMY 20")
    assert_equal 0.406, avg

    
  end
end