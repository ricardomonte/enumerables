
require './enumerable'

describe Enumerable do
  let(:array) {[1, 2, 3, 4]}
  let(:array2) {[2, 4, 6, 8]}
  let(:range) {(1...5)}
  let(:hash) {{1 => "one", 2 => "two"} }
  let(:animal) {%w(cat dog wombat)}
  describe '#my_each' do
    it 'return an array if block given' do

      expect(array.my_each{|x| x}).to eq(array)

    end

    it 'testing if it yield' do
      arr =[]
      array.my_each{|x| arr << (x * 2)}
      expect(arr).to eq(array2)
    end

    it 'testing my_each with range' do
      arr =[]
      range.my_each{|x| arr << (x*2)}
      expect(arr).to eq(array2)
    end

    it 'testing my_each with hash' do
      arr = []
      hash.my_each { |x| arr << x}
      expect(arr[0][1]).to eq("one")

    end

    it 'return an Enumerator if not block given' do
      expect(array.my_each).to be_kind_of (Enumerator)
    end
  end
  describe '#my_each_with_index' do
    
  it 'return an Enumerator if not block given' do
      expect(array.my_each_with_index).to be_kind_of (Enumerator)
    end

    it 'testing if it yield' do
      arr =[]
      array.my_each_with_index{|x, i| arr << "index #{i} is element #{x}" }
      expect(arr[3]).to eq("index 3 is element 4")
    end

    it 'testing my_each_with_index with range' do
      arr =[]
      range.my_each_with_index{|x, i|  arr << "index #{i} is element #{x}" }
      expect(arr[3]).to eq("index 3 is element 4")
    end

    it 'testing my_each_with_index with hash' do
      hash_new = Hash.new
      animal.my_each_with_index { |x, i|   hash_new[x] = i}
      expect(hash_new).to eq({"cat"=>0, "dog"=>1, "wombat"=>2})
    end


  end
end

