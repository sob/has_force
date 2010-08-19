require 'net/http'
require 'net/https'
require 'uri'

module Force
  def self.included(base)
    base.send :extend, ClassMethods
  end
  
  module ClassMethods
    # This method includes the Force class and instance methods, allowing a
    # model to be submitted to SalesForce.com through the Web2Lead tool.
    #
    # === Supported Options
    #
    # [:skip_fields]
    #   Specify attributes (as symbols) to remove before sending to salesforce.com
    # [:transform_fields]
    #   Specify key,value pairs consisting of old_field => new_field to rename fields before sending to salesforce.com (used for custom fields)
    # [:oid]
    #   Your organizations SalesForce.com OID
    # [:include_fields]
    #   Additional fields to include with the submission to the Web2Lead gateway. Specified as key,value pairs
    #
    def has_force(options = {})
      options = {
        :skip_fields => [ :id, :created_at, :created_by, :updated_at, :updated_by, :status ],
        :transform_fields => { },
        :oid => '',
        :include_fields => { }
      }.merge(options)
      
      cattr_accessor :force_skip_fields
      cattr_accessor :force_transform_fields
      cattr_accessor :force_oid
      cattr_accessor :force_include_fields
      
      self.force_skip_fields = options[:skip_fields]
      self.force_transform_fields = options[:transform_fields]
      self.force_oid = options[:oid]
      self.force_include_fields = options[:include_fields]
      
      send :include, InstanceMethods
    end
  end
  
  module InstanceMethods
    # This method submits the attributes of an object to SalesForce.com using
    # the Web2Lead gateway. It does not check for previous submissions so you
    # should somewhere in your model before calling this function.
    #
    # Returns true on <tt>Net::HTTPSuccess</tt> or <tt>Net::HTTPRedirection</tt>
    # otherwise returns false
    #
    def to_salesforce(sandbox = false)
      url = URI.parse("https://#{ sandbox == :sandbox ? 'test' : 'www' }.salesforce.com/servlet/servlet.WebToLead?encoding=UTF-8")
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      request = Net::HTTP::Post.new(url.path)
      attribs = (self.attributes - self.class.force_skip_fields.stringify)
      convert_booleans_to_integers(attribs)
      attribs.stringify_values!
      attribs.transform_keys!(self.class.force_transform_fields)
      attribs = attribs.merge(self.class.force_include_fields)
      request.set_form_data(attribs.merge({:oid => self.class.force_oid}))
      
      # always return true in the test environment
      # prevents massive spam from SalesForce during tests
      return http if (ENV['RAILS_ENV'] == 'test')
      begin
        response = http.request(request)
        case response
        when Net::HTTPSuccess, Net::HTTPRedirection
          return true
        end
      end
      return false
    end

    def convert_booleans_to_integers(attribs)
      attribs.each do |k,v|
        attribs[k] = 1 if v.class == TrueClass
        attribs[k] = 0 if v.class == FalseClass
      end
    end
  end  
end

ActiveRecord::Base.send :include, Force
