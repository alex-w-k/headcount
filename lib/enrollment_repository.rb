require 'pry'
require 'csv'
require_relative 'enrollment'

class EnrollmentRepository
  attr_reader :enrollments, :test

  def load_data(args)
    data_set = args[:enrollment][:kindergarten]
    contents = CSV.open(data_set, {headers: true, header_converters: :symbol})
    @enrollments = collect_enrollments(contents)
    @test = @enrollments.uniq do |enrollment|
      enrollment.name
    end
    collate_years
    contents
  end

  def collect_enrollments(contents)
    contents.collect do |row|
      row[:name] = row[:location]
      row[:timeframe] = row[:timeframe].to_i
      row[:data] = row[:data].to_f
      Enrollment.new({:name => row[:name], 
                      :kindergarten_participation => 
                      {row[:timeframe] => row[:data]}})
    end
  end

  def find_by_name(name)
    @enrollments.find do |enrollment|
      enrollment.name == name
    end
  end

  def collate_years
    @test = @enrollments.uniq do |enrollment|
      enrollment.name
    end
    @enrollments.each do |enrollment|
    @test.each do |en|
    if enrollment.name == en.name
      en.kindergarten_participation[enrollment.kindergarten_participation.keys.first] = enrollment.kindergarten_participation.values.first
      end
    end
    end
    @enrollments = @test
  end
    

end
