class FieldsController < ApplicationController
  before_action :prepare_field, only: [:show, :edit, :update, :destroy]

  def index
    @fields = Field.all
    @fields_data = Field.get_shapes
  end

  def show
    @field_data = @field.shape_to_geojson
  end

  def new
  end

  def create
    poly_field = Field.build_field(params[:shape])
    @field = Field.create(name: Time.now.strftime("%d-%m-%Y %H:%M"),
                          shape: poly_field,
                          area: params[:area])

    head :no_content
  end

  def edit
  end

  def update
    @field_data = @field.shape_to_geojson

    if @field.update_attributes(field_params)
      flash[:notice] = "field updated"
      render :show
    else
      flash[:alert] = "oops"
    end
  end

  def destroy
    @field.destroy

    flash[:notice] = "field destroyed"
    redirect_to :root
  end

  private
    def prepare_field
      @field = Field.find params[:id]
    end

    def field_params
      params.require(:field).permit(:name, :shape)
    end
end
