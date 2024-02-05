Sequel.migration do
  change do
    create_table(:drivers) do
      primary_key :id
      String :name, null: false
      String :email, unique: true, null: false
      Float :latitude
      Float :longitude
      Boolean :available, default: true
    end
  end
end
