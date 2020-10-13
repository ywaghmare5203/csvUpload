class HomeController < ApplicationController
  def index
  	@product = ProductDetail.all
  end
  def import
  	product = PorductImporterForm.new(conversation_params)

    if product.save
      flash[:success] = "Your data have been imported!"
    else
      flash[:error] = product.full_error_messages
    end

    redirect_to root_path
  end

  private
  def conversation_params
  	params.require(:import).permit(:file)
  end
end
