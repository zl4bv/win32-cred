module Win32
  module Cred
    module Native
      module Functions
        extend FFI::Library

        typedef :uint32, :dword
        typedef :string, :lpctstr

        ffi_convention :stdcall

        ffi_lib 'advapi32'

        # BOOL CredEnumerate(in LPCTSTR Filter,
        #                    in DWORD Flags,
        #                    out DWORD *Count,
        #                    out PCREDENTIAL **Credentials)
        attach_function :cred_enumerate, :CredEnumerateW,
                        [:lpctstr, :dword, :dword, :pointer], :bool

        # BOOL CredWrite(in PCREDENTIAL Credential,
        #                in DWORD Flags)
        attach_function :cred_write, :CredWriteW,
                        [:pointer, :dword], :bool

        ffi_lib 'kernel32'

        # DWORD WINAPI GetLastError(void)
        attach_function :get_last_error, :GetLastError,
                        [], :dword
      end
    end
  end
end
