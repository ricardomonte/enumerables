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

  def my_all?(arg = nil)
    var = to_a
    result = true
    var.my_each do |n|
      if block_given?
        if yield(n)
          result = true
        elsif !yield(n)
          result = false
        end
      elsif arg.nil?
        result = false if n.nil? || n == false
      else
        if arg === n
          result = false
          break
        end
      end
    end
    result
  end

  def my_any?(arg = nil)
    var = to_a
    result = true
    var.my_each do |n|
      if block_given?
        if yield(n)
          result = true
        elsif !yield(n)
          result = false
        end
      elsif arg.nil?
        result = false if n.nil? || n == false
      else
        unless arg === n
          result = false
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
    memo = 0
    var = to_a
    if var.my_all? { |x| x.is_a? String }
      memo = ''
      var.my_each { |i| memo = yield(memo, i) }
      return memo
    end
    if arg.empty?
      var.my_each { |i| memo = yield(memo, i) }
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
        memo = 0
        my_each do |i|
          memo = memo.send(arg[0], i)
        end
        return memo
      when :* || :/
        memo = 1
        my_each do |i|
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
  arg.my_inject(:+)
end
