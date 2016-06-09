require 'rails_helper'

RSpec.describe WelcomeController, type: :controller do
  describe '#index' do
    before do
      get :index
    end

    context '複数のイベント情報が登録されている時' do
      let(:events) { create_list(:event, 10) }
      let(:include_closed_events) { create_list(:event, 10, :has_closed_start_time).concat(events) }
      let(:filtered_events) { include_closed_events.select { |event| event.start_time > Time.zone.now } }

      it 'イベント情報を開催時間の昇順で返すこと' do
        expect(assigns(:events)).to match filtered_events.sort { |a, b| a.start_time <=> b.start_time }
      end

      it '未開催のイベント情報のみを返すこと' do
        expect(assigns(:events)).to match_array filtered_events
      end
    end

    context 'イベントが登録されていなかった時' do
      it '空のイベント情報を返すこと' do
        expect(assigns(:events)).to be_empty
      end
    end

    context '開催時刻が現在時刻と等しいイベントしか登録されてなかった時' do
      it '空のイベント情報を返すこと' do
        expect(assigns(:events)).to be_empty
      end
    end

    context '現在時刻より古い開催時間のイベントしか登録されていなかった時' do
      it '空のイベント情報を返すこと' do
        expect(assigns(:events)).to be_empty
      end
    end
  end
end
