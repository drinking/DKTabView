#
# Be sure to run `pod lib lint DKTabView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "DKTabView"
  s.version          = "0.2.1"
  s.summary          = "A custom TabView."

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!  
  s.description      = <<-DESC
   DKTabView is a class designed to simplify the implementation of various types of tab view.You can customize your TabItems and animate cursor between them.For more details to see the Example.
                       DESC

  s.homepage         = "https://github.com/drinking/DKTabView"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "drinking" => "pan49@126.com" }
  s.source           = { :git => "https://github.com/drinking/DKTabView.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'

end
