require 'pry'
require 'csv'
require_relative 'economic_profile'

class EconomicProfileRepository
  attr_reader :profiles

  def load_data(args)
    @median_household_income_data = args[:economic_profile][:median_household_income]
    @children_in_poverty_data = args[:economic_profile][:children_in_poverty]
    @free_or_reduced_price_lunch_data = args[:economic_profile][:free_or_reduced_price_lunch]
    @title_i_data = args[:economic_profile][:title_i]
    @profiles = collect_statewide_tests(@title_i_data)
    uniqueize_economic_profiles
  end

  def collect_economic_profiles(contents)
    profiles = CSV.open(contents, {headers: true, header_converters: :symbol})
    profiles.collect do |row|
      row[:name] = row[:location].upcase
      EconomicProfile.new({:name => row[:name]})
    end
  end

  def uniqueize_economic_profiles
    profiles.uniq! do |profile|
      profile.name
    end
  end

end