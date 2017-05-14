class FieldsController < ApplicationController
  def index
    @fields = Field.all
    @fields_data = Field.pluck(:shape).map {|s| RGeo::GeoJSON.encode(s) }.to_json.html_safe
  end

  def show
    @field = Field.find params[:id]
    @field_data = RGeo::GeoJSON.encode(@field.shape).to_json
  end

  def new
  end

  def create
    shape_geometry = JSON.parse(params[:shape])["geometry"]
    shape = RGeo::GeoJSON.decode(shape_geometry, json_parser: :json)
    sqlq = "SELECT ST_AsText(ST_Multi(ST_GeomFromText('#{shape.as_text}')));"
    poly = ActiveRecord::Base.connection.exec_query(sqlq).rows.flatten.first
    @field = Field.create(name: Time.now.strftime("%d-%m-%Y %H:%M"),
                          shape: poly,
                          area: params[:area])

    head :no_content
  end

  def edit
    @field = Field.find params[:id]
  end

  def update
    @field = Field.find(params[:id])
    @field_data = RGeo::GeoJSON.encode(@field.shape).to_json

    if @field.update_attributes(field_params)
      flash[:notice] = "field updated"

      render :show
    else
      flash[:alert] = "oops"
    end
  end

  private
    def field_params
      params.require(:field).permit(:name, :shape)
    end
end
