require_relative 'test_helper'
require_relative '../lib/district'

class DistrictTest < Minitest::Test

  def setup
    @d = District.new({:name => "ACADEMY 20"})
  end

  def test_it_initializes
    assert_instance_of District, @d
  end

  def test_it_grabs_name
    assert_equal "ACADEMY 20", @d.name
  end
end