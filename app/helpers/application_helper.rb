module ApplicationHelper
  def site_name
    "DSABNB"
  end

  def cause_name
    "DSABNB"
  end

  def site_hostname(request)
    request.host_with_port
  end

  def site_image_name
    "DSA_logo.png"
  end

  def email_contact
    "info@dsabnb.com"
  end

  def privacy_policy_link
    "https://github.com/dsausa/dsabnb/blob/master/doc/facebook-privacy-statement.txt"
  end

  def bug_report_link
    "https://github.com/dsausa/dsabnb/issues"
  end

  def github_link
    "https://github.com/dsausa/dsabnb"
  end
end
