# rubocop:disable all


module Enumerable
  def my_each()
    return to_enum(:my_each) unless block_given?

    var = to_a
    result = []
    i = 0
    while i < var.length
      result << yield(var[i])
      i += 1
    end
    self
  end

  def my_each_with_index()
    return to_enum(:my_each_with_index) unless block_given?

    var = to_a
    i = 0
    while i < var.length
      result = yield(var[i], i)
      i += 1
    end
    self
  end

  def my_select
    return to_enum(:my_select) unless block_given?

    arr = []
    my_each { |i| arr.push(i) if yield(i) }
    arr
  end

  def my_all?(arg = nil, &block)
    var = to_a
    if block_given?
      return var.my_select { |i| yield(i)}.length == var.length
    end
    unless block_given?
      if arg.nil?
        return var.my_select { |i| i.nil? || i == false}.length == 0
        return !var.empty?
      end
      if arg.kind_of? Class
        return var.my_select { |i| i.kind_of? arg}.length == var.length
      end
      if arg.kind_of? Regexp
        return var.my_select {|i| arg.match?(i)}.length == var.length
      else
        return var.my_select {|i| arg == i}.length == var.length
      end
    end
  end

  def my_any?(arg = nil) 
    var = to_a 
    result = false 
    var.my_each do |n| 
      if block_given? 
        if yield(n) 
          result = true 
          break 
        elsif 
          !yield(n) 
          result = false 
        end 
      elsif arg.nil? 
        result = true if n 
      else 
        if arg === n 
          result = true 
          break 
        end 
      end 
    end 
    result 
  end 

  def my_none?(arg = nil)
    result = true
    my_each do |n|
      if block_given?
        if yield(n)
          result = false
          break
        elsif !yield(n)
          result = true
        end
      elsif arg.nil?
        result = false if n == true
      else
        if arg === n
          result = false
          break
        end
      end
    end
    result
  end

  def my_count(*arg)
    var = to_a
    sum = 0
    if block_given?
      var.my_each { |i| sum += 1 if yield(i) }
      sum
    elsif arg.empty?
      var.length
    else
      var.my_each { |i| sum += 1 if arg[0] == i }
      sum
    end
  end

  def my_map(arg = nil)
    var = to_a
    arr = []
    if arg
      var.my_each { |i| arr.push(arg.call(i)) }
      return arr
    end
    return to_enum(:my_map) unless block_given?

    var.my_each { |i| arr.push(yield(i)) }
    arr
  end

  def my_inject(*arg)
    var = to_a
    var3 = var
    len = var.length
    memo = var[0]
    var2 = var.slice(1, len)

    if var.my_all? { |x| x.is_a? String }
      var2.my_each { |i| memo = yield(memo, i) }
      return memo
    end
    if arg.empty?
      var2.my_each { |i| memo = yield(memo, i) }
      return memo
    end
    if arg.empty? == false && block_given?
      var.my_each do |i|
        memo = yield(arg[0], i)
        arg[0] = memo
      end
      return memo
    end
    if arg[0].is_a? Symbol
      case arg[0]
      when :+ || :-

        var2.my_each do |i|
          memo = memo.send(arg[0], i)
        end
        return memo
      when :* || :/

        var2.my_each do |i|
          memo = memo.send(arg[0], i)
        end
        return memo
      end
    end
    return unless arg.length == 2
    var.my_each { |i| memo = arg[0] = arg[0].send(arg[1], i) }
    memo
  end
end

# rubocop: enable all

def multiply_els(arg)
  arg.my_inject(:*)
end




