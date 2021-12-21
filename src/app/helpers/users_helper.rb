module UsersHelper
  def item_type(item)
    if item.instance_of?(Income)
      '収入'
    else
      '支出'
    end
  end

  def text_align_by_user(user)
    if user == current_user
      'left'
    else
      'right'
    end
  end
end
