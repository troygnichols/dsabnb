class HomeController < ApplicationController
  skip_before_action :require_current_user
  skip_before_action :require_complete_profile
  def sign_in
  end

  def five_hundred
    puts "YO YO YO"
    puts 1/0
    render text: "this is it"
  end
end
