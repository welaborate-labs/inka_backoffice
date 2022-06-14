class ProductsController < ApplicationController
  before_action :set_product, only: %i[show edit update destroy]
  before_action :set_stock_balance, only: %i[show edit update destroy]
  before_action :set_query, only: %i[search]

  def index
    @products ||= Product.all
  end

  def show; end

  def new
    @product = Product.new
  end

  def edit; end

  def create
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        format.html do
          redirect_to product_url(@product), notice: 'Produto criado com sucesso!'
        end
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html do
          redirect_to product_url(@product), notice: 'Produto atualizado com sucesso!'
        end
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @product.destroy

    respond_to do |format|
      format.html { redirect_to products_url, notice: 'Produto removido com sucesso!' }
      format.json { head :no_content }
    end
  end

  def search; end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:name, :sku, :unit)
  end

  def set_stock_balance
    @product.stock_balance
  end

  def set_query
    case params[:field_select]
    when 'both'
      @products =
        Product.where('name ILIKE ? OR sku ILIKE ?', "%#{params[:query]}%", "%#{params[:query]}%")
    when 'name'
      @products = Product.where('name ILIKE ?', "%#{params[:query]}%")
    when 'sku'
      @products = Product.where('sku ILIKE ?', "%#{params[:query]}%")
    end
  end
end
