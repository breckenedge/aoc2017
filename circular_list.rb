class CircularList
  include Enumerable

  attr_reader :array, :size

  def initialize(array, size = array.size)
    @array = array
    @size = size
  end

  def [](i, len = 1)
    j = i.abs >= size ? i % size : i
    if len == 1
      array[j]
    else
      0.upto(len - 1).map { |l| self[j + l] }
    end
  end

  def []=(i, length_or_value, value_or_nil = nil)
    j = i.abs >= size ? i % size : i
    if value_or_nil.nil?
      self.array[j] = length_or_value
    elsif length_or_value == 1
      self.array[j] = value_or_nil
    else
      if length_or_value != value_or_nil.size
        raise ArgumentError, "#{length_or_value} is larger than #{value_or_nil}.size"
      end
      0.upto(length_or_value - 1).each { |l| self[j + l] = value_or_nil[l] }
    end
  end

  def each(&block)
    @array.each(&block)
  end

  def index(obj)
    @array.index(obj)
  end

  def insert(index, obj)
    @array.insert(index, obj)
    @size = @array.size
  end

  def join(str)
    array.join(str)
  end

  def each_slice(size)
    array.each_slice(size)
  end
end

if __FILE__ == $0
  require 'test/unit'

  class CircularListTest < Test::Unit::TestCase
    def setup
      @fixture = CircularList.new([0, 1, 2, 3, 4])
    end

    def test_wrap_around
      assert_equal 0, @fixture[5]
    end

    def test_wrap_around_length
      assert_equal [4, 0, 1], @fixture[4, 3]
    end

    def test_assign_one_index
      @fixture[1] = 5
      assert_equal 5, @fixture[1]
    end

    def test_assign_beyond_size
      @fixture[5] = 5
      assert_equal 5, @fixture[0]
      @fixture[10] = 'x'
      assert_equal 'x', @fixture[0]
    end

    def test_assign_index_and_length
      @fixture[3, 3] = ['x', 'x', 'x']
      assert_equal ['x', 'x', 'x'], @fixture[3, 3]
    end
  end
end
