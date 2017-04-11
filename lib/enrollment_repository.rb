require 'pry'
require 'csv'
require_relative 'enrollment'

class EnrollmentRepository
  attr_reader :enrollments

  def load_data(args)
    enrollment = args[:enrollment]
    data_set = enrollment[:kindergarten]
    contents = CSV.open(data_set, {headers: true, header_converters: :symbol})
    @enrollments = contents.collect do |row|
      row[:name] = row[:location]
      Enrollment.new(row)
    end
    contents
  end

  def load_format
  end

  # def find_by_name(name)
  #   @enrollments.find do |enrollment|
  #     enrollment.name == name
  #   end
  # end

  # def find_all_matching
  #   @enrollments.find_all do |enrollment|
  #     enrollment.name == name
  #   end
  # end
end

# binding.pry
# ""