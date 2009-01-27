require File.expand_path(File.join(File.dirname(__FILE__), 'test_helper.rb'))

class CoreExtTest < Test::Unit::TestCase
  def test_array_stringify_values
    assert_equal ["test", "1", "red"], [:test, 1, :red].stringify!
  end
  
  def test_hash_minus_key
    assert_equal({:one => '1'}, {:one => '1', :two => '2'} - [:two])
  end
  
  def test_hash_stringify_values
    assert_equal({:one => '1', :two => 'two'}, {:one => 1, :two => :two}.stringify_values!)
  end
  
  def test_hash_transform_key
    assert_equal({:one => '1', :three => '2'}, {:one => '1', :two => '2'}.transform_key(:two, :three))
  end
  
  def test_hash_transform_multiple_keys
    assert_equal({:one => '1', :three => '2', :five => '4'}, {:one => '1', :two => '2', :four => '4'}.transform_keys({:two => :three, :four => :five}))
  end
end