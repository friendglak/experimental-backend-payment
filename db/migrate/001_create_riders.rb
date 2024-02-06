Sequel.migration do
  change do
    create_table(:riders) do
      primary_key :id
      String :name, null: false
      String :email, unique: true, null: false
      Float :latitude
      Float :longitude
      String :payment_source_id
    end
  end
end
