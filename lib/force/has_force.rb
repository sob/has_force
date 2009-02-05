require 'net/http'
require 'net/https'
require 'uri'

module Force
  def self.included(base)
    base.send :extend, ClassMethods
  end
  
  module ClassMethods
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
    def to_salesforce
      url = URI.parse('https://www.salesforce.com/servlet/servlet.WebToLead?encoding=UTF-8')
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      request = Net::HTTP::Post.new(url.path)
      attribs = (self.attributes - self.class.force_skip_fields.stringify).stringify_values!
      attribs.transform_keys!(self.class.force_transform_fields)
      attribs = attribs.merge(self.class.force_include_fields)
      request.set_form_data(attribs.merge({:oid => self.class.force_oid}))
      begin
        response = http.request(request)
        case response
        when Net::HTTPSuccess, Net::HTTPRedirection
          return true
        end
      end
      return false
    end
  end  
end

ActiveRecord::Base.send :include, Force