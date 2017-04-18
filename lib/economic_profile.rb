require 'pry'
require 'csv'
require_relative 'custom_errors'

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
    if @title_i.nil?
      @title_i = Hash.new
    end
  end

  def median_household_income_in_year(year)
    keys_for_use = @median_household_income.keys.map do |key|
      if (key[0]..key[1]).to_a.include?(year)
        key
      end
    end
    if keys_for_use.compact.count == 0
      raise UnknownDataError
    end
    incomes = keys_for_use.compact.map do |key|
      @median_household_income[key]
    end
    (incomes.inject(:+) / incomes.count)
  end

  def median_household_income_average
    (@median_household_income.values.inject(:+) / 
    @median_household_income.values.count)
  end

  def children_in_poverty_in_year(year)
    if @children_in_poverty[year].nil?
      raise UnknownDataError
    else
      @children_in_poverty[year]
    end
  end

  def free_or_reduced_price_lunch_percentage_in_year(year)
    if @free_or_reduced_price_lunch[year].nil?
      raise UnknownDataError
    else
      @free_or_reduced_price_lunch[year][:percentage]
    end
  end

  def free_or_reduced_price_lunch_number_in_year(year)
    if @free_or_reduced_price_lunch[year].nil?
      raise UnknownDataError
    else
      @free_or_reduced_price_lunch[year][:total]
    end
  end

  def title_i_in_year(year)
    if @title_i[year].nil?
      raise UnknownDataError
    else
      @title_i[year]
    end
  end



end