module Win32
  module Cred
    module Native
      module Functions
        extend FFI::Library

        typedef :uint32, :dword
        typedef :string, :lpctstr

        ffi_convention :stdcall

        ffi_lib 'advapi32'

        # Read more:
        # https://msdn.microsoft.com/en-us/library/windows/desktop/aa374794%28v=vs.85%29.aspx
        #
        # BOOL CredEnumerate(in LPCTSTR Filter,
        #                    in DWORD Flags,
        #                    out DWORD *Count,
        #                    out PCREDENTIAL **Credentials)
        attach_function :cred_enumerate, :CredEnumerateW,
                        [:lpctstr, :dword, :pointer, :pointer], :bool

        # Read more:
        # https://msdn.microsoft.com/en-us/library/windows/desktop/aa374804%28v=vs.85%29.aspx
        #
        # BOOL CredRead(in LPCTSTR TargetName,
        #               in DWORD Type,
        #               in DWORD Flags,
        #               out PCREDENTIAL *Credential)
        attach_function :cred_read, :CredReadW,
                        [:lpctstr, :dword, :dword, :pointer], :bool

        # Read more:
        # https://msdn.microsoft.com/en-us/library/windows/desktop/aa375187%28v=vs.85%29.aspx
        #
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
