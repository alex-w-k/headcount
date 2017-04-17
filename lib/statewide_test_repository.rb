require 'pry'
require 'csv'
require_relative 'statewide_test'

class StatewideTestRepository
  attr_reader :tests

  def load_data(args)
    @third_grade_data = args[:statewide_testing][:third_grade]
    @eighth_grade_data = args[:statewide_testing][:eighth_grade]
    @math = args[:statewide_testing][:math]
    @reading = args[:statewide_testing][:reading]
    @writing = args[:statewide_testing][:writing]
    @tests = collect_statewide_tests(@third_grade_data)
    uniqueize_statewide_tests
    add_third_grade_data_to_tests
  end

  def collect_statewide_tests(contents)
    contents = CSV.open(@third_grade_data, {headers: true, header_converters: :symbol})
    contents.collect do |row|
      row[:name] = row[:location].upcase
      StatewideTest.new({:name => row[:name]})
    end
  end

  def uniqueize_statewide_tests
    tests.uniq! do |test|
      test.name
    end
  end

  def add_third_grade_data_to_tests
    third_grade_contents = CSV.open(@third_grade_data, {headers: true, header_converters: :symbol})
    third_grade_contents.each do |row|
      row[:name] = row[:location].upcase
      row[:timeframe] = row[:timeframe].to_i
      row[:score] = row[:score].downcase
      row[:data] = row[:data].to_f
      index = tests.find_index do |test|
          test.name == row[:location].upcase
        end
      if row[:score] == 'math'
        row[:math] = row[:score]
        row[:math_data] = row[:data]
      elsif row[:score] == 'reading'
        row[:reading] == row[:score]
        row[:reading_data] = row[:data]
      elsif row[:score] == 'writing'
        row[:writing] == row[:score]
        row[:writing_data] = row[:data]
      end
        
      tests[index].third_grade[row[:timeframe]] = {:math => row[:math_data], :reading => row[:reading_data], :writing => row[:writing_data]}
    end
    tests
  end

end

binding.pry
''