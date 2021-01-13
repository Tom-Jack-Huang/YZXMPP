#
#  Be sure to run `pod spec lint YZXMPP.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  s.name         = "YZXMPP"
  s.version      = "0.0.1"
  s.summary      = "YZXMPP 一个基于XMPP的IM系统"
  
  s.homepage     = "https://github.com/Tom-Jack-Huang/YZXMPP"
  
  s.license      = "MIT"
  
  s.author       = { "HL" => "1025925701@.com" }
  
  s.platform     = :ios
  s.platform     = :ios, "10.0"
  
  
  s.source       = { :git => "https://github.com/Tom-Jack-Huang/YZXMPP.git", :tag => s.version}
  
  
  s.source_files  = "YZXMPP/IM/**/*.{h,m}"
  
  
  s.requires_arc = true
  
  
  s.dependency 'XMPPFramework', '>= 4.0.0'
  s.dependency 'BGFMDB', '>= 2.0.13'
  s.dependency 'MJExtension', '>= 3.2.2'
  s.dependency 'YTKNetwork', '>= 3.0.4'
  s.dependency 'CocoaSecurity', '>= 1.2.4'

end
