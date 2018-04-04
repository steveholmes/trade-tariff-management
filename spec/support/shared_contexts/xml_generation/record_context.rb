require 'rails_helper'

shared_context "xml_generation_record_context" do

  include_context "xml_generation_base_context"

  let(:record_class) do
    db_record.class.to_s
  end

  let!(:xml_message) do
    create(:xml_generation_node_message,
      transaction: xml_transaction,
      record_filter_ops: record_filter_ops(record_class, db_record),
      record_type: record_class
    )
  end

  let(:xml_record) do
    hash_xml["env:envelope"]["env:transaction"]["env:app.message"]["oub:transmission"]["oub:record"]
  end

  let(:xml_values) do
    xml_record[data_namespace]
  end

  before do
    db_record
  end

  it "should return valid XML" do
    fields_to_check.map do |_field_name|
      expect_proper_xml_at(_field_name)
    end
  end

  private

    def expect_proper_xml_at(field_ops)
      field_name = (field_ops.is_a?(Hash) ? field_ops.values[0] : field_ops).to_s
      data_field_name = field_ops.is_a?(Hash) ? field_ops.keys[0] : field_ops
      date_type = field_name[-5..-1] == "_date"
      timestamp_type = field_name[-10..-1] == "_timestamp"

      xml_name = "oub:#{field_name.gsub('_', '.')}"
      xml_value = db_record.public_send(data_field_name)
      xml_value = xml_value.strftime("%Y-%m-%d") if date_type
      xml_value = xml_value.utc.to_s if timestamp_type

      expect(xml_values[xml_name]).to be_eql xml_value.to_s
    end
end
