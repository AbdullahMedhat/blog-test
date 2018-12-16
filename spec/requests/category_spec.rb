require 'rails_helper'
RSpec.describe 'Categories', type: :request do

	before(:each) do
		@category = create(:category)
	 end

	 describe 'GET /categories' do
     it 'returns a all categories' do
       get '/categories'
       expect(response).to have_http_status(:ok)
       expect(assigns(:categories)).to eq(Category.all)
	   end
   end

   describe 'POST /categories' do
    it 'create a new category' do
     post('/categories', params: { category: { name: 'new category' } } )
     expect(response).to have_http_status(:created)
     expect(Category.last.name).to eq('new category')
    end

    it 'create a new category with invalid attributes' do
      post('/categories', params: { category: { name: '' } } )
      expect(response).to have_http_status(:bad_request)
    end
  end

  describe 'PUT /categories/:id' do
    it 'update a category' do
      put("/categories/#{@category.id}", params: { category: { name: 'new category name'} })
      @updated_category= Category.find_by(id: @category.id)
      expect(response).to have_http_status(:ok)
      expect(@updated_category.name).to eq('new category name')
    end

    it 'update a category with invalid attributes' do
      @updated_category= Category.find_by(id: @category.id)
      put("/categories/#{@category.id}", params: { category: { name: ''} })
      expect(response).to have_http_status(:bad_request)
      expect(@category.name).to eq(@updated_category.name)
    end
  end

  describe 'DELETE /categories/:id' do
    it 'delete a category' do
      @old_id = @category.id
      delete("/categories/#{@category.id}")
      expect(response).to have_http_status(302)
      expect(Category.find_by_id(@old_id)).to eq(nil)
    end
  end
end
