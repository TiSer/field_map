class CreateFields < ActiveRecord::Migration[5.0]
  def change
    create_table :fields do |t|
      t.string :name
      t.float :area
      t.multi_polygon :shape, geographic: true, srid: 4326

      t.timestamps
    end

    change_table :fields do |t|
      t.index :shape, using: :gist
    end
  end
end
