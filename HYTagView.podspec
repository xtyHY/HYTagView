Pod::Spec.new do |s|

  s.name         = "HYTagView"
  s.version      = "1.0"
  s.summary      = "Tag标签展示，可自由配置各种颜色样式、间距、高度，多选/单选模式，限制显示行数，主动/获取 正反选Tag"

  s.description  = <<-DESC
                    Tag标签展示
                    功能：
                      1. 自由配置各种颜色样式、间距、高度
                      2. 可开启多选/单选模式
                      3. 限制显示行数
                      4. 点击某个Tag回调
                      5. 主动根据tagId正选/反选
                      6. 主动全正选/反选
                      7. 获取所有选中/未选中
                   DESC

  s.homepage     = "https://github.com/xtyHY/HYTagView"

  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author             = { "xtyHY" => "devhy@foxmail.com" }
  s.social_media_url   = "http://www.devhy.com"

  s.platform     = :ios, "8.0"

  s.source       = { :git => "https://github.com/xtyHY/HYTagView.git", :tag => "#{s.version}" }
  s.source_files  = "HYTagView/*.{h,m}"
  s.frameworks = "UIKit", "Foundation"
  s.requires_arc = true

end
