module Win32
  module Cred
    # Base error class for all credential-related errors
    class CredentialError < StandardError; end

    # Base error class for all credential-related errors pertaining to native
    # calls
    class CredentialNativeError < StandardError
      def initialize(last_error_code)
        @last_error_code
      end
    end

    # Raised when enumerating credentials results in an error
    class CredentialEnumerateError < CredentialError
      def message
        "Error enumerating credentials: #{@last_error_code}"
      end
    end

    # Raised when reading credentials results in an error
    class CredentialReadError < CredentialError
      def message
        "Error reading credential: #{@last_error_code}"
      end
    end

    # Raised when writing credentials results in an error
    class CredentialWriteError < CredentialError
      def message
        "Error writing credential: #{@last_error_code}"
      end
    end
  end
end
