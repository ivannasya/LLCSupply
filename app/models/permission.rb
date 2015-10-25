class Permission < Struct.new(:user)
  def allow?(controller, action, resource = nil)
    return true if controller == 'sessions'
    if user
      return true if controller == 'loads' && action == 'index'
      return true if controller == 'loads' && action == 'show' && !resource.nil? && resource.driver_id == user.id
      return true if user.dispatcher?
    end
    false
  end
end