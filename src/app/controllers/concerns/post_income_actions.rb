module PostIncomeActions
  private

  def create_record
    if created_instance.save
      flash[:success] = "#{created_instance.price}円の#{record_type}を作成しました"
      # SampleJob.perform_later
      redirect_to action: :new
    else
      flash[:warning] = '正しい値を入力してください'
      render 'new'
    end
  end

  def update_record
    if updated_instance.update(strong_params)
      flash[:success] = "#{strong_params[:price]}円の#{record_type}の編集に成功しました"
      redirect_to path_after_update
    else
      flash[:warning] = '正しい値を入力してください'
      render 'edit'
    end
  end
  
  def destroy_record
    updated_instance.destroy
    redirect_to path_after_update
    flash[:success] = "#{updated_instance.price}円の#{record_type}を削除しました"
  end

  def created_instance
    raise NotImplementedError
  end

  def updated_instance
    raise NotImplementedError
  end

  def path_after_update
    raise NotImplementedError
  end

  def record_type
    raise NotImplementedError
  end

end