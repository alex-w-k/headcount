require_relative 'test_helper'
require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/economic_profile_repository'


class EconomicProfileRepositoryTest < Minitest::Test

  def setup
  	@epr = EconomicProfileRepository.new
  	@loaded ||= @epr.load_data({
  		  :economic_profile => {
		    :median_household_income => "./data/Median household income.csv",
		    :children_in_poverty => "./data/School-aged children in poverty.csv",
		    :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv",
		    :title_i => "./data/Title I students.csv"
		}
  		})
  	@profile = @epr.find_by_name('ACADEMY 20')
  end

  def test_it_initializes
  	assert_instance_of EconomicProfileRepository, @epr
  end

  def test_it_can_load_data_and_find_by_name
  	assert_instance_of Array, @loaded
  	assert_instance_of EconomicProfile, @profile
  	assert_equal 'ACADEMY 20', @profile.name
  end


end