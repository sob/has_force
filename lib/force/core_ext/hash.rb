unless Hash.instance_methods.include? '-'
  Hash.class_eval do
    # removes one or more keys from a hash
    #   {:red => 1, :blue => 2, :green => 3} - [:red, :blue] => {:green => 3}
    def -(v)
      hsh = self.dup
      (v.is_a?(Array) ? v : [v]).each{|k| hsh.delete(k) }
      hsh
    end
  end
end

unless Hash.instance_methods.include? 'stringify_values'
  Hash.class_eval do
    # returns a new hash with each of the values converted to a string
    #   {:red => 1, :blue => 2} => {:red => '1', :blue => '2'}
    def stringify_values
      inject({}) do |options, (key, value)|
        options[key] = value.to_s
        options
      end
    end

    # returns the hash with each of the values converted to a string
    #   {:red => 1, :blue => 2} => {:red => '1', :blue => '2'}
    def stringify_values!
      self.each do |key, value|
        self[key] = value.to_s
      end
      self
    end
  end
end

unless Hash.instance_methods.include? 'transform_key'
  Hash.class_eval do
    # returns a new hash with a key renamed
    #   {:one => 1, :two => 2}.transform_key(:two, :three) => {:one => 1, :three => 2}
    def transform_key(old_key, new_key)
      self.dup.transform_key!(old_key, new_key)
    end

    # renames a key in a hash
    #   {:one => 1, :two => 2}.transform_key(:two, :three) => {:one => 1, :three => 2}
    def transform_key!(old_key, new_key)
      self[new_key] = self.delete(old_key)
      return self
    end

    # returns a new hash with renamed keys
    # accepts a hash of key, value pairs to rename
    #   {:one => 1, :two => 2}.transform_keys(:two => :three) => {:one => 1, :three => 2}
    def transform_keys(transform)
      self.dup.transform_keys!(transform)
    end

    # returns a hash with renamed keys
    # accepts a hash of key, value pairs to rename
    #   {:one => 1, :two => 2}.transform_keys(:two => :three) => {:one => 1, :three => 2}
    def transform_keys!(transform)
      raise ArgumentError, "transform_keys takes a single hash argument" unless transform.is_a?(Hash)
      self.each_key do |k|
        self[transform.has_key?(k) ? transform[k] : k] = self.delete(k)
      end
      self
    end
  end
end