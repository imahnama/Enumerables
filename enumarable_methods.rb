module Enumerable
  def my_each
    each do |i|
      yield i
      return to_enum unless block_given?
    end
  end

  def my_each_with_index
    (0...length).each do |i|
      yield(self[i], i)
    end
  end

  def my_select
    selection = []
    my_each { |val| selection.push(val) if yield(val) }
    selection
  end
end

def my_all?(value = nil)
  result = true
  if value
    my_each { |element| result &&= element == value }
  else
    my_each { |element| result &&= yield(element) }
  end
  result
end

def my_any?
  my_each { |val| return true if yield(val) }
  false
end

def my_none?
  my_each { |val| return false if yield(val) }
  true
end

def my_count
  count = 0
  my_each { |val| count += 1 if yield(val) }
  count
end

def my_map(proc = nil)
  result = []
  my_each do |element|
    result <<
      if proc
        proc.call(element)
      else
        yield(element)
      end
  end
  result
end

def my_inject(initial = self[0])
  result = initial
  my_each { |val| result = yield(result, val) }
  result
end

def multiply_els(vals)
  vals.my_inject(1) { |m, val| m * val }
end

# array = [1,2,3,4]
#
# array.my_each_with_index {|n,i| puts n + i } == array.each_with_index {|n,i| puts n + i }
# array.my_each {|n| puts n}
