require_relative 'test_helper'
require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/district_repository'


class DistrictRepositoryTest < Minitest::Test

  def setup
    @dr = DistrictRepository.new
    @kinder_data = { :enrollment => 
                   { :kindergarten =>
                    './data/Kindergartners in full-day program.csv' 
                    }}
  end

  def test_it_initializes
    assert_instance_of DistrictRepository, @dr
  end

  def test_it_can_find_by_name
    @dr.load_data(@kinder_data)

    assert_instance_of District, @dr.find_by_name('ACADEMY 20')
    assert_equal 'ACADEMY 20', @dr.find_by_name('ACADEMY 20').name
  end

  def test_it_can_find_all_matching
    @dr.load_data(@kinder_data)

    assert_instance_of Array, @dr.find_all_matching('ACADEMY 20')
    assert_equal 1, @dr.find_all_matching('ACADEMY 20').length
    assert_equal 7, @dr.find_all_matching('WE').length
  end

  def test_it_can_call_on_enrollments_from_this_class
    @dr.load_data(@kinder_data)
    district = @dr.find_by_name("ACADEMY 20")

    assert_instance_of Enrollment, district.enrollment
    assert_equal 0.436, district.enrollment.kindergarten_participation_in_year(2010)
  end

end
