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
    add_math_data_to_race_data
    add_reading_data_to_race_data
    add_writing_data_to_race_data
  end

  def collect_statewide_tests(contents)
    contents = CSV.open(@third_grade_data,
                        {headers: true, header_converters: :symbol})
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
    third_grade_contents = CSV.open(@third_grade_data,
                                  {headers: true, header_converters: :symbol})
    third_grade_contents.each do |row|
      row[:name] = row[:location].upcase
      row[:timeframe] = row[:timeframe].to_i
      row[:score] = row[:score].downcase
      if row[:data] == 'N/A' || row[:data] == 'LNE' || row[:data] == "#VALUE!"
        row[:data] = 'N/A'
      else
        row[:data] = ((row[:data].to_f)*1000).floor/1000.0
      end
      index = tests.find_index do |test|
          test.name == row[:location].upcase
      end
      if row[:score] == 'math'
        if tests[index].third_grade[row[:timeframe]]
          tests[index].third_grade[row[:timeframe]].merge!(math: row[:data])
        else
          tests[index].third_grade[row[:timeframe]] = {math: row[:data]}
        end
      elsif row[:score] == 'reading'
        if tests[index].third_grade[row[:timeframe]]
          tests[index].third_grade[row[:timeframe]].merge!(reading: row[:data])
        else
          tests[index].third_grade[row[:timeframe]] = {reading: row[:data]}
        end
      elsif row[:score] == 'writing'
        if tests[index].third_grade[row[:timeframe]]
          tests[index].third_grade[row[:timeframe]].merge!(writing: row[:data])
        else
          tests[index].third_grade[row[:timeframe]] = {writing: row[:data]}
        end
      end
    end
    tests
  end

    def add_eighth_grade_data_to_tests
    eighth_grade_contents = CSV.open(@eighth_grade_data,
                                    {headers: true, header_converters: :symbol})
    eighth_grade_contents.each do |row|
      row[:name] = row[:location].upcase
      row[:timeframe] = row[:timeframe].to_i
      row[:score] = row[:score].downcase
      if row[:data] == 'N/A' || row[:data] == 'LNE' || row[:data] == "#VALUE!"
        row[:data] = 'N/A'
      else
        row[:data] = ((row[:data].to_f)*1000).floor/1000.0
      end
      index = tests.find_index do |test|
          test.name == row[:location].upcase
      end
      if row[:score] == 'math'
        if tests[index].eighth_grade[row[:timeframe]]
          tests[index].eighth_grade[row[:timeframe]].merge!(math: row[:data])
        else
          tests[index].eighth_grade[row[:timeframe]] = {math: row[:data]}
        end
      elsif row[:score] == 'reading'
        if tests[index].eighth_grade[row[:timeframe]]
          tests[index].eighth_grade[row[:timeframe]].merge!(reading: row[:data])
        else
          tests[index].eighth_grade[row[:timeframe]] = {reading: row[:data]}
        end
      elsif row[:score] == 'writing'
        if tests[index].eighth_grade[row[:timeframe]]
          tests[index].eighth_grade[row[:timeframe]].merge!(writing: row[:data])
        else
          tests[index].eighth_grade[row[:timeframe]] = {writing: row[:data]}
        end
      end
    end
    tests
  end

  def add_math_data_to_race_data
    math_contents = CSV.open(@math, {headers: true, header_converters: :symbol})
    math_contents.each do |row|
      row[:name] = row[:location].upcase
      row[:timeframe] = row[:timeframe].to_i
      row[:race] = row[:race_ethnicity].downcase
      if row[:data] == 'N/A' || row[:data] == 'LNE' || row[:data] == "#VALUE!"
        row[:data] = 'N/A'
      else
        row[:data] = ((row[:data].to_f)*1000).floor/1000.0
      end
      index = tests.find_index do |test|
          test.name == row[:location].upcase
      end
      if row[:race] == 'all students'
        if tests[index].race_data[:all_students][row[:timeframe]]
          tests[index].race_data[:all_students][row[:timeframe]].merge!(
            math: row[:data])
        else
          tests[index].race_data[:all_students][row[:timeframe]] =
            {:math => row[:data]}
        end
      elsif row[:race] == 'asian'
        if tests[index].race_data[:asian][row[:timeframe]]
          tests[index].race_data[:asian][row[:timeframe]].merge!(
            math: row[:data])
        else
          tests[index].race_data[:asian][row[:timeframe]] =
            {:math => row[:data]}
        end
      elsif row[:race] == 'black'
        if tests[index].race_data[:black][row[:timeframe]]
          tests[index].race_data[:black][row[:timeframe]].merge!(
            math: row[:data])
        else
          tests[index].race_data[:black][row[:timeframe]] =
            {:math => row[:data]}
        end
      elsif row[:race] == 'hawaiian/pacific islander'
        if tests[index].race_data[:pacific_islander][row[:timeframe]]
          tests[index].race_data[:pacific_islander][row[:timeframe]].merge!(
            math: row[:data])
        else
          tests[index].race_data[:pacific_islander][row[:timeframe]] =
            {:math => row[:data]}
        end
      elsif row[:race] == 'hispanic'
        if tests[index].race_data[:hispanic][row[:timeframe]]
          tests[index].race_data[:hispanic][row[:timeframe]].merge!(
            math: row[:data])
        else
          tests[index].race_data[:hispanic][row[:timeframe]] =
            {:math => row[:data]}
        end
      elsif row[:race] == 'native american'
        if tests[index].race_data[:native_american][row[:timeframe]]
          tests[index].race_data[:native_american][row[:timeframe]].merge!(
            math: row[:data])
        else
          tests[index].race_data[:native_american][row[:timeframe]] =
            {:math => row[:data]}
        end
      elsif row[:race] == 'two or more'
        if tests[index].race_data[:two_or_more][row[:timeframe]]
          tests[index].race_data[:two_or_more][row[:timeframe]].merge!(
            math: row[:data])
        else
          tests[index].race_data[:two_or_more][row[:timeframe]] =
            {:math => row[:data]}
        end
      elsif row[:race] == 'white'
        if tests[index].race_data[:white][row[:timeframe]]
          tests[index].race_data[:white][row[:timeframe]].merge!(
            math: row[:data])
        else
          tests[index].race_data[:white][row[:timeframe]] =
            {:math => row[:data]}
        end
      end
    end
    tests
  end

  def add_reading_data_to_race_data
    reading_contents = CSV.open(@reading,
                                {headers: true, header_converters: :symbol})
    reading_contents.each do |row|
      row[:name] = row[:location].upcase
      row[:timeframe] = row[:timeframe].to_i
      row[:race] = row[:race_ethnicity].downcase
      if row[:data] == 'N/A' || row[:data] == 'LNE' || row[:data] == "#VALUE!"
        row[:data] = 'N/A'
      else
        row[:data] = ((row[:data].to_f)*1000).floor/1000.0
      end
      index = tests.find_index do |test|
          test.name == row[:location].upcase
      end
      if row[:race] == 'all students'
        if tests[index].race_data[:all_students][row[:timeframe]]
          tests[index].race_data[:all_students][row[:timeframe]].merge!(
            reading: row[:data])
        else
          tests[index].race_data[:all_students][row[:timeframe]] =
            {:reading => row[:data]}
        end
      elsif row[:race] == 'asian'
        if tests[index].race_data[:asian][row[:timeframe]]
          tests[index].race_data[:asian][row[:timeframe]].merge!(
            reading: row[:data])
        else
          tests[index].race_data[:asian][row[:timeframe]] =
            {:reading => row[:data]}
        end
      elsif row[:race] == 'black'
        if tests[index].race_data[:black][row[:timeframe]]
          tests[index].race_data[:black][row[:timeframe]].merge!(
            reading: row[:data])
        else
          tests[index].race_data[:black][row[:timeframe]] =
            {:reading => row[:data]}
        end
      elsif row[:race] == 'hawaiian/pacific islander'
        if tests[index].race_data[:pacific_islander][row[:timeframe]]
          tests[index].race_data[:pacific_islander][row[:timeframe]].merge!(
            reading: row[:data])
        else
          tests[index].race_data[:pacific_islander][row[:timeframe]] =
            {:reading => row[:data]}
        end
      elsif row[:race] == 'hispanic'
        if tests[index].race_data[:hispanic][row[:timeframe]]
          tests[index].race_data[:hispanic][row[:timeframe]].merge!(
            reading: row[:data])
        else
          tests[index].race_data[:hispanic][row[:timeframe]] =
            {:reading => row[:data]}
        end
      elsif row[:race] == 'native american'
        if tests[index].race_data[:native_american][row[:timeframe]]
          tests[index].race_data[:native_american][row[:timeframe]].merge!(
            reading: row[:data])
        else
          tests[index].race_data[:native_american][row[:timeframe]] =
            {:reading => row[:data]}
        end
      elsif row[:race] == 'two or more'
        if tests[index].race_data[:two_or_more][row[:timeframe]]
          tests[index].race_data[:two_or_more][row[:timeframe]].merge!(
            reading: row[:data])
        else
          tests[index].race_data[:two_or_more][row[:timeframe]] =
            {:reading => row[:data]}
        end
      elsif row[:race] == 'white'
        if tests[index].race_data[:white][row[:timeframe]]
          tests[index].race_data[:white][row[:timeframe]].merge!(
            reading: row[:data])
        else
          tests[index].race_data[:white][row[:timeframe]] =
            {:reading => row[:data]}
        end
      end
    end
    tests
  end

  def add_writing_data_to_race_data
    writing_contents = CSV.open(@writing,
                                {headers: true, header_converters: :symbol})
    writing_contents.each do |row|
      row[:name] = row[:location].upcase
      row[:timeframe] = row[:timeframe].to_i
      row[:race] = row[:race_ethnicity].downcase
      if row[:data] == 'N/A' || row[:data] == 'LNE' || row[:data] == "#VALUE!"
        row[:data] = 'N/A'
      else
        row[:data] = ((row[:data].to_f)*1000).floor/1000.0
      end
      index = tests.find_index do |test|
          test.name == row[:location].upcase
      end
      if row[:race] == 'all students'
        if tests[index].race_data[:all_students][row[:timeframe]]
          tests[index].race_data[:all_students][row[:timeframe]].merge!(
            writing: row[:data])
        else
          tests[index].race_data[:all_students][row[:timeframe]] =
            {:writing => row[:data]}
        end
      elsif row[:race] == 'asian'
        if tests[index].race_data[:asian][row[:timeframe]]
          tests[index].race_data[:asian][row[:timeframe]].merge!(
            writing: row[:data])
        else
          tests[index].race_data[:asian][row[:timeframe]] =
            {:writing => row[:data]}
        end
      elsif row[:race] == 'black'
        if tests[index].race_data[:black][row[:timeframe]]
          tests[index].race_data[:black][row[:timeframe]].merge!(
            writing: row[:data])
        else
          tests[index].race_data[:black][row[:timeframe]] =
            {:writing => row[:data]}
        end
      elsif row[:race] == 'hawaiian/pacific islander'
        if tests[index].race_data[:pacific_islander][row[:timeframe]]
          tests[index].race_data[:pacific_islander][row[:timeframe]].merge!(
            writing: row[:data])
        else
          tests[index].race_data[:pacific_islander][row[:timeframe]] =
            {:writing => row[:data]}
        end
      elsif row[:race] == 'hispanic'
        if tests[index].race_data[:hispanic][row[:timeframe]]
          tests[index].race_data[:hispanic][row[:timeframe]].merge!(
            writing: row[:data])
        else
          tests[index].race_data[:hispanic][row[:timeframe]] =
            {:writing => row[:data]}
        end
      elsif row[:race] == 'native american'
        if tests[index].race_data[:native_american][row[:timeframe]]
          tests[index].race_data[:native_american][row[:timeframe]].merge!(
            writing: row[:data])
        else
          tests[index].race_data[:native_american][row[:timeframe]] =
            {:writing => row[:data]}
        end
      elsif row[:race] == 'two or more'
        if tests[index].race_data[:two_or_more][row[:timeframe]]
          tests[index].race_data[:two_or_more][row[:timeframe]].merge!(
            writing: row[:data])
        else
          tests[index].race_data[:two_or_more][row[:timeframe]] =
            {:writing => row[:data]}
        end
      elsif row[:race] == 'white'
        if tests[index].race_data[:white][row[:timeframe]]
          tests[index].race_data[:white][row[:timeframe]].merge!(
            writing: row[:data])
        else
          tests[index].race_data[:white][row[:timeframe]] =
            {:writing => row[:data]}
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