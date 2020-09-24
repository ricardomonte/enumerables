# rubocop:disable Style/CaseEquality
module Enumerable
  def my_each
    return to_enum(:my_each)unless block_given?
    while i <= self.length
      yield(i)
    end
  end

  def my_each_with_index
    return to_enum(:my_each_with_index) unless block_given?
    for i in (0...self.length) do
      yield(self[i], i)
    end    
  end

  def my_select
    return to_enum(:my_select) unless block_given?
    arr =[]
    for i in (self) do
      if yield(i) == true
       arr.push(i)
      end
    end
    arr  
  end

  def my_all
    test = true 
    my_each do |i|
    if block_given?
      if !yield(i)
        test = false
      end
    else !block_given?
      if i == false || i == nil
        test = false
      end
    end
  end
   puts test
  end

  def my_any
    test = false 
    my_each do |i|
    if block_given?
      if yield(i)
        test = true
      end
    else !block_given?
      if i == true
        test = true
      end
    end
  end
   puts test
  end

  def my_none
    test = true
    my_each do |i|
      if block_given?
        if yield(i)
          test = false
        end
      else !block_given?
        if i
          test = false
        end
      end
    end
    puts test
  end

  def my_count(*arg)
    sum = 0
    if block_given?
      puts("Con un bloque y sin argumento")
      my_each do |i|
        if yield(i)
          sum += 1
        end
      end
      sum
    elsif arg.empty?
      puts("Sin un bloque y sin argumento")
      self.length
    else
      puts("Con argumento y sin bloque")
      my_each do |i|
        if arg[0] == i
        sum += 1
        end
      end
      sum
      
    end
  end

  def my_map(arg = nil)
    if arg
      arr = []
      my_each do |i|
        arr.push(arg.call(i))
      end
      return arr
    end
    if block_given?
      arr = []
      my_each do |i|
        arr.push(yield(i))
      end
      return arr
    end
  end

  def my_inject(*arg)
    if arg.empty?
      memo = 0
      my_each do |i|
        memo = yield(memo, i)
      end
      return memo
    end
    if arg.empty? == false && block_given?
      memo = 0
      my_each do |i|
        memo = yield(arg[0], i)
        arg[0] = memo
      end
      return memo  
    end
    if arg[0].is_a? Symbol
      memo = 0
      my_each do |i|
        memo = memo.send(arg[0], i)
      end
      return memo
    end
    if arg.length == 2
      memo = 0
      my_each do |i|
        arg[0] = arg[0].send(arg[1],i)
        memo = arg[0]
      end
      return memo
    end
  end

  def multiply_els
    my_inject(1, :*)
  end

end

ary = [1,2,3,4,5]
p ary.my_each