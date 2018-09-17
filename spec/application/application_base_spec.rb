require 'rack/test'

RSpec.describe Hcheck::SinatraBase do
  it 'is a sinatra app' do
    expect(described_class).to be < Sinatra::Base
  end
  it 'include responders module' do
    expect(described_class.included_modules).to include(Hcheck::ApplicationHelpers::Responders)
  end
end
