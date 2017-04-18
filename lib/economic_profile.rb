require 'pry'
require 'csv'

class EconomicProfile
  attr_reader :name, :median_household_income, :children_in_poverty,
              :free_or_reduced_price_lunch, :title_i

  def initialize(args)
    @name = args[:name]
    @median_household_income = args[:median_household_income]
    if @median_household_income.nil?
      @median_household_income = Hash.new
    end
    @children_in_poverty = args[:children_in_poverty]
    if @children_in_poverty.nil?
      @children_in_poverty = Hash.new
    end
    @free_or_reduced_price_lunch = args[:free_or_reduced_price_lunch]
    if @free_or_reduced_price_lunch.nil?
      @free_or_reduced_price_lunch = Hash.new
    end
    @title_i = args[:title_i]
    if @race_data.nil?
      @title_i = Hash.new
    end
  end

  def median_household_income_in_year(year)
    # TODO need to be able to see if year is in range of the two in the array, 
    # then pull all incomes it works for then average all of them


    incomes = @median_household_income.map do |key, value|
      first = key[0]
      second = key[1]
      if (first..second).to_a.include?(year)
        value
      end
    end
    binding.pry
    incomes / incomes.count
  end


end