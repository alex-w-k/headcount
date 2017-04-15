require 'pry'
require 'csv'
require_relative 'district'
require_relative 'enrollment_repository'

class DistrictRepository
  attr_reader :districts, :enrollments

  def load_data(args)
    if args[:enrollment]
      er = EnrollmentRepository.new
      er.load_data(args)
      @enrollments = er.load_data(args)
    end
    data_set = args[:enrollment][:kindergarten]
    process_district_data(data_set)
  end

  def process_district_data(data_set)
    contents = CSV.open(data_set, {headers: true, header_converters: :symbol})
    @districts = contents.collect do |row|
      row[:name] = row[:location]
      District.new(row)
    end
    @districts.uniq! {|district| district.name}
    add_enrollment_to_district
  end

  def add_enrollment_to_district
    @districts.each_with_index do |district, index|
      district.enrollment = @enrollments[index]
    end
  end

  def find_by_name(name)
    @districts.find do |district|
      district.name == name
    end
  end

  def find_all_matching(name)
    index = name.length - 1
    @districts.find_all do |district|
      district.name[0..index] == name[0..index]
    end
  end
end

binding.pry
""