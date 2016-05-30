require 'rails_helper'

RSpec.describe EventsController, type: :controller do
  describe 'GET #new' do
    context 'ログインユーザーがアクセスした時' do
      let(:user) { user = create(:user) }
      before do
        session[:user_id] = user.id

        get :new
      end

      it 'ステータスコードとして200が返ること' do
        expect(response).to have_http_status(200)
      end

      it '@eventにログインユーザーに紐付いた新規Eventオブジェクトが格納されていること' do
        expect(assigns(:event).owner).to be_a(user.class)
        expect(assigns(:event)).to be_a_new(Event)
      end

      it 'newテンプレートをrenderしていること' do
        expect(response).to render_template(:new)
      end
    end

    context '未ログインユーザーがアクセスした時' do
      before do
        get :new
      end

      it 'トップページにリダイレクトさせること' do
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
