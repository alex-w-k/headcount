require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/statewide_test'

class StatewideTestTest < Minitest::Test

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

end