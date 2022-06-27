shared_examples_for 'API Deletable' do
  before do
    delete api_path, params: { access_token: access_token.token }
  end

  it 'returns status 200' do
    expect(response.status).to eq 200
  end

  it 'detroy question from db' do
    expect(klass.constantize.count).to eq 0
  end

  it 'returns successfully message' do
    expect(json['message']).to include "#{klass} successfuly deleted"
  end
end