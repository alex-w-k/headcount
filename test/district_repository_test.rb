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
    assert_instance_of CSV, @dr.load_data({ :enrollment => 
                                            { :kindergarten =>
                                              './data/Kindergartners in full-day program.csv' 
                                            }})
  end

  def test_it_can_find_by_name
    @dr.load_data({ :enrollment => { :kindergarten => './data/Kindergartners in full-day program.csv' 
                                            }})

    assert_instance_of District, @dr.find_by_name('ACADEMY 20')
    assert_equal 'ACADEMY 20', @dr.find_by_name('ACADEMY 20').location
  end

end
