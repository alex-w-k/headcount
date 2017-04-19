class District
  attr_reader :name
  attr_accessor :enrollment, :statewide_test, :economic_profile

  def initialize(args)
    @name = args[:name]
    @enrollment = nil
    @statewide_test = nil
    @economic_profile = nil
  end
end