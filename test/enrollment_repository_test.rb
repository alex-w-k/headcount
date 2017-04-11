require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/enrollment_repository'

class EnrollmentRepositoryTest < Minitest::Test

  def setup
    @er = EnrollmentRepository.new
  end

  def test_it_initializes
    assert_instance_of EnrollmentRepository, @er
  end

  def test_it_can_read_contents
    assert_instance_of CSV, @er.load_data({ :enrollment => 
                                            { :kindergarten =>
                                              './data/Kindergartners in full-day program.csv' 
                                            }})
  end

  def test_it_can_find_by_name
    @er.load_data({ :enrollment => { :kindergarten => './data/Kindergartners in full-day program.csv' 
                                            }})

    assert_instance_of Enrollment, @er.find_by_name('ACADEMY 20')
    assert_equal 'ACADEMY 20', @er.find_by_name('ACADEMY 20').name
  end

  # def test_it_can_find_all_matching
  #   @er.load_data({ :enrollment => { :kindergarten => './data/Kindergartners in full-day program.csv' 
  #                                           }})

  #   assert_instance_of Array, @er.find_all_matching('ACADEMY 20')
  #   assert_equal 11, @er.find_all_matching('ACADEMY 20').length
  # end

end