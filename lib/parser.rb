module Parser

  def parse_name(row)
    row[:name] = row[:location].upcase
  end

  def parse_timeframe(row)
    row[:timeframe] = row[:timeframe].to_i
  end

  def parse_data(row)
    if row[:data] == 'N/A' || row[:data] == 'LNE' || row[:data] == "#VALUE!"
      row[:data] = 'N/A'
    else
      row[:data] = ((row[:data].to_f)*1000).floor/1000.0
    end
  end

  def parse_score(row)
    row[:score] = row[:score].downcase
  end

  def parse_race_ethnicity(row)
    row[:race] = row[:race_ethnicity].downcase
  end
end