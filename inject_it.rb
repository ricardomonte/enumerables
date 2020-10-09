context 'a block is given' do
	context 'with no argument' do
			it 'goes over array one by one and returns the vlaue by applying a binary operation, specified by this block ' do
				example
			end
	end
	
	context '&& one argument' do
		context 'this one argument is a number'do 
			it 'goes over array one by one and returns the vlaue by applying a binary operation, specified by this block with this number as a seed for memo ' do
				example
		    end
		end
		
		context 'this one argument is a symbol' do
           it "goes over array one by one and returns the vlaue by applying a binary operation, specified by this block based on the binary operation passed as a Symbol in the argument " do
            example

           end
  
				
		end
    end	
    
    context 'with two arguments' do
        it "goes over array one by one and returns the vlaue by applying a binary operation, specified by this block based on the binary operation passed as a Symbol in the argument
       with this number as a seed for memo" do
       end
    end
end
