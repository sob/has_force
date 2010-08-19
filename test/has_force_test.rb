require File.expand_path(File.join(File.dirname(__FILE__), 'test_helper'))

class HasForceTest < Test::Unit::TestCase
  load_schema
  
  class Lead < ActiveRecord::Base
    has_force :oid => '123'
  end
  
  def test_schema_has_loaded_correctly
    assert_equal [], Lead.all
  end
  
  def test_lead_class_sets_force_oid_variable
    assert_not_nil(Lead.force_oid)
    assert_equal('123', Lead.force_oid)
  end
  
  def test_lead_class_sets_force_include_fields
    assert_not_nil(Lead.force_include_fields)
    assert_equal({}, Lead.force_include_fields)
  end
  
  def test_lead_class_sets_force_skip_fields
    assert_not_nil(Lead.force_skip_fields)
    assert_equal([:id, :created_at, :created_by, :updated_at, :updated_by, :status], Lead.force_skip_fields)
  end
  
  def test_lead_class_sets_force_transform_fields
    assert_not_nil(Lead.force_transform_fields)
    assert_equal({}, Lead.force_transform_fields)
  end
  
  def test_a_lead_responds_to_salesforce
    @lead = Lead.new
    assert_respond_to(@lead, :to_salesforce)
  end
  
  def test_a_lead_submits_to_salesforce
    @lead = Lead.new
    assert @lead.to_salesforce
  end

  def test_uses_the_sandbox_url
    @lead = Lead.new
    assert_equal 'test.salesforce.com', @lead.to_salesforce(:sandbox).address
  end

  def test_uses_the_regular_url_by_default
    @lead = Lead.new
    assert_equal 'www.salesforce.com', @lead.to_salesforce.address
  end
end
