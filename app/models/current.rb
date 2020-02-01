class Current < ActiveSupport::CurrentAttributes
  attribute :user
  attribute :api_request

  def user=(user)
    super
  end
  
  def api_request=(api_request)
    super
  end
  
end