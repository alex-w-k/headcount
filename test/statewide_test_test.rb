require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/statewide_test'

class StatewideTestTest < Minitest::Test

  def setup
    @st = StatewideTest.new({:eighth_grade =>
                            {2008=>{:math=>0.64, :reading=>0.843, :writing=>0.734},
                              2009=>{:math=>0.656, :reading=>0.825, :writing=>0.701},
                              2010=>{:math=>0.672, :reading=>0.863, :writing=>0.754},
                              2011=>{:reading=>0.83221, :math=>0.65339, :writing=>0.74579},
                              2012=>{:math=>0.68197, :writing=>0.73839, :reading=>0.83352},
                              2013=>{:math=>0.6613, :reading=>0.85286, :writing=>0.75069},
                              2014=>{:math=>0.68496, :reading=>0.827, :writing=>0.74789}},
                            :math =>
                            {2011=>
                              {:all_students=>0.68, :asian=>0.8169, :black=>0.4246, :pacific_islander=>0.5686,
                                :hispanic=>0.5681, :native_american=>0.6143, :two_or_more=>0.6772, :white=>0.7065},
                              2012=>
                              {:all_students=>0.6894, :asian=>0.8182, :black=>0.4248, :pacific_islander=>0.5714,
                                :hispanic=>0.5722, :native_american=>0.5714, :two_or_more=>0.6899, :white=>0.7135},
                              2013=>
                              {:all_students=>0.69683, :asian=>0.8053, :black=>0.4404, :pacific_islander=>0.6833,
                                :hispanic=>0.5883, :native_american=>0.5932, :two_or_more=>0.6967, :white=>0.7208},
                              2014=>
                              {:all_students=>0.69944, :asian=>0.8, :black=>0.4205, :pacific_islander=>0.6818,
                                :hispanic=>0.6048, :native_american=>0.5439, :two_or_more=>0.6932, :white=>0.723}},
                            :name => "ACADEMY 20",
                            :reading =>
                            {2011=>
                              {:all_students=>0.83, :asian=>0.8976, :black=>0.662, :pacific_islander=>0.7451, 
                                :hispanic=>0.7486, :native_american=>0.8169, :two_or_more=>0.8419, :white=>0.8513},
                              2012=>
                              {:all_students=>0.84585,
                                :asian=>0.89328,
                                :black=>0.69469,
                                :pacific_islander=>0.83333,
                                :hispanic=>0.77167,
                                :native_american=>0.78571,
                                :two_or_more=>0.84584,
                                :white=>0.86189},
                              2013=>
                              {:all_students=>0.84505,
                                :asian=>0.90193,
                                :black=>0.66951,
                                :pacific_islander=>0.86667,
                                :hispanic=>0.77278,
                                :native_american=>0.81356,
                                :two_or_more=>0.85582,
                                :white=>0.86083},
                              2014=>
                              {:all_students=>0.84127, :asian=>0.85531, :black=>0.70387, :pacific_islander=>0.93182, 
                              :hispanic=>0.00778, :native_american=>0.00724, :two_or_more=>0.00859, :white=>0.00856}},
                            :third_grade =>
                            {2008=>{:math=>0.857, :reading=>0.866, :writing=>0.671},
                              2009=>{:math=>0.824, :reading=>0.862, :writing=>0.706},
                              2010=>{:math=>0.849, :reading=>0.864, :writing=>0.662},
                              2011=>{:math=>0.819, :reading=>0.867, :writing=>0.678},
                              2012=>{:reading=>0.87, :math=>0.83, :writing=>0.65517},
                              2013=>{:math=>0.8554, :reading=>0.85923, :writing=>0.6687},
                              2014=>{:math=>0.8345, :reading=>0.83101, :writing=>0.63942}},
                            :writing =>
                            {2011=>
                              {:all_students=>0.7192, :asian=>0.8268, :black=>0.5152, :pacific_islander=>0.7255, 
                                :hispanic=>0.6068, :native_american=>0.6, :two_or_more=>0.7274, :white=>0.7401},
                              2012=>
                              {:all_students=>0.70593, :asian=>0.8083, :black=>0.5044, :pacific_islander=>0.6833, 
                                :hispanic=>0.5978,
                                :native_american=>0.5893, :two_or_more=>0.7186, :white=>0.7262},
                              2013=>
                              {:all_students=>0.72029, :asian=>0.8109, :black=>0.4819, :pacific_islander=>0.7167, 
                                :hispanic=>0.623,
                                :native_american=>0.6102, :two_or_more=>0.7474, :white=>0.7406},
                              2014=>
                              {:all_students=>0.71583, :asian=>0.7894, :black=>0.5194, :pacific_islander=>0.7273,
                                :hispanic=>0.6244, :native_american=>0.6207, :two_or_more=>0.7317, :white=>0.7348}}})
  end

  def test_instance_of_statewide_test
    assert_instance_of StatewideTest, @st
  end

  def test_proficient_by_grade_method
    @st.proficient_by_grade(3)
    result = { 2008 => {:math => 0.857, :reading => 0.866, :writing => 0.671},
     2009 => {:math => 0.824, :reading => 0.862, :writing => 0.706},
     2010 => {:math => 0.849, :reading => 0.864, :writing => 0.662},
     2011 => {:math => 0.819, :reading => 0.867, :writing => 0.678},
     2012 => {:math => 0.830, :reading => 0.870, :writing => 0.655},
     2013 => {:math => 0.855, :reading => 0.859, :writing => 0.668},
     2014 => {:math => 0.834, :reading => 0.831, :writing => 0.639}
   }
   assert_equal result, @st.proficient_by_grade(3)
  end

end


