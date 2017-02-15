require "rails_helper"

describe "home/sign_in" do
  it "gives instructions to new users" do
    render
    expect(rendered).to match(/This website helps out of town DSA members/)
  end
end
