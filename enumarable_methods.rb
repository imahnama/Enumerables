module Enumerable
  def my_each
    return to_enum unless block_given?

    index = 0
    while index < size
      if is_a? Array
        yield self[index]
      elsif is_a? Hash
        yield keys[index], self[keys[index]]
      elsif is_a? Range
        yield to_a[index]
      end
      index += 1
    end
  end

  def my_each_with_index
    return to_enum :my_each unless block_given?

    index = 0
    while index < size
      if is_a? Array
        yield self[index], index
      elsif is_a? Hash
        yield keys[index], self[keys[index]]
      elsif is_a? Range
        yield to_a[index], index
      end
      index += 1
    end
  end

  def my_select
    return to_enum :my_select unless block_given?

    if is_a? Array
      results = []
      my_each { |x| results << x if yield x }
    else
      results = {}
      my_each { |y, z| results[y] = z if yield y, z }
    end
    results
  end

  def my_all?(param = nil)
    result = true
    my_each do |value|
      if block_given?
        result = false unless yield(value)
      elsif param.nil?
        result = false unless value
      else
        result = false unless param === value
      end
    end
    result
  end

  def my_any?(args = nil)
    result = false
    if args.nil? && !block_given?
      my_each { |x| result = true unless x.nil? || !x }
    elsif args.nil?
      my_each { |x| result = true if yield(x) }
    elsif args.is_a? Regexp
      my_each { |x| result = true if x.match(args) }
    elsif args.is_a? Module
      my_each { |x| result = true if x.is_a?(args) }
    else
      my_each { |x| result = true if x == args }
    end
    result
  end

  def my_none?(args = nil)
    result = true
    if args.nil? && !block_given?
      my_each { |x| result = false if x == true }
    elsif args.nil?
      my_each { |x| result = false if yield(x) }
    elsif args.is_a? Regexp
      my_each { |x| result = false if x.match(args) }
    elsif args.is_a? Module
      my_each { |x| result = false if x.is_a?(args) }
    else
      my_each { |x| result = false if x == args }
    end
    result
  end

  def my_count(my_arg = nil)
    arr = self
    count = 0
    if my_arg.nil?
      arr.my_each { count += 1 }
    else
      arr.my_each { |x| count += 1 if x == my_arg }
    end
    count
  end

  def my_map(&proc_0)
    map = []
    if !proc_0.nil?
      my_each { |val| map.push(proc_0.call(val)) }
    elsif block_given?
      my_each { |val| map.push(yield(val)) }
    end
    map
  end

  def my_inject(initial = self[0])
    result = initial
    my_each { |val| result = yield(result, val) }
    result
  end
end

def multiply_els(vals)
  vals.my_inject(1) { |m, val| m * val }
end

# p (1..4).my_map { |i| i*i }
# p %w[ant bear cat].my_all? { |word| word.length >= 4 }
# p [1, 2i, 3.14].my_all?(Numeric)
# p %w[ant bear cat].my_any? { |word| word.length >= 4 }
# p [nil, true, 99].my_any?(Integer)
# p [1,2,3,4].my_count
# hash = Hash.new
# %w(cat dog wombat).my_each_with_index { |item, index|
#   hash[item] = index
# }
# hash   #=> {"cat"=>0, "dog"=>1, "wombat"=>2}
# p [1, 3.14, 42].my_none?(Float)
