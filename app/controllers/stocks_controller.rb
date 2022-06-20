class StocksController < ApplicationController
  before_action :set_product, only: %i[index show edit new create update]
  before_action :set_stock, only: %i[show update destroy]
  before_action :set_product_stock, only: %i[show edit]
  before_action :set_stock_params, only: %i[update]

  def index
    @stocks = @product.stocks
  end

  def show; end

  def new
    @stock = @product.stocks.build
  end

  def edit; end

  def create
    @stock = @product.stocks.send(set_type.pluralize).build(stock_params)

    respond_to do |format|
      if @stock.save
        format.html do
          redirect_to product_stock_url(@product, @stock),
                      notice: 'Estoque criado com sucesso.'
        end
        format.json { render :show, status: :created, location: @stock }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @stock.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @stock.update(stock_params)
        format.html do
          redirect_to product_stocks_path(@product), notice: 'Estoque atualizado com sucesso.'
        end
        format.json { render :show, status: :ok, location: @stock }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @stock.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @stock.destroy

    respond_to do |format|
      format.html do
        redirect_to product_stocks_path(@stock.product), notice: 'Estoque removido com sucesso.'
      end
      format.json { head :no_content }
    end
  end

  def set_type
    case params[:stock][:type]
    when 'StockIncrement'
      'stock_increment'
    when 'StockDecrement'
      'stock_decrement'
    end
  end

  private

  def set_product
    @product = Product.find(params[:product_id])
  end

  def set_stock
    @stock = Stock.find(params[:id])
  end

  def set_product_stock
    @stock = @product.stocks.find(params[:id])
  end

  def stock_params
    params.require(:stock).permit(:product_id, :quantity, :type, :integralized_at)
  end

  def set_stock_params
    params[:stock] = params[:stock_increment] || params[:stock_decrement] unless params[:stock]
  end
end
