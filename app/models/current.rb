class Current < ActiveSupport::CurrentAttributes
  attribute :user

  def user=(user)
    super
  end
end