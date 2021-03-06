class OrdersController < ApplicationController
    before_action :authenticate_admin_user! , :except=>[:show,:index]
  def index
    if current_admin_user and current_admin_user.role == 'seller'
      @orders = current_admin_user.order_products.where(status: ['pending', 'confirmed'])
    elsif current_admin_user and current_admin_user.role == 'buyer'
      @orders = current_admin_user.buyerOrders
    else
      @orders = Order.all
    end
  end
  
  def new
    @order = Order.new
  end

  def approve
    @order_product = OrderProduct.find(params[:id])
    @order_product.status = 'confirmed'
    @order_product.save

    confirmed = true
    order = @order_product.order
    order.order_products.each do |item|
      if item.status != 'confirmed'
        cofirmed = false
        break
      end
    end
    if confirmed
      order.status = 'confirmed'
      order.save
    end
    redirect_to orders_path
  end

  def confirm
    @order_product = OrderProduct.find(params[:id])
    @order_product.status = 'delivered'
    @order_product.save

    confirmed = true
    order = @order_product.order
    order.order_products.each do |item|
      if item.status != 'delivered'
        cofirmed = false
        break
      end
    end
    if confirmed
      order.status = 'delivered'
      order.save
    end
    redirect_to orders_path
  end

  def destroy
    if current_admin_user and current_admin_user.role == 'seller'
      @order = OrderProduct.find(params[:id])
      @order.status = 'canceled'
      @order.save
    elsif current_admin_user and current_admin_user.role == 'buyer'
      @order = Order.find(params[:id])
      @order.destroy
    end
    redirect_to orders_path
  end
end
