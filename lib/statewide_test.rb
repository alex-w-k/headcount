require 'pry'
require 'csv'
require_relative 'custom_errors'

class StatewideTest
  attr_reader :name, :third_grade, :eighth_grade, :race_data

  RACES = [:all_students, :asian, :black, :pacific_islander,
           :hispanic, :native_american, :two_or_more, :white]
  SUBJECTS = [:math, :reading, :writing]

  def initialize(args)
    @name = args[:name]
    @third_grade = args[:third_grade]
    if @third_grade.nil?
      @third_grade = Hash.new
    end
    @eighth_grade = args[:eighth_grade]
    if @eighth_grade.nil?
      @eighth_grade = Hash.new
    end
    @race_data = args[:race_data]
    if @race_data.nil?
      @race_data = {:all_students=>{},
                    :asian=>{},
                    :black=>{},
                    :pacific_islander=>{},
                    :hispanic=>{},
                    :native_american=>{},
                    :two_or_more=>{},
                    :white=>{}
                  }
    end
  end

  def proficient_by_grade(grade)
    if grade == 3
      @third_grade
    elsif grade == 8
      @eighth_grade
    else
      raise UnknownDataError
    end
  end

  def proficient_by_race_or_ethnicity(race)
    if RACES.include?(race)
      race_data[race]
    else
      raise UnknownRaceError
    end
  end

  def proficient_for_subject_by_grade_in_year(subject, grade, year)
    if grade == 3 and SUBJECTS.include?(subject)
      third_grade[year][subject]
    elsif grade == 8 and SUBJECTS.include?(subject)
      eighth_grade[year][subject]
    else
      raise UnknownDataError
    end
  end

  def proficient_for_subject_by_race_in_year(subject, race, year)
    if RACES.include?(race) and SUBJECTS.include?(subject)
      race_data[race][year][subject]
    else
      raise UnknownDataError
    end
  end
end