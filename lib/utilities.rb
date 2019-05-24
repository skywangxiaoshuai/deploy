module Utilities
  # Adapt to base64 image
  def adapt_to_base64(data)
    image = Paperclip.io_adapters.for(data)
    image.original_filename = 'file' + Rack::Mime::MIME_TYPES.invert[data[/[-\w]+\/[-\w\+\.]+/]]
    image
  end

  def decryption(key, data)
    # 解密步骤如下：
    # （1）对加密串req_info做base64解码，得到加密串req_info
    # （2）对商户key做md5，得到32位小写key
    # （3）用key对加密串得到加密串req_info做AES-256-ECB解密（PKCS7Padding）
    #对data做base64解码
    data = Base64.decode64(data)
    #对商户key做md5加密
    key = Digest::MD5.hexdigest(key)
    cipher = OpenSSL::Cipher.new('AES-256-ECB')
    cipher.decrypt()
    cipher.key = key
    crypt = cipher.update(data)
    crypt << cipher.final()
    return crypt
  end

end