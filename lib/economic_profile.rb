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


end