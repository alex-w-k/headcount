require 'pry'
require 'csv'
require './lib/district/'

class DistrictRepository
  attr_reader :districts

  def load_data(args)
    enrollment = args[:enrollment]
    data_set = enrollment[:kindergarten]
    contents = CSV.open(data_set, {headers: true, header_converters: :symbol})
    @districts = contents.collect do |row|
      District.new(row)
    end
    contents
  end

  def load_format
  end

  def find_by_name(name)
    @districts.find do |district|
      district.location == name
    end

  end

  def find_all_matching

  end

  binding.pry
end
