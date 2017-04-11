require 'pry'
require 'csv'
class DistrictRepository
  attr_reader :name, :year, :format, :data

  def load_data
    contents = CSV.open("./data/Kindergartners in full-day program.csv",
                        {headers: true, 
                         header_converters: :symbol})
    @name = contents.collect do |row|
      row[:location]
    end
    contents
  end

  def load_format
    load_data.each do |row|
      format = row[:dataformat]
    end
    format
  end

  def find_by_name(name)
    

  end

  def find_all_matching

  end

  binding.pry
end
