class SearchService
  SEARCH_MODELS = %w(All Question Answer Comment User).freeze
  def search(query, model)
    models = 
      if model == 'All'
        SEARCH_MODELS.drop(1).map{|model| model.classify.constantize}
      else
        model.classify.constantize
      end
    results = run_elastic(query, models).records.to_a
    parse_results(results)
  end

  private

  def run_elastic(query, models)
    Elasticsearch::Model.search(query, models)
  end

  def parse_results(results)
    results.map do |record|
      {
        title: get_record_title(record),
        details: get_details(record),
        controller: record.model_name.plural,
        id: record.id
      }
    end
  end

  def get_record_title(record)
    case record.class.to_s.downcase.to_sym
    when :question then record.title
    when :answer then record.question.title
    when :comment then get_record_title(record.commentable)
    when :user then record.email
    end
  end

  def get_details(record)
    if record.class.to_s == 'User'
      record.email
    else
      record.body
    end
  end
end