require 'ffi'
require 'ffi_ext/pointer'

require 'win32/cred/native/constants'
require 'win32/cred/native/functions'
require 'win32/cred/native/structs'
require 'win32/cred/credential'
require 'win32/cred/error'
require 'win32/cred/version'

module Win32
  module Cred
    include Win32::Cred::Native::Constants
    extend Win32::Cred::Native::Functions
    extend Win32::Cred::Native::Structs
    extend Win32::Cred::Native::Constants
  end
end
