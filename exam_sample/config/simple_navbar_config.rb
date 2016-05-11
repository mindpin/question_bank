# -*- encoding : utf-8 -*-
SimpleNavbar::Base.config do
  # rule :simple do
  #   nav :index, :name => '首页', :url => '/' do
  #     # 当 controler 是 index_controller, action 是 index
  #     # 当前 nav 被选中
  #     controller :questions, :only => :do_question

  #     # only 参数支持数组形式
  #     # controller :index, :only => [:index]
  #     # 同时还支持 except 参数
  #     # controller :index, :except => [:index]
  #     # controller :index, :except => :index
  #   end

  #   nav :books, :name => '书籍', :url => '/books' do
  #     # 当 controler 是 books_controller
  #     # 当前 nav 被选中
  #     controller :books
  #   end

  #   nav :movies, :name => '电影', :url => '/movies' do
  #     controller :movies
  #   end

  #   nav :musics, :name => '音乐', :url => '/musics' do
  #     controller :musics
  #   end
  # end

  # rule :multi_level_example do
  #   nav :index, :name => '首页', :url => '/' do
  #     controller :index, :only => :index
  #   end

  #   nav :movies, :name => '电影', :url => '/movies' do
  #     controller :movies
  #   end

  #   nav :musics, :name => '音乐', :url => '/musics' do
  #     # 一个 nav 下支持配置多个 controller
  #     controller :musics
  #     controller :pop_musics
  #     controller :rock_musics
  #     controller :punk_musics

  #     nav :pop_musics, :name => '流行音乐', :url => '/musics/pop' do
  #       controller :pop_musics
  #       controller :rock_musics
  #       controller :punk_musics
  #       # nav 支持任意层级的嵌套
  #       nav :rock_musics, :name => '摇滚音乐', :url => '/musics/pop/rock' do
  #         controller :rock_musics
  #         controller :punk_musics

  #         nav :punk_musics, :name => '朋克', :url => '/musics/pop/rock/punk' do
  #           controller :punk_musics
  #         end
  #       end

  #     end
  #   end
  # end

  # # 可以同时配置多个 rule
  # rule [:rule_1, :rule_2] do
  #   nav :index, :name => '首页', :url => '/' do
  #     controller :index, :only => :index
  #   end

  #   nav :books, :name => '书籍', :url => '/books' do
  #     controller :books
  #   end

  #   nav :movies, :name => '电影', :url => '/movies' do
  #     controller :movies
  #   end

  #   nav :musics, :name => '音乐', :url => '/musics' do
  #     controller :musics
  #   end
  # end

  # rule :admin do
  #   nav :index, :name => '首页', :url => '/admin' do
  #     # 支持带 namespace 的 controller
  #     controller :'admin/index'
  #   end
  # end

end
