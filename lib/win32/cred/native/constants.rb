module Win32
  module Cred
    module Native
      module Constants
        # Flags that identify the characteristics of a credential
        CRED_FLAGS_PROMPT_NOW      = 0x00000002
        CRED_FLAGS_USERNAME_TARGET = 0x00000004

        # Types of a credential
        CRED_TYPE_GENERIC                 = 0x00000001
        CRED_TYPE_DOMAIN_PASSWORD         = 0x00000002
        CRED_TYPE_DOMAIN_CERTIFICATE      = 0x00000003
        CRED_TYPE_DOMAIN_VISIBLE_PASSWORD = 0x00000004
        CRED_TYPE_GENERIC_CERTIFICATE     = 0x00000005
        CRED_TYPE_DOMAIN_EXTENDED         = 0x00000006
        CRED_TYPE_MAXIMUM                 = 0x00000007
        CRED_TYPE_MAXIMUM_EX              = CRED_TYPE_MAXIMUM + 1000

        # Persistence of a credential
        CRED_PERSIST_SESSION       = 0x00000001
        CRED_PERSIST_LOCAL_MACHINE = 0x00000002
        CRED_PERSIST_ENTERPRISE    = 0x00000003
      end
    end
  end
end
