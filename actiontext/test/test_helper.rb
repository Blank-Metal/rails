# frozen_string_literal: true

# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require_relative "../test/dummy/config/environment"
ActiveRecord::Migrator.migrations_paths = [File.expand_path("../test/dummy/db/migrate", __dir__)]
require "rails/test_help"

require "rails/test_unit/reporter"
Rails::TestUnitReporter.executable = "bin/test"

# Disable available locale checks to allow to add locale after initialized.
I18n.enforce_available_locales = false

# Load fixtures from the engine
if ActiveSupport::TestCase.respond_to?(:fixture_path=)
  ActiveSupport::TestCase.fixture_path = File.expand_path("fixtures", __dir__)
  ActionDispatch::IntegrationTest.fixture_path = ActiveSupport::TestCase.fixture_path
  ActiveSupport::TestCase.file_fixture_path = ActiveSupport::TestCase.fixture_path + "/files"
  ActiveSupport::TestCase.fixtures :all
end

class ActiveSupport::TestCase
  private
    def create_file_blob(filename:, content_type:, metadata: nil)
      ActiveStorage::Blob.create_and_upload! io: file_fixture(filename).open, filename: filename, content_type: content_type, metadata: metadata
    end
end

# Encryption
 ActiveRecord::Encryption.configure \
   primary_key: "test primary key",
   deterministic_key: "test deterministic key",
   key_derivation_salt: "testing key derivation salt",
   support_unencrypted_data: true

require_relative "../../tools/test_common"
