unless Array.instance_methods.include? 'stringify'
  Array.class_eval do
    # converts all values into strings in the current array
    #   [:one, 2, 3].stringify! => ['one', '2', '3']
    def stringify!
      collect{|v| v.to_s }
    end
  
    # return a copy of the current array with all values converted to strings
    #  [:one, 2, 3].stringify => ['one', '2', '3']
    def stringify
      dup.stringify!
    end
  end
end