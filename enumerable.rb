module Enumerable
  def my_each
    return to_enum(:my_each) unless block_given?

    var = to_a
    result = []
    i = 0
    while i < var.length
      result << yield(var[i])
      i += 1
    end
    result
  end

  def my_each_with_index
    return to_enum(:my_each_with_index) unless block_given?

    var = to_a
    result = i = 0
    while i < var.length
      result = yield(var[i], i)
      i += 1
    end
    result
  end

  def my_select
    return to_enum(:my_select) unless block_given?

    arr = []
    my_each { |i| arr.push(i) if yield(i) }
    arr
  end

  def my_all?
    var = to_a
    var.empty?
    if block_given?
      my_each { |i| return false unless yield(i) }
      return true
    end
    var.include?(nil) || var.include?(false) ? false : true
  end

  def my_any?
    var = to_a
    if block_given?
      var.my_each { |i| return true if yield(i) }
    else
      var.my_each { |i| return true if i.nil? == false and i != false }
    end
    false
  end

  def my_none?
    var = to_a
    if block_given?
      var.my_each { |i| return false if yield(i) }
    else
      var.my_each { |i| return false if i.nil? == false and i != false }
    end
    true
  end

  def my_count(*arg)
    sum = 0
    if block_given?
      my_each { |i| sum += 1 if yield(i) }
      sum
    elsif arg.empty?
      length
    else
      my_each { |i| sum += 1 if arg[0] == i }
      sum
    end
  end

  def my_map(arg = nil)
    arr = []
    if arg
      my_each { |i| arr.push(arg.call(i)) }
      return arr
    end
    return unless block_given?

    my_each { |i| arr.push(yield(i)) }
    arr
  end

  def my_inject(*arg)
    memo = 0
    if arg.empty?
      my_each { |i| memo = yield(memo, i) }
      return memo
    end
    if arg.empty? == false && block_given?
      my_each do |i|
        memo = yield(arg[0], i)
        arg[0] = memo
      end
      return memo
    end
    if arg[0].is_a? Symbol
      my_each { |i| memo = memo.send(arg[0], i) }
      return memo
    end
    return unless arg.length == 2

    my_each { |i| memo = arg[0] = arg[0].send(arg[1], i) }
    memo
  end

  def multiply_els
    my_inject(1, :*)
  end
end
