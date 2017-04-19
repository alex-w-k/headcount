require 'csv'
require_relative 'statewide_test'
require_relative 'parser'

class StatewideTestRepository
  include Parser

  attr_reader :tests

  def load_data(args)
    @third_grade_data = args[:statewide_testing][:third_grade]
    @eighth_grade_data = args[:statewide_testing][:eighth_grade]
    @math = args[:statewide_testing][:math]
    @reading = args[:statewide_testing][:reading]
    @writing = args[:statewide_testing][:writing]
    @tests = collect_statewide_tests(@third_grade_data)
    add_data
  end

  def add_data
    uniqueize_statewide_tests
    add_third_grade_data_to_tests
    add_eighth_grade_data_to_tests
    add_math_data_to_race_data
    add_reading_data_to_race_data
    add_writing_data_to_race_data
  end

  def collect_statewide_tests(contents)
    contents = CSV.open(@third_grade_data,
                        {headers: true, header_converters: :symbol})
    contents.collect do |row|
      parse_name(row)
      StatewideTest.new({:name => row[:name]})
    end
  end

  def uniqueize_statewide_tests
    tests.uniq! do |test|
      test.name
    end
  end

  def add_third_grade_data_to_tests
    third_grade_contents = CSV.open(@third_grade_data,
                                  {headers: true, header_converters: :symbol})
    third_grade_contents.each do |row|
      parse_name(row)
      parse_timeframe(row)
      parse_score(row)
      parse_data(row)
      add_third_grade_scores_to_tests(row)
    end
    tests
  end

  def add_eighth_grade_data_to_tests
    eighth_grade_contents = CSV.open(@eighth_grade_data,
                                    {headers: true, header_converters: :symbol})
    eighth_grade_contents.each do |row|
      parse_name(row)
      parse_timeframe(row)
      parse_score(row)
      parse_data(row)
      add_eighth_grade_scores_to_tests(row)
    end
    tests
  end

  def add_math_data_to_race_data
    math_contents = CSV.open(@math, {headers: true, header_converters: :symbol})
    math_contents.each do |row|
      parse_name(row)
      parse_timeframe(row)
      parse_race_ethnicity(row)
      parse_data(row)
      process_race_data(row, :math)
    end
    tests
  end

  def add_reading_data_to_race_data
    reading_contents = CSV.open(@reading,
                                {headers: true, header_converters: :symbol})
    reading_contents.each do |row|
      parse_name(row)
      parse_timeframe(row)
      parse_race_ethnicity(row)
      parse_data(row)
      process_race_data(row, :reading)
    end
    tests
  end

  def add_writing_data_to_race_data
    writing_contents = CSV.open(@writing,
                                {headers: true, header_converters: :symbol})
    writing_contents.each do |row|
      parse_name(row)
      parse_timeframe(row)
      parse_race_ethnicity(row)
      parse_data(row)
      process_race_data(row, :writing)
    end
    tests
  end

  def index_finder(row)
    tests.find_index do |test|
      test.name == row[:location].upcase
    end
  end

  def find_by_name(name)
    tests.find do |test|
      test.name == name
    end
  end

  def add_third_grade_scores_to_tests(row)
    if row[:score] == 'math'
      if tests[index_finder(row)].third_grade[row[:timeframe]]
        tests[index_finder(row)].third_grade[row[:timeframe]].merge!(math: row[:data])
      else
        tests[index_finder(row)].third_grade[row[:timeframe]] = {math: row[:data]}
      end
    elsif row[:score] == 'reading'
      if tests[index_finder(row)].third_grade[row[:timeframe]]
        tests[index_finder(row)].third_grade[row[:timeframe]].merge!(reading: row[:data])
      else
        tests[index_finder(row)].third_grade[row[:timeframe]] = {reading: row[:data]}
      end
    elsif row[:score] == 'writing'
      if tests[index_finder(row)].third_grade[row[:timeframe]]
        tests[index_finder(row)].third_grade[row[:timeframe]].merge!(writing: row[:data])
      else
        tests[index_finder(row)].third_grade[row[:timeframe]] = {writing: row[:data]}
      end
    end
  end

  def add_eighth_grade_scores_to_tests(row)
    if row[:score] == 'math'
      if tests[index_finder(row)].eighth_grade[row[:timeframe]]
        tests[index_finder(row)].eighth_grade[row[:timeframe]].merge!(math: row[:data])
      else
        tests[index_finder(row)].eighth_grade[row[:timeframe]] = {math: row[:data]}
      end
    elsif row[:score] == 'reading'
      if tests[index_finder(row)].eighth_grade[row[:timeframe]]
        tests[index_finder(row)].eighth_grade[row[:timeframe]].merge!(reading: row[:data])
      else
        tests[index_finder(row)].eighth_grade[row[:timeframe]] = {reading: row[:data]}
      end
    elsif row[:score] == 'writing'
      if tests[index_finder(row)].eighth_grade[row[:timeframe]]
        tests[index_finder(row)].eighth_grade[row[:timeframe]].merge!(writing: row[:data])
      else
        tests[index_finder(row)].eighth_grade[row[:timeframe]] = {writing: row[:data]}
      end
    end
  end

  def process_race_data(row, subject)
    if row[:race] == 'all students'
      if tests[index_finder(row)].race_data[:all_students][row[:timeframe]]
        tests[index_finder(row)].race_data[:all_students][row[:timeframe]].merge!(
          subject => row[:data])
      else
        tests[index_finder(row)].race_data[:all_students][row[:timeframe]] =
          {subject => row[:data]}
      end
    elsif row[:race] == 'asian'
      if tests[index_finder(row)].race_data[:asian][row[:timeframe]]
        tests[index_finder(row)].race_data[:asian][row[:timeframe]].merge!(
          subject => row[:data])
      else
        tests[index_finder(row)].race_data[:asian][row[:timeframe]] =
          {subject => row[:data]}
      end
    elsif row[:race] == 'black'
      if tests[index_finder(row)].race_data[:black][row[:timeframe]]
        tests[index_finder(row)].race_data[:black][row[:timeframe]].merge!(
          subject => row[:data])
      else
        tests[index_finder(row)].race_data[:black][row[:timeframe]] =
          {subject => row[:data]}
      end
    elsif row[:race] == 'hawaiian/pacific islander'
      if tests[index_finder(row)].race_data[:pacific_islander][row[:timeframe]]
        tests[index_finder(row)].race_data[:pacific_islander][row[:timeframe]].merge!(
          subject => row[:data])
      else
        tests[index_finder(row)].race_data[:pacific_islander][row[:timeframe]] =
          {subject => row[:data]}
      end
    elsif row[:race] == 'hispanic'
      if tests[index_finder(row)].race_data[:hispanic][row[:timeframe]]
        tests[index_finder(row)].race_data[:hispanic][row[:timeframe]].merge!(
          subject => row[:data])
      else
        tests[index_finder(row)].race_data[:hispanic][row[:timeframe]] =
          {subject => row[:data]}
      end
    elsif row[:race] == 'native american'
      if tests[index_finder(row)].race_data[:native_american][row[:timeframe]]
        tests[index_finder(row)].race_data[:native_american][row[:timeframe]].merge!(
          subject => row[:data])
      else
        tests[index_finder(row)].race_data[:native_american][row[:timeframe]] =
          {subject => row[:data]}
      end
    elsif row[:race] == 'two or more'
      if tests[index_finder(row)].race_data[:two_or_more][row[:timeframe]]
        tests[index_finder(row)].race_data[:two_or_more][row[:timeframe]].merge!(
          subject => row[:data])
      else
        tests[index_finder(row)].race_data[:two_or_more][row[:timeframe]] =
          {subject => row[:data]}
      end
    elsif row[:race] == 'white'
      if tests[index_finder(row)].race_data[:white][row[:timeframe]]
        tests[index_finder(row)].race_data[:white][row[:timeframe]].merge!(
          subject => row[:data])
      else
        tests[index_finder(row)].race_data[:white][row[:timeframe]] =
          {subject => row[:data]}
      end
    end
  end
end