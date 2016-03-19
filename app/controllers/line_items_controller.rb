class LineItemsController < ApplicationController
	
  # Saved in concerns, sets the current cart as passed through from params or creates a new one
	include CurrentCart
	before_action :set_cart, only:[:create]
  before_action :set_line_item, only: [:show, :edit, :update, :destroy]

  
  def index
    @line_items = LineItem.all
  end

  def show
  end

  def new
    @line_item = LineItem.new
  end

  def edit
  end

  def create
		product = Product.find(params[:product_id])
		# @cart defined in CurrentCart concern
		@line_item = @cart.add_product(product.id)

    respond_to do |format|
      if @line_item.save
        format.html { redirect_to store_url }
        # For AJAX request
        format.js {@current_item = @line_item}
        format.json { render :show, status: :created, location: @line_item }
      else
        format.html { render :new }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @line_item.update(line_item_params)
        format.html { redirect_to store_url }
        format.json { render :show, status: :ok, location: @line_item }
      else
        format.html { render :edit }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @line_item.destroy
    respond_to do |format|
      format.html { redirect_to line_items_url, notice: 'Line item was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    
    def set_line_item
      @line_item = LineItem.find(params[:id])
    end

    
    def line_item_params
      params.require(:line_item).permit(:product_id)
    end
end
