require 'rails_helper'

RSpec.describe UsersController, type: :controller do

    # index action
    describe 'GET #index' do
        before do
            get :index
        end

        it 'is expected to assign user instance variable' do
            expect(assigns[:users]).to eq(User.all)
        end
    end

    # show action
    describe "GET #show" do
    user = FactoryBot.create(:user)
    it "assigns the requested user to @user" do
      get :show, params: { id: user.id }
      expect(assigns(:user)).to eq user
    end
    
    it "renders the #show view" do
      get :show, params: { id: user.id }
      expect(response).to render_template :show
    end
  end

    # new action
    describe 'GET #new' do
        before do
            get :new
        end

        it 'is expected to assign user as new instance variable' do
            expect(assigns[:user]).to be_instance_of(User)
        end
      
        it 'renders new template' do
            is_expected.to render_template(:new)
        end
      
        it 'renders application layout' do
            is_expected.to render_template(:application)
        end
    end

    # create action
    describe 'POST #create' do
    before do
      post :create, params: params
    end

    context 'when params are correct' do
      let(:params) { { user: { name: "ABC", email: "abc@test.com" } } }

      it 'is expected to create new user successfully' do
        expect(assigns[:user]).to be_instance_of(User)
      end

      it 'is expected to have name assigned to it' do
        expect(assigns[:user].name).to eq('ABC')
      end

      it 'is expected to have email assigned to it' do
        expect(assigns[:user].email).to eq('abc@test.com')
      end

      it 'is expected to redirect to users path' do
        is_expected.to redirect_to users_path
      end

    end

    context 'when params are not correct' do
      let(:params) { { user: { name: '', email: ''} } }

      it 'is expected to render new template' do
        is_expected.to render_template(:new)
      end

      it 'is expected to add errors to name attribute' do
        expect(assigns[:user].errors[:name]).to eq(['can\'t be blank'])
      end

      it 'is expected to add errors to email attribute' do
        expect(assigns[:user].errors[:email]).to eq(['can\'t be blank'])
      end

    end
  end

  # edit action
  describe 'GET #edit' do
    before do
      get :edit, params: params
    end

    context 'when user id is valid' do
      let(:user) { FactoryBot.create :user }
      let(:params) { { id: user.id } }

      it 'is expected to set user instance variable' do
        expect(assigns[:user]).to eq(User.find_by(id: params[:id]))
      end

      it 'is expected to render edit template' do
        is_expected.to render_template(:edit)
      end
    end

  end

    # update action
    describe 'PATCH #update' do

    before do
      patch :update, params: params
    end

    context 'when user exist in database' do
      let(:user) { FactoryBot.create :user }
      let(:params) { { id: user.id, user: { name: 'test name', email: 'testname@demo.com' } } }

      context 'when data is provided is valid' do
        it 'is expected to update user' do
          expect(user.reload.name).to eq('test name')
        end

        it 'is expected to update user' do
            expect(user.reload.email).to eq('testname@demo.com')
        end

        it 'is_expected to redirect_to users_path' do
          is_expected.to redirect_to(users_path)
        end
      end

      context 'when data is invalid' do
        let(:user) { FactoryBot.create :user }
        let(:params) { { id: user.id, user: { name: '', email: '' } } }

        it 'is expected not to update user name' do
          expect(user.reload.name).not_to be_empty
        end

        it 'is expected not to update user email' do
            expect(user.reload.email).not_to be_empty
        end

        it 'is expected to render edit template' do
          expect(response).to render_template(:edit)
        end
      end
    end
  end

  describe 'DELETE destroy' do
    context 'existing user' do
      user = FactoryBot.create(:user)

        it 'removes user from table' do
          expect { delete :destroy, params: { id: user.id } }.to change { User.count }.by(-1)
        end

        it 'renders index template' do
          delete :destroy, params: { id: user.id }
          is_expected.to redirect_to(users_path)
        end
      end
  end

end