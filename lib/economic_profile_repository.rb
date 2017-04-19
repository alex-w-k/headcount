require 'csv'
require_relative 'economic_profile'
require_relative 'parser'

class EconomicProfileRepository
  include Parser

  attr_reader :profiles

  def load_data(args)
    @median_household_income_data =
      args[:economic_profile][:median_household_income]
    @children_in_poverty_data = args[:economic_profile][:children_in_poverty]
    @free_or_reduced_price_lunch_data =
      args[:economic_profile][:free_or_reduced_price_lunch]
    @title_i_data = args[:economic_profile][:title_i]
    @profiles = collect_economic_profiles(@title_i_data)
    add_profile_data
  end

  def add_profile_data
    uniqueize_economic_profiles
    add_childeren_in_poverty_to_profiles
    add_median_household_income_to_profiles
    add_free_or_reduced_lunch_to_profiles
    add_title_i_data_to_profiles
  end

  def collect_economic_profiles(contents)
    profiles = CSV.open(contents, {headers: true, header_converters: :symbol})
    profiles.collect do |row|
      parse_name(row)
      EconomicProfile.new({:name => row[:name]})
    end
  end

  def uniqueize_economic_profiles
    profiles.uniq! do |profile|
      profile.name
    end
  end

  def add_median_household_income_to_profiles
    median_household_contents =
      CSV.open(@median_household_income_data,
        {headers: true, header_converters: :symbol})
    median_household_contents.each do |row|
      parse_name(row)
      parse_year_range(row)
      parse_integers(row)
      profiles[index_finder(row)].median_household_income[row[:timeframe]] =
        row[:data]
    end
    profiles
  end

  def add_childeren_in_poverty_to_profiles
    children_in_poverty_contents =
      CSV.open(@children_in_poverty_data,
        {headers: true, header_converters: :symbol})
    children_in_poverty_contents.each do |row|
      parse_name(row)
      parse_timeframe(row)
      next if row[:dataformat] == 'Number'
      parse_data(row)
      profiles[index_finder(row)].children_in_poverty[row[:timeframe]] =
        row[:data]
    end
    profiles
  end

  def add_free_or_reduced_lunch_to_profiles
    free_or_reduced_price_lunch_contents =
      CSV.open(@free_or_reduced_price_lunch_data,
        {headers: true, header_converters: :symbol})
    free_or_reduced_price_lunch_contents.each do |row|
      parse_name(row)
      parse_timeframe(row)
      if row[:poverty_level] == 'Eligible for Free or Reduced Lunch'
        if row[:dataformat] == 'Percent'
          parse_data(row)
          if profiles[index_finder(row)].free_or_reduced_price_lunch[
              row[:timeframe]]
            profiles[index_finder(row)].free_or_reduced_price_lunch[row[
              :timeframe]].merge!(percentage: row[:data])
          else
            profiles[index_finder(row)].free_or_reduced_price_lunch[
              row[:timeframe]] = {percentage: row[:data]}
          end
        elsif row[:dataformat] == 'Number'
          parse_integers(row)
          if profiles[index_finder(row)].free_or_reduced_price_lunch[
              row[:timeframe]]
            profiles[index_finder(row)].free_or_reduced_price_lunch[row[
              :timeframe]].merge!(total: row[:data])
          else
            profiles[index_finder(row)].free_or_reduced_price_lunch[
              row[:timeframe]] = {total: row[:data]}
          end
        end
      end
    end
    profiles
  end

  def add_title_i_data_to_profiles
    title_i_contents = CSV.open(@title_i_data,
      {headers: true, header_converters: :symbol})
    title_i_contents.each do |row|
      parse_name(row)
      parse_year_range(row)
      parse_data(row)
      profiles[index_finder(row)].title_i[row[:timeframe]] = row[:data]
    end
    profiles
  end

  def find_by_name(name)
    profiles.find do |profile|
      profile.name == name
    end
  end

  def index_finder(row)
    profiles.find_index do |profile|
      profile.name == row[:location].upcase
    end
  end

end