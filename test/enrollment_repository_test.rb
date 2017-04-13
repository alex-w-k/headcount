require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/enrollment_repository'

class EnrollmentRepositoryTest < Minitest::Test

  def setup
    @er = EnrollmentRepository.new
    @enrollment = {:enrollment => 
                   {:kindergarten =>
                    './data/Kindergartners in full-day program.csv'
                   }
    }
  end

  def test_it_initializes
    assert_instance_of EnrollmentRepository, @er
  end


  def test_it_can_find_by_name
    @er.load_data(@enrollment)

    assert_instance_of Enrollment, @er.find_by_name('ACADEMY 20')
    assert_equal 'ACADEMY 20', @er.find_by_name('ACADEMY 20').name
  end

  def test_loading_and_finding_enrollments
    @er.load_data(@enrollment)

    name = "GUNNISON WATERSHED RE1J"
    enrollment = @er.find_by_name(name)
    assert_equal name, enrollment.name
    assert enrollment.is_a?(Enrollment)
    assert_in_delta 0.144, 
      enrollment.kindergarten_participation_in_year(2004), 0.005
  end


end
