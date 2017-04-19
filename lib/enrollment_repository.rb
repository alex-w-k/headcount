require 'pry'
require 'csv'
require_relative 'enrollment'

class EnrollmentRepository
  attr_reader :enrollments, :test

  def load_data(args)
    @kinder_data_set = args[:enrollment][:kindergarten]
    @hs_data_set = args[:enrollment][:high_school_graduation]
    kindergarten_contents = CSV.open(@kinder_data_set,
      {headers: true, header_converters: :symbol})
    @enrollments = collect_enrollments(kindergarten_contents)
    uniqueize_enrollments
    add_kindergarten_data_to_enrollments
    if !@hs_data_set.nil?
      add_high_school_data_to_enrollments
    end
    enrollments
  end

  def collect_enrollments(contents)
    contents.collect do |row|
      row[:name] = row[:location].upcase
      Enrollment.new({:name => row[:name]})
    end
  end

  def uniqueize_enrollments
    enrollments.uniq! do |enrollment|
      enrollment.name
    end
  end


  def add_kindergarten_data_to_enrollments
    kindergarten_contents =
      CSV.open(@kinder_data_set, {headers: true, header_converters: :symbol})
    kindergarten_contents.each do |row|
      row[:name] = row[:location].upcase
      row[:timeframe] = row[:timeframe].to_i
      row[:data] = row[:data].to_f
      index = enrollments.find_index do |enrollment|
            enrollment.name == row[:location].upcase
          end
      enrollments[index].kindergarten_participation[row[:timeframe]] =
        row[:data]
    end
    enrollments
  end

  def add_high_school_data_to_enrollments
    high_school_grad_contents = CSV.open(@hs_data_set,
      {headers: true, header_converters: :symbol})
    high_school_grad_contents.each do |row|
      row[:name] = row[:location].upcase
      row[:timeframe] = row[:timeframe].to_i
      row[:data] = row[:data].to_f
      index = enrollments.find_index do |enrollment|
            enrollment.name == row[:location].upcase
          end
      enrollments[index].high_school_graduation_rates[row[:timeframe]] =
        row[:data]
    end
    enrollments
  end

  def find_by_name(name)
    enrollments.find do |enrollment|
      enrollment.name == name
    end
  end

end