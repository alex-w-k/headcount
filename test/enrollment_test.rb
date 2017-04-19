require_relative 'test_helper'
require_relative '../lib/enrollment'


class EnrollmentTest < Minitest::Test

  def setup
    @e = Enrollment.new({:name => "ACADEMY 20",
              					 :kindergarten_participation => 
              					 	{ 2010 => 0.391,
               						  2011 => 0.353,
               		          2012 => 0.267
                            },
                          :high_school_graduation =>
                          { 2010 => 0.895,
                            2011 => 0.895,
                            2012 => 0.889,
                            2013 => 0.913,
                            2014 => 0.898,
                            }
                          })
  end

  def test_it_initializes
    assert_instance_of Enrollment, @e
  end

  def test_it_grabs_name
    assert_equal "ACADEMY 20", @e.name
  end

  def test_kindergarten_participation_by_year
    hash = { 2010 => 0.391,
              2011 => 0.353,
              2012 => 0.267
            }
  	assert_equal hash, @e.kindergarten_participation
  end

  def test_kindergarten_participation_in_year
    assert_equal 0.391, @e.kindergarten_participation_in_year(2010)
  end

  def test_graduation_by_year
  end


end
