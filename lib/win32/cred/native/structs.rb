module Win32
  module Cred
    module Native
      module Structs
        extend ::FFI::Library

        typedef :uint32, :dword
        typedef :pointer, :lpbyte
        typedef :pointer, :lptstr

        class FILETIME < ::FFI::Struct
          layout :dw_low_date_time, :uint32,
                 :dw_high_date_time, :uint32

        end

        class CREDENTIAL < ::FFI::Struct
          layout :flags, :dword,
                 :type, :dword,
                 :target_name, :lptstr,
                 :comment, :lptstr,
                 :last_written, Win32::Cred::Native::Structs::FILETIME,
                 :credential_blob_size, :dword,
                 :credential_blob, :lpbyte,
                 :persist, :dword,
                 :attribute_count, :dword,
                 :attributes, :pointer, # Pointer to array of CREDENTIAL_ATTRIBUTE structs
                 :target_alias, :lptstr,
                 :user_name, :lptstr
        end
      end
    end
  end
end
