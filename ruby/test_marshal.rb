require 'singleton'
require 'test/unit'

if RUBY_PLATFORM =~ /java/
  require 'jruby'
  # JRuby.objectspace = true
end

class ASingletonClass
  include Singleton
end

class TestSingleton < Test::Unit::TestCase
  def setup
    @a = ASingletonClass.instance
    @b = ASingletonClass.instance
    @c = Marshal.load(Marshal.dump(@a))
  end

  def test_two_instances_are_the_same_for_real
    assert_equal(true, @a.equal?(@b))
  end

  def test_deserialized_instance_should_be_an_instance_of_that_class
    assert_kind_of(ASingletonClass, @c)
  end

  def test_deserialized_instance_should_be_THE_instance_for_real
    assert_equal(true, @a.equal?(@c))
  end

  def test_there_should_only_be_one_instance
    assert_equal(1, ObjectSpace.each_object(ASingletonClass){})
  end
end
