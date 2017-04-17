require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/statewide_test'

class StatewideTestTest < Minitest::Test

  def setup
    @st = StatewideTest.new
  end

  def test_instance_of_statewide_test

  end

end