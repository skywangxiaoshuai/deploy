# required
WxPay.appid = 'wxc2cdfa5d6fb7caa9'
WxPay.key = '6cJLK2UBDHfDCvtEQTLplboR2KnqKNE5'
WxPay.mch_id = '1281019601'
WxPay.debug_mode = true # default is `true`
WxPay.sandbox_mode = false # default is `false`

#1423110002 测试用子商户号


# cert, see https://pay.weixin.qq.com/wiki/doc/api/app/app.php?chapter=4_3
# using PCKS12
WxPay.set_apiclient_by_pkcs12(File.read("/pay/wechat_pay_certificate/apiclient_cert.p12"), "1281019601")

# if you want to use `generate_authorize_req` and `authenticate`
# WxPay.appsecret = 'YOUR_SECRET'

# optional - configurations for RestClient timeout, etc.
WxPay.extra_rest_client_options = {timeout: 2, open_timeout: 3}