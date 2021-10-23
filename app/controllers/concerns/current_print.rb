module CurrentPrint
  private
  def set_print
    @print = Print.find(session[:print_id])
  rescue ActiveRecord::RecordNotFound
    @print = Print.create
    session[:print_id] = @print.id
  end
end