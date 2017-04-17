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
    add_eighth_grade_data_to_tests
    add_math_data_by_race_to_tests
    add_reading_data_by_race_to_tests
    add_writing_data_by_race_to_tests
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

    def add_eighth_grade_data_to_tests
    eighth_grade_contents = CSV.open(@eighth_grade_data, {headers: true, header_converters: :symbol})
    eighth_grade_contents.each do |row|
      row[:name] = row[:location].upcase
      row[:timeframe] = row[:timeframe].to_i
      row[:score] = row[:score].downcase
      row[:data] = row[:data].to_f
      index = tests.find_index do |test|
          test.name == row[:location].upcase
      end
      if row[:score] == 'math'
        if tests[index].eighth_grade[row[:timeframe]] != nil
          tests[index].eighth_grade[row[:timeframe]].merge!(math: row[:data])
        else
          tests[index].eighth_grade[row[:timeframe]] = {math: row[:data]}
        end
      elsif row[:score] == 'reading'
        if tests[index].eighth_grade[row[:timeframe]] != nil
          tests[index].eighth_grade[row[:timeframe]].merge!(reading: row[:data])
        else
          tests[index].eighth_grade[row[:timeframe]] = {reading: row[:data]}
        end
      elsif row[:score] == 'writing'
        if tests[index].eighth_grade[row[:timeframe]] != nil
          tests[index].eighth_grade[row[:timeframe]].merge!(writing: row[:data])
        else
          tests[index].eighth_grade[row[:timeframe]] = {writing: row[:data]}
        end
      end
    end
    tests
  end

  def add_math_data_by_race_to_tests
    math_contents = CSV.open(@math, {headers: true, header_converters: :symbol})
    math_contents.each do |row|
      row[:name] = row[:location].upcase
      row[:timeframe] = row[:timeframe].to_i
      row[:race] = row[:race_ethnicity].downcase
      row[:data] = row[:data].to_f
      index = tests.find_index do |test|
          test.name == row[:location].upcase
      end
      if row[:race] == 'all students'
        if tests[index].math[row[:timeframe]] != nil
          tests[index].math[row[:timeframe]].merge!(all_students: row[:data])
        else
          tests[index].math[row[:timeframe]] = {all_students: row[:data]}
        end
      elsif row[:race] == 'asian'
        if tests[index].math[row[:timeframe]] != nil
          tests[index].math[row[:timeframe]].merge!(asian: row[:data])
        else
          tests[index].math[row[:timeframe]] = {asian: row[:data]}
        end
      elsif row[:race] == 'black'
        if tests[index].math[row[:timeframe]] != nil
          tests[index].math[row[:timeframe]].merge!(black: row[:data])
        else
          tests[index].math[row[:timeframe]] = {black: row[:data]}
        end
      elsif row[:race] == 'hawaiian/pacific islander'
        if tests[index].math[row[:timeframe]] != nil
          tests[index].math[row[:timeframe]].merge!(pacific_islander: row[:data])
        else
          tests[index].math[row[:timeframe]] = {pacific_islander: row[:data]}
        end
      elsif row[:race] == 'hispanic'
        if tests[index].math[row[:timeframe]] != nil
          tests[index].math[row[:timeframe]].merge!(hispanic: row[:data])
        else
          tests[index].math[row[:timeframe]] = {hispanic: row[:data]}
        end
      elsif row[:race] == 'native american'
        if tests[index].math[row[:timeframe]] != nil
          tests[index].math[row[:timeframe]].merge!(native_american: row[:data])
        else
          tests[index].math[row[:timeframe]] = {native_american: row[:data]}
        end
      elsif row[:race] == 'two or more'
        if tests[index].math[row[:timeframe]] != nil
          tests[index].math[row[:timeframe]].merge!(two_or_more: row[:data])
        else
          tests[index].math[row[:timeframe]] = {two_or_more: row[:data]}
        end
      elsif row[:race] == 'white'
        if tests[index].math[row[:timeframe]] != nil
          tests[index].math[row[:timeframe]].merge!(white: row[:data])
        else
          tests[index].math[row[:timeframe]] = {white: row[:data]}
        end
      end
    end
    tests
  end

  def add_reading_data_by_race_to_tests
    reading_contents = CSV.open(@reading, {headers: true, header_converters: :symbol})
    reading_contents.each do |row|
      row[:name] = row[:location].upcase
      row[:timeframe] = row[:timeframe].to_i
      row[:race] = row[:race_ethnicity].downcase
      row[:data] = row[:data].to_f
      index = tests.find_index do |test|
          test.name == row[:location].upcase
      end
      if row[:race] == 'all students'
        if tests[index].reading[row[:timeframe]] != nil
          tests[index].reading[row[:timeframe]].merge!(all_students: row[:data])
        else
          tests[index].reading[row[:timeframe]] = {all_students: row[:data]}
        end
      elsif row[:race] == 'asian'
        if tests[index].reading[row[:timeframe]] != nil
          tests[index].reading[row[:timeframe]].merge!(asian: row[:data])
        else
          tests[index].reading[row[:timeframe]] = {asian: row[:data]}
        end
      elsif row[:race] == 'black'
        if tests[index].reading[row[:timeframe]] != nil
          tests[index].reading[row[:timeframe]].merge!(black: row[:data])
        else
          tests[index].reading[row[:timeframe]] = {black: row[:data]}
        end
      elsif row[:race] == 'hawaiian/pacific islander'
        if tests[index].reading[row[:timeframe]] != nil
          tests[index].reading[row[:timeframe]].merge!(pacific_islander: row[:data])
        else
          tests[index].reading[row[:timeframe]] = {pacific_islander: row[:data]}
        end
      elsif row[:race] == 'hispanic'
        if tests[index].reading[row[:timeframe]] != nil
          tests[index].reading[row[:timeframe]].merge!(hispanic: row[:data])
        else
          tests[index].reading[row[:timeframe]] = {hispanic: row[:data]}
        end
      elsif row[:race] == 'native american'
        if tests[index].reading[row[:timeframe]] != nil
          tests[index].reading[row[:timeframe]].merge!(native_american: row[:data])
        else
          tests[index].reading[row[:timeframe]] = {native_american: row[:data]}
        end
      elsif row[:race] == 'two or more'
        if tests[index].reading[row[:timeframe]] != nil
          tests[index].reading[row[:timeframe]].merge!(two_or_more: row[:data])
        else
          tests[index].reading[row[:timeframe]] = {two_or_more: row[:data]}
        end
      elsif row[:race] == 'white'
        if tests[index].reading[row[:timeframe]] != nil
          tests[index].reading[row[:timeframe]].merge!(white: row[:data])
        else
          tests[index].reading[row[:timeframe]] = {white: row[:data]}
        end
      end
    end
    tests
  end

  def add_writing_data_by_race_to_tests
    writing_contents = CSV.open(@writing, {headers: true, header_converters: :symbol})
    writing_contents.each do |row|
      row[:name] = row[:location].upcase
      row[:timeframe] = row[:timeframe].to_i
      row[:race] = row[:race_ethnicity].downcase
      row[:data] = row[:data].to_f
      index = tests.find_index do |test|
          test.name == row[:location].upcase
      end
      if row[:race] == 'all students'
        if tests[index].writing[row[:timeframe]] != nil
          tests[index].writing[row[:timeframe]].merge!(all_students: row[:data])
        else
          tests[index].writing[row[:timeframe]] = {all_students: row[:data]}
        end
      elsif row[:race] == 'asian'
        if tests[index].writing[row[:timeframe]] != nil
          tests[index].writing[row[:timeframe]].merge!(asian: row[:data])
        else
          tests[index].writing[row[:timeframe]] = {asian: row[:data]}
        end
      elsif row[:race] == 'black'
        if tests[index].writing[row[:timeframe]] != nil
          tests[index].writing[row[:timeframe]].merge!(black: row[:data])
        else
          tests[index].writing[row[:timeframe]] = {black: row[:data]}
        end
      elsif row[:race] == 'hawaiian/pacific islander'
        if tests[index].writing[row[:timeframe]] != nil
          tests[index].writing[row[:timeframe]].merge!(pacific_islander: row[:data])
        else
          tests[index].writing[row[:timeframe]] = {pacific_islander: row[:data]}
        end
      elsif row[:race] == 'hispanic'
        if tests[index].writing[row[:timeframe]] != nil
          tests[index].writing[row[:timeframe]].merge!(hispanic: row[:data])
        else
          tests[index].writing[row[:timeframe]] = {hispanic: row[:data]}
        end
      elsif row[:race] == 'native american'
        if tests[index].writing[row[:timeframe]] != nil
          tests[index].writing[row[:timeframe]].merge!(native_american: row[:data])
        else
          tests[index].writing[row[:timeframe]] = {native_american: row[:data]}
        end
      elsif row[:race] == 'two or more'
        if tests[index].writing[row[:timeframe]] != nil
          tests[index].writing[row[:timeframe]].merge!(two_or_more: row[:data])
        else
          tests[index].writing[row[:timeframe]] = {two_or_more: row[:data]}
        end
      elsif row[:race] == 'white'
        if tests[index].writing[row[:timeframe]] != nil
          tests[index].writing[row[:timeframe]].merge!(white: row[:data])
        else
          tests[index].writing[row[:timeframe]] = {white: row[:data]}
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

binding.pry
""