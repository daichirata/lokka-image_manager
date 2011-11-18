require 'zlib'


def zlib(obj)
  Zlib::Deflate.deflate(obj)
end

def hex_zlib(obj)
  zlib(obj).unpack("H*").first
end

def hex_marshal_zlib(obj)
  (zlib(Marshal.dump(obj).unpack("H*").first)).unpack("H*").first
end

#url = "http://google.co.jp"
#long_url = url * 1000

url = {:url => "http://google.co.jp", :service => :picasa, :date => "2011-01-01",:thumbnail => "hogehogehogehgohegheogh"}
long_url = url.to_s * 1000

long_zlib_url = zlib(long_url.to_s)
long_hex_zlib_url = hex_zlib(long_url.to_s)
long_hex_marshal_zlib_url = hex_marshal_zlib(long_url)

puts <<-EOF
url = "http://google.co.jp"
long_url = url * 1000
-----------------------------------
Long URL
size:#{long_url.size} byte

Zlib URL
size:#{long_zlib_url.size} byte

HEX Zlib URL
size:#{long_hex_zlib_url.size} byte

HEX Marshal Zlib URL
size:#{long_hex_marshal_zlib_url.size} byte
EOF

