module CategoriesHelper
  #application_controllerにinclude

  def make_sum_target_price(categories)
    @sum_target_price = 0 
    categories.each { |c| @sum_target_price += c.target_price }
  end
end
