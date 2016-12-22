module ApplicationHelper
  def site_name
    "Inauguration Protest Housing"
  end

  def cause_name
    "Inauguration Protest Housing"
  end

  def site_hostname(request)
    request.host_with_port
  end

  def site_image_name
    "DSA_logo.png"
  end

  def email_contact
    "help@inaugurationprotesthousing.com"
  end

  def privacy_policy_link
    "https://github.com/DevProgress/HillaryBNB/blob/master/doc/facebook-privacy-statement.txt"
  end

  def bug_report_link
    "https://github.com/DevProgress/HillaryBNB/issues"
  end

  def github_link
    "https://github.com/DevProgress/HillaryBNB"
  end
end
