module Win32
  module Cred
    class Credential
      # Enumerates the credentials from the user's credential set.
      #
      # @return [Array<Win32::Cred::Credential>]
      # @raise [Win32::Cred::CredentialEnumerateError] if enumerating
      #   credentials results in an error
      def self.enumerate
        cred_count = FFI::MemoryPointer.new(:uint32)
        ppcredentials = FFI::MemoryPointer.new(:pointer)

        unless Win32::Cred.cred_enumerate(nil, 0, cred_count, ppcredentials)
          fail Win32::Cred::CredentialEnumerateError.new(Win32::Cred.get_last_error)
        end

        creds = []
        pcredentials = ppcredentials.read_pointer
        cred_count.read_uint32.times do |cred_index|
          cred_struct = pcredentials.get_pointer(cred_index * FFI.type_size(:pointer))
          creds << new(Win32::Cred::Native::Structs::CREDENTIAL.new(cred_struct))
        end
        creds
      end

      # Maps symbols to corresponding +persist+ enum values.
      #
      # @return [Hash]
      def self.persist_enum_map
        {
          session:        Win32::Cred::CRED_PERSIST_SESSION,
          local_machine:  Win32::Cred::CRED_PERSIST_LOCAL_MACHINE,
          enterprise:     Win32::Cred::CRED_PERSIST_ENTERPRISE
        }
      end

      # Reads a credential from the user's credential set.
      #
      # @param [String] name of the credential to read
      # @param [Symbol] type of the credential
      # @return [Win32::Cred::Credential]
      # @raise [Win32::Cred::CredentialReadError] if reading the credential
      #   results in an error
      def self.read(name, type)
        pcredential = FFI::MemoryPointer.new(:pointer)
        name = name.encode('utf-16le')
        type = type_enum_map[type]

        unless Win32::Cred.cred_read(name, type, 0, pcredential)
          fail Win32::Cred::CredentialReadError.new(Win32::Cred.get_last_error)
        end

        new(Win32::Cred::Native::Structs::CREDENTIAL.new(pcredential.get_pointer(0)))
      end

      # Maps symbols to corresponding +type+ enum values.
      #
      # @return [Hash]
      def self.type_enum_map
        {
          generic:                  Win32::Cred::CRED_TYPE_GENERIC,
          domain_password:          Win32::Cred::CRED_TYPE_DOMAIN_PASSWORD,
          domain_certificate:       Win32::Cred::CRED_TYPE_DOMAIN_CERTIFICATE,
          domain_visible_password:  Win32::Cred::CRED_TYPE_DOMAIN_VISIBLE_PASSWORD,
          generic_certificate:      Win32::Cred::CRED_TYPE_GENERIC_CERTIFICATE,
          domain_extended:          Win32::Cred::CRED_TYPE_DOMAIN_EXTENDED,
          maximum:                  Win32::Cred::CRED_TYPE_MAXIMUM,
          maximum_ex:               Win32::Cred::CRED_TYPE_MAXIMUM_EX
        }
      end

      # Creates a new credential or modifies an existing credential in the
      # user's credential set.
      #
      # @param [Win32::Cred::Credential]
      def self.write(credential)
        fail NotImplementedError # TODO: implement this method and all the instance setter methods
      end

      # @param [Win32::Cred::Native::Structs::CREDENTIAL] cred_struct
      def initialize(cred_struct)
        @cred_struct = cred_struct || Win32::Cred::CREDENTIAL.new
      end

      # A string comment from the user that describes this credential.
      #
      # @return [String]
      def comment
        decode_string_member(:comment)
      end

      # Secret data for the credential.
      #
      # @return [Array]
      def credential_blob
        size = @cred_struct[:credential_blob_size]
        return nil unless size > 0

        @cred_struct[:credential_blob].read_bytes(size)
      end

      # Decodes double-null terminated UTF-16LE encoded string members.
      #
      # @api private
      # @param [Symbol] member
      # @return [String]
      def decode_string_member(member)
        return nil if @cred_struct[member].null?

        @cred_struct[member]
          .read_string_dn
          .force_encoding('utf-16le')
          .strip
      end

      # List of flags that identify characteristics of the credential.
      #
      # @return [Array<Symbol>]
      def flags
        flgs = []
        flgs << :prompt_now       if 0 < @cred_struct[:flags] & Win32::Cred::CRED_FLAGS_PROMPT_NOW
        flgs << :username_target  if 0 < @cred_struct[:flags] & Win32::Cred::CRED_FLAGS_USERNAME_TARGET
        flgs
      end

      # @return [String]
      def inspect
        parts = ["#{self.class}:0x#{self.__id__.to_s(16)}"]

        %w(comment flags last_written persist target_alias target_name type user_name).each do |member|
          parts << "#{member}=#{send(member.to_sym).inspect}"
        end

        "#<#{parts.join(' ')}>"
      end

      # The time of the last modification of the credential.
      #
      # Adopted from:
      # http://www.codeography.com/2009/05/20/working-with-filetime-in-ruby.html
      #
      # @return [Time]
      def last_written
        wtime = (@cred_struct[:last_written][:dw_high_date_time] << 32) +
                (@cred_struct[:last_written][:dw_low_date_time])
        Time.at((wtime - 116444736000000000) / 10000000)
      end

      # Defines the persistence of this credential.
      #
      # @return [Symbol]
      def persist
        self.class.persist_enum_map.key(@cred_struct[:persist])
      end

      # True if the credential does not persist the credential blob and the
      # credential has not been written during this logon session.
      #
      # @return [Boolean]
      def prompt_now?
        flags.include?(:prompt_now)
      end

      # Alias for the +target_name+ member.
      #
      # @return [String]
      def target_alias
        decode_string_member(:target_alias)
      end

      # The name of the credential.
      #
      # @return [String]
      def target_name
        decode_string_member(:target_name)
      end

      # +CREDENTIAL+ struct representation of this object.
      #
      # @return [Win32::Cred::Native::Structs::CREDENTIAL]
      def to_credential_struct
        @cred_struct
      end

      # Type of the credential.
      #
      # @return [Symbol]
      def type
        self.class.type_enum_map.key(@cred_struct[:type])
      end

      # The user name of the account used to connect to +target_name+.
      #
      # @return [String]
      def user_name
        decode_string_member(:user_name)
      end

      # True if this credential has a target_name member set to the same value
      # as the user_name member.
      #
      # @return [Boolean]
      def username_target?
        flags.include?(:username_target)
      end
    end
  end
end
