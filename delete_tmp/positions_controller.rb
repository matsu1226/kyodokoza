class Api::Category::PositionsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def update
    category = Category.find_by!(position: params[:from].to_i + 1) # 0から始まるので+1する
    category.update!(position: params[:to].to_i + 1) # 0から始まるので+1する
    head :ok    # ヘッダだけで本文 (body) のないレスポンスをブラウザに送信(ok => 200)
    categories = current_user.relationship.categories.sorted
    logger.debug "categories(id, name, position) => #{categories.map{|c| [c.id, c.name, c.position] }}"
  end
end