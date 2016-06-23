module ApplicationHelper
  def site_name
    "HillaryBNB"
  end

  def cause_name
    "Hillary Clinton"
  end

  def site_hostname(request)
    request.host_with_port
  end

  def site_image_name
    "mark-h.svg"
  end

  def email_contact
    "dsjoerg@gmail.com"
  end

  def privacy_policy_link
    "https://github.com/dsjoerg/BernieBNB/blob/master/doc/facebook-privacy-statement.txt"
  end

  def bug_report_link
    "https://github.com/dsjoerg/BernieBNB/issues"
  end

  def github_link
    "https://github.com/dsjoerg/BernieBNB"
  end
end
