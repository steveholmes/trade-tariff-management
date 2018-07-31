Sequel.migration do
  change do
    alter_table :create_measures_workbasket_settings do
      add_column :measure_sids_jsonb, :jsonb, default: '{}'
    end
  end
end
