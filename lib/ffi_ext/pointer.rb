module FFI
  class Pointer
    # Reads a double null-terminated string
    #
    # http://stackoverflow.com/questions/9293307/ruby-ffi-ruby-1-8-reading-utf-16le-encoded-strings
    def read_string_dn(max=0)
      cont_nullcount = 0
      offset = 0
      until cont_nullcount == 2
        byte = get_bytes(offset,1)
        cont_nullcount += 1 if byte == "\000"
        cont_nullcount = 0 if byte != "\000"
        offset += 1
      end
      get_bytes(0,offset+1)
    end
  end
end
