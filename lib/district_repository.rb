require 'csv'
require_relative 'district'
require_relative 'enrollment_repository'
require_relative 'statewide_test_repository'
require_relative 'economic_profile_repository'
require_relative 'parser'

class DistrictRepository
  include Parser

  attr_reader :districts

  def load_data(args)
    data_set = args[:enrollment][:kindergarten]
    process_district_data(data_set)
    if args[:enrollment]
      load_enrollments(args)
    end
    if args[:statewide_testing]
      load_testing(args)
    end
    if args[:economic_profile]
      load_profiles(args)
    end
  end

  def load_enrollments(args)
    er = EnrollmentRepository.new
    @enrollments = er.load_data(args)
    add_enrollment_to_district
  end

  def load_testing(args)
    str = StatewideTestRepository.new
    @statewide_tests = str.load_data(args)
    add_statewide_tests_to_district
  end

  def load_profiles(args)
    epr = EconomicProfileRepository.new
    @economic_profiles = epr.load_data(args)
    add_economic_profiles_to_district
  end

  def process_district_data(data_set)
    contents = CSV.open(data_set, {headers: true, header_converters: :symbol})
    @districts = contents.collect do |row|
      parse_name(row)
      District.new(row)
    end
    districts.uniq! {|district| district.name}
  end

  def add_enrollment_to_district
    @districts.each_with_index do |district, index|
      district.enrollment = @enrollments[index]
    end
  end

  def add_statewide_tests_to_district
    @districts.each_with_index do |district, index|
      district.statewide_test = @statewide_tests[index]
    end
  end

  def add_economic_profiles_to_district
    @districts.each_with_index do |district, index|
      district.economic_profile = @economic_profiles[index]
    end
  end

  def find_by_name(name)
    districts.find do |district|
      district.name == name
    end
  end

  def find_all_matching(name)
    index = name.length - 1
    districts.find_all do |district|
      district.name[0..index] == name[0..index]
    end
  end
end