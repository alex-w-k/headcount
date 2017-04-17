require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/statewide_test_repository'

class StatewideTestRepositoryTest < Minitest::Test

	def setup
    @str = StatewideTestRepository.new
    @data = {
              :statewide_testing => {
                :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
                :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
                :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
                :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
                :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
              }
            }
    @str.load_data(@data)
	end

  def test_instance_of_str
    assert_instance_of StatewideTestRepository, @str
  end

  def test_can_load_data
    assert_instance_of Array, @str.load_data(@data)
  end

  def test_it_can_find_by_name
    assert_instance_of StatewideTest, @str.find_by_name('ACADEMY 20')
    assert_equal 'ACADEMY 20', @str.find_by_name('ACADEMY 20').name
  end


end