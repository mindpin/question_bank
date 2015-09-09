module QuestionBank
  module ApplicationHelper
    def custom_paginate (data)
      last_page = data.total_pages
      params[:page] = params[:page].to_i
      if last_page>5
        capture_haml do 
          case  params[:page]
            when 1            
              self.haml_tag :ul , :class=>"pagination" do
                1.upto(5) do |i|
                  if i == 1
                    self.haml_tag :li,:class=>"active" do
                      self.haml_tag :a ,"1", :href =>  "/questions?page=1"
                    end
                  else
                    self.haml_tag :li do
                      self.haml_tag :a ,"#{i}", :href =>  "/questions?page=#{i}"
                    end
                  end
                end
                self.haml_tag :li do
                  self.haml_tag :a ,">>", :href =>  "/questions?page=2"
                end
              end
            when 2            
              self.haml_tag :ul , :class=>"pagination" do
                self.haml_tag :li do
                  self.haml_tag :a ,"<<", :href =>  "/questions?page=1"
                end
                1.upto(5) do |i|
                  if i == 2
                    self.haml_tag :li,:class=>"active" do
                      self.haml_tag :a ,"2", :href =>  "/questions?page=2"
                    end
                  else
                    self.haml_tag :li do
                      self.haml_tag :a ,"#{i}", :href =>  "/questions?page=#{i}"
                    end
                  end
                end
                self.haml_tag :li do
                  self.haml_tag :a ,">>", :href =>  "/questions?page=3"
                end
              end
            when last_page
              self.haml_tag :ul , :class=>"pagination" do
                self.haml_tag :li do
                  self.haml_tag :a ,"<<", :href =>  "/questions?page=#{last_page-1}"
                end
                (last_page-4).upto(last_page) do |i|
                  if i==last_page
                    self.haml_tag :li,:class=>"active" do
                      self.haml_tag :a ,"#{last_page}", :href =>  "/questions?page=#{last_page}"
                    end
                  else
                    self.haml_tag :li do
                      self.haml_tag :a ,"#{i}", :href =>  "/questions?page=#{i}"
                    end
                  end
                end
              end
            when last_page-1
              self.haml_tag :ul , :class=>"pagination" do
                self.haml_tag :li do
                  self.haml_tag :a ,"<<", :href =>  "/questions?page=#{last_page-2}"
                end
                current_location = last_page-1
                (last_page-4).upto(last_page) do |i|
                  if i == last_page-1
                    self.haml_tag :li,:class=>"active" do
                      self.haml_tag :a ,"#{last_page-1}", :href =>  "/questions?page=#{last_page-1}"
                    end
                  else
                    self.haml_tag :li do
                      self.haml_tag :a ,"#{i}", :href =>  "/questions?page=#{i}"
                    end
                  end
                end
                self.haml_tag :li do
                  self.haml_tag :a ,">>", :href =>  "/questions?page=#{last_page}"
                end
              end
            else
              self.haml_tag :ul , :class=>"pagination" do
                self.haml_tag :li do
                  self.haml_tag :a ,"<<", :href =>  "/questions?page=#{params[:page]-1}"
                end
                (params[:page]-2).upto(params[:page]+2) do |i|
                  if i == params[:page]
                    self.haml_tag :li,:class=>"active" do
                      self.haml_tag :a ,"#{i}", :href =>  "/questions?page=#{i}"
                    end
                  else
                    self.haml_tag :li do
                      self.haml_tag :a ,"#{i}", :href =>  "/questions?page=#{i}"
                    end
                  end
                end
                self.haml_tag :li do
                  self.haml_tag :a ,">>", :href =>  "/questions?page=#{params[:page]+1}"
                end
              end
          end
        end
      else
        case params[:page]
        when 1
          capture_haml do
            self.haml_tag  :ul , :class=>"pagination" do
              last_page.times do |i|
                if i == 0
                  self.haml_tag :li,:class=>"active" do  
                    self.haml_tag :a ,"#{i+1}", :href =>  "/questions?page=#{i+1}"
                  end
                else
                  self.haml_tag :li do   
                    self.haml_tag :a ,"#{i+1}", :href =>  "/questions?page=#{i+1}"
                  end
                end
              end
               self.haml_tag :li do
               self.haml_tag :a ,">>", :href =>  "/questions?page=#{params[:page]+1}"
               end
            end
          end
        when last_page
          capture_haml do
            self.haml_tag :ul , :class=>"pagination" do
              self.haml_tag :li do
                self.haml_tag :a ,"<<", :href =>  "/questions?page=#{params[:page]-1}"
              end
              last_page.times do |i|
                if i == last_page-1
                  self.haml_tag :li,:class=>"active" do  
                    self.haml_tag :a ,"#{i+1}", :href =>  "/questions?page=#{i+1}"
                  end
                else
                  self.haml_tag :li do   
                    self.haml_tag :a ,"#{i+1}", :href =>  "/questions?page=#{i+1}"
                  end
                end
              end
            end
          end
        else
         capture_haml do
            self.haml_tag :ul , :class=>"pagination" do
              self.haml_tag :li do
              self.haml_tag :a ,"<<", :href =>  "/questions?page=#{params[:page]-1}"
              end
              last_page.times do |i|
                if  i==params[:page]-1
                  self.haml_tag :li,:class=>"active" do     
                    self.haml_tag :a ,"#{i+1}", :href =>  "/questions?page=#{i+1}"
                  end
                else
                  self.haml_tag :li do    
                    self.haml_tag :a ,"#{i+1}", :href =>  "/questions?page=#{i+1}"
                  end
                end
              end
              self.haml_tag :li do
                self.haml_tag :a ,">>", :href =>  "/questions?page=#{params[:page]+1}"
              end
            end
          end      
        end
      end
    end

    def english_choices
      @english_choices ||= ('A'..'Z').to_a
    end
  end 
end
