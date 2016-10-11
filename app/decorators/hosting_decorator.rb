class HostingDecorator < Draper::Decorator
  delegate_all

  def location
    city? && state? ? "#{city}, #{state.to_s}" : zipcode
  end

  def num_guest_details
    max_guests > 1 ? " #{max_guests} guests" : " #{max_guests} guest"
  end

  def guest_details
    (accomodation_type == 'home' ? 'private home' : 'hotel share') + ", " + num_guest_details
  end
end
