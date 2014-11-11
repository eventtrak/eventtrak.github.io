module TicketsHelper
  def ceil_nearest_half(amount)
    return (amount * 2.0).ceil / 2.0
  end

end
