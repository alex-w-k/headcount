require_relative 'test_helper'
require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/economic_profile_repository'
require_relative '../lib/economic_profile'


class EconomicProfileTest < Minitest::Test

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
    @data = {:median_household_income => {[2005, 2009] => 50000, [2008, 2014] => 60000},
        :children_in_poverty => {2012 => 0.1845},
        :free_or_reduced_price_lunch => {2014 => {:percentage => 0.023, :total => 100}},
        :title_i => {2015 => 0.543},
        :name => "ACADEMY 20"
       }
  	@profile = @epr.find_by_name('ACADEMY 20')
  end

  def test_it_can_initialize
    profile = EconomicProfile.new(@data)
    assert_instance_of EconomicProfile, profile
  end

  def test_it_can_find_median_household_income_by_year
    assert_instance_of EconomicProfile, @profile
    assert_equal 87635, @profile.median_household_income_in_year(2009)
    assert_equal 85060, @profile.median_household_income_in_year(2005)
    assert_raises UnknownDataError do
      @profile.median_household_income_in_year(2000)
    end
  end

  def test_median_household_income_average_method
    assert_equal 87635, @profile.median_household_income_average
  end

  def test_children_in_poverty_in_year_method
    assert_equal 0.064, @profile.children_in_poverty_in_year(2012)
    assert_raises UnknownDataError do 
      @profile.children_in_poverty_in_year(1993)
    end
  end

  def test_free_or_reduced_price_lunch_percentage_in_year
    assert_equal 0.103, @profile.free_or_reduced_price_lunch_percentage_in_year(2009)
    assert_raises UnknownDataError do 
      @profile.free_or_reduced_price_lunch_percentage_in_year(1993)
    end
  end

  def test_free_or_reduced_price_lunch_number_in_year
    assert_equal 2058, @profile.free_or_reduced_price_lunch_number_in_year(2008)
    assert_raises UnknownDataError do 
      @profile.free_or_reduced_price_lunch_number_in_year(1993)
    end
  end

  def test_title_i_in_year
    assert_equal 0.01, @profile.title_i_in_year(2012)
    assert_raises UnknownDataError do 
      @profile.title_i_in_year(1993)
    end
  end


end
