# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UrlsController, type: :controller do
  describe 'GET #index' do
    it 'shows the latest 10 URLs' do
      urls = FactoryBot.create_list(:url, 20)
      get :index

      expect(assigns(:urls)).to include(*urls.last(10))
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new url' do
        expect do
          post :create, params: { url: { original_url: 'http://google.com/foo' } }
        end.to change { Url.count }.by(1)
      end
    end

    context 'with invalid params' do
      it 'does not create the new url' do
        expect do
          post :create, params: { url: { original_url: 'foo' } }
        end.not_to change { Url.count }
      end
    end
  end

  describe 'GET #show' do
    it 'shows stats about the given URL' do
      url = FactoryBot.create(:url)

      get :show, params: { url: url.short_url }

      expect(response).to render_template(:show)
    end

    it 'throws 404 when the URL is not found' do
      get :show, params: { url: 'foo' }

      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'GET #visit' do
    it 'tracks click event and stores platform and browser information' do
      url = FactoryBot.create(:url)

      expect do
        get :visit, params: { url: url.short_url }
      end.to change { url.clicks.count }.by(1)


      ## IMPLEMENT CLICK ATTRIBUTE EXPECTATIONS
    end

    it 'redirects to the original url' do
      url = FactoryBot.create(:url)

      get :visit, params: { url: url.short_url }

      expect(response).to redirect_to(url.original_url)
    end

    it 'throws 404 when the URL is not found' do
      get :visit, params: { url: 'foo' }

      expect(response).to have_http_status(:not_found)
    end
  end
end
