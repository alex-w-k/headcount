require 'minitest/autorun'
require 'minitest/pride'
require './lib/district_repository'

class DistrictRepositoryTest < Minitest::Test

  def setup
    @dr = DistrictRepository.new
  end

  def test_it_initializes
    assert_instance_of DistrictRepository, @dr
  end

  def test_it_can_read_contents
    assert_instance_of CSV, @dr.load_data
    assert_equal 'Percent', @dr.load_format
  end

end
