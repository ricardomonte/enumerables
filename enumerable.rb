# rubocop:disable Style/CaseEquality

module Enumerable
  def my_each
    return to_enum(:my_each)unless block_given?
    for i in (self) do
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
    puts arg
    if arg.empty?
      my_each do |i|
        if yield(i)
          sum += 1
        end
      end
    else
      my_each do |i|
        if arg[0] == i
        sum += 1
        end
      end
    end
    puts sum
  end
end

#%w[ant bear cat].my_none { |word| word.length >= 4}
#[1, 3.14, 42].my_none(Float)
#[].my_any

#[1, 2, 4, 2, 3, 8].my_count{ |x| x%2==0}
#[1, 2, 4, 2].my_count

[1, 2, 4, 3, 9, 7, 12].my_count{ |x| x%3==0}
