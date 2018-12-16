require 'rails_helper'
RSpec.describe 'Posts', type: :request do
  before(:each) do
    @category = create(:category)
    @post     = create(:post, category_id: @category.id)
   end

   describe 'GET /posts' do
     it 'returns a all posts' do
       get '/posts'
       expect(response).to have_http_status(:ok)
       expect(assigns(:posts)).to eq(Post.last(10))
     end
   end

   describe 'GET /posts/:id' do
     it 'returns a  post' do
       get "/posts/#{@post.id}"
       expect(response).to have_http_status(:ok)
       expect(assigns(:post)).to eq(@post)
     end
   end

   describe 'POST /posts' do
    it 'create a new post' do
      post(
        '/posts',
        params: {
          post: {
            title: 'title',
            content: 'content',
            category_id: @category.id
          }
        }
      )
      expect(response).to have_http_status(:created)
      expect(Post.last.title).to eq('title')
      expect(Post.last.content).to eq('content')
    end

    it 'create a new post with invalid attributes' do
      post(
        '/posts',
        params: {
          post: {
            title: '',
            content: '',
            category_id: @category.id
          }
        }
      )
      expect(response).to have_http_status(:bad_request)
    end
  end

  describe 'PUT /posts/:id' do
    it 'update a post' do
      put("/posts/#{@post.id}", params: { post: { title: 'new post title'} })
      @updated_post = Post.find_by(id: @post.id)
      expect(response).to have_http_status(:ok)
      expect(@updated_post.title).to eq('new post title')
    end

    it 'update a post with invalid attributes' do
      @updated_post = Post.find_by(id: @post.id)
      put("/posts/#{@post.id}", params: { post: { title: ''} })
      expect(response).to have_http_status(:bad_request)
      expect(@post.title).to eq(@updated_post.title)
    end
  end

  describe 'DELETE /posts/:id' do
    it 'delete a post' do
      @old_id = @post.id
      delete("/posts/#{@post.id}")
      expect(response).to have_http_status(302)
      expect(Post.find_by_id(@old_id)).to eq(nil)
    end
  end
end
