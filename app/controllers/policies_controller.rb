class PoliciesController < ApplicationController
  skip_before_action :require_current_user
  skip_before_action :require_complete_profile

  def facebook
    render text: File.readlines(
      File.expand_path("../../../doc/facebook-privacy-statement.txt", __FILE__)
    ).join("<br />")
  end
end
