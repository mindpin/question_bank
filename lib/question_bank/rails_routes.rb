module QuestionBank
  class Routing
    def self.mount(prefix, options)
      QuestionBank.set_mount_prefix prefix
      
      Rails.application.routes.draw do
        mount QuestionBank::Engine => prefix, :as => options[:as]
      end
    end
  end
end
