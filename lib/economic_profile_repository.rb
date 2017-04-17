require 'pry'
require 'csv'
require_relative 'economic_profile'

class EconomicProfileRepository
  attr_reader :profiles

  def load_data(args)
    @profiles = collect_statewide_tests(@title_i_data)
    uniqueize_statewide_tests
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