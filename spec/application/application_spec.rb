RSpec.describe Hcheck::Application do
  it_behaves_like Hcheck::ApplicationHelpers::Responders do
    let(:application) do
      Hcheck::Configuration.load_file(FIXTURE_HCHECK_FILE_PATH)
      Hcheck::Application.new
    end
    let(:path) { '/hcheck' }
  end
end
