module Parser

	def parse_name(row)
    row[:name] = row[:location].upcase
  end

  def parse_timeframe(row)
    row[:timeframe] = row[:timeframe].to_i
  end

  def parse_data(row)
    row[:data] = row[:data].to_f
  end
  
end