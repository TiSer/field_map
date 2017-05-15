class Field < ApplicationRecord
  def shape_to_geojson
    RGeo::GeoJSON.encode(shape).to_json
  end

  def self.build_field(params_shape)
    shape_geometry = JSON.parse(params_shape)["geometry"]
    shape = RGeo::GeoJSON.decode(shape_geometry, json_parser: :json)
    sqlq = "SELECT ST_AsText(ST_Multi(ST_GeomFromText('#{shape.as_text}')));"
    ActiveRecord::Base.connection.exec_query(sqlq).rows.flatten.first
  end

  def self.get_shapes
    pluck(:shape).map {|s| RGeo::GeoJSON.encode(s) }.to_json.html_safe
  end
end
