module UsersHelper

  def item_type(item)
    if item.class == Income
      "収入"
    else
      "支出"
    end

  end
end
