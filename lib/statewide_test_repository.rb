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
        if tests[index].third_grade[row[:timeframe]] != nil
          tests[index].third_grade[row[:timeframe]].merge!(math: row[:data])
        else
          tests[index].third_grade[row[:timeframe]] = {math: row[:data]}
        end
      elsif row[:score] == 'reading'
        if tests[index].third_grade[row[:timeframe]] != nil
          tests[index].third_grade[row[:timeframe]].merge!(reading: row[:data])
        else
          tests[index].third_grade[row[:timeframe]] = {reading: row[:data]}
        end
      elsif row[:score] == 'writing'
        if tests[index].third_grade[row[:timeframe]] != nil
          tests[index].third_grade[row[:timeframe]].merge!(writing: row[:data])
        else
          tests[index].third_grade[row[:timeframe]] = {writing: row[:data]}
        end
      end
    end
    tests
  end

  def find_by_name(name)
    tests.find do |test|
      test.name == name
    end
  end

end