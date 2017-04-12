require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/enrollment'

class EnrollmentTest < Minitest::Test

  def setup
    @e = Enrollment.new({:name => "ACADEMY 20"})
  end

  def test_it_initializes
    assert_instance_of Enrollment, @e
  end

  def test_it_grabs_name
    assert_equal "ACADEMY 20", @e.name
  end
end
