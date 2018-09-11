require 'rack/test'

RSpec.describe Hcheck::Application do
  it "include responders module" do
    expect(Hcheck::Base.included_modules).to include(Hcheck::ApplicationHelpers::Responders)
  end
end
