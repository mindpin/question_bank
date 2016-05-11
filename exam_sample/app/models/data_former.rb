class DataFormer
  include DataFormerConfig

  include UserFormer

  def self.paginate_data(models)
    begin
      {
        total_pages: models.total_pages,
        current_page: models.current_page,
        per_page: models.limit_value
      }
    rescue
      {}
    end
  end
end
