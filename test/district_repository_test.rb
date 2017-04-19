require_relative 'test_helper'
require_relative '../lib/district_repository'


class DistrictRepositoryTest < Minitest::Test

  def setup
    @dr = DistrictRepository.new
    @kinder_data = { :enrollment => 
                   { :kindergarten =>
                    './data/Kindergartners in full-day program.csv' 
                    }}
    @economic_data = {
                      :enrollment => {
                        :kindergarten =>
                        './data/Kindergartners in full-day program.csv' 
                        },
                      :economic_profile => {
                        :median_household_income => "./data/Median household income.csv",
                        :children_in_poverty => "./data/School-aged children in poverty.csv",
                        :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv",
                        :title_i => "./data/Title I students.csv"
                      }
                    }
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

  def test_it_can_load_economic_data
    @dr.load_data(@economic_data)

    district = @dr.find_by_name('ACADEMY 20')
    assert_equal 'ACADEMY 20', district.name
    assert_instance_of EconomicProfile, district.economic_profile
  end

end
