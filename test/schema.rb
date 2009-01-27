ActiveRecord::Schema.define(:version => 0) do
  create_table :leads, :force => true do |t|
    t.string    :first_name
    t.string    :last_name
    t.datetime  :submitted_at
  end
end