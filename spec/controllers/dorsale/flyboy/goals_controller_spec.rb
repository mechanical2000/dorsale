describe Dorsale::Flyboy::GoalsController, type: :controller do
  routes { Dorsale::Engine.routes }

  let(:goal){
    FactoryGirl.create(:flyboy_goal)
  }

  describe '#index' do
    context 'when applying filter' do
      before(:each) do
        Dorsale::Flyboy::Goal.destroy_all
        @goal1 = FactoryGirl.create(:flyboy_goal, status: "open")
        @goal2 = FactoryGirl.create(:flyboy_goal, status: "closed")
      end

      it 'should display both when not filtered' do
        get :index
        expect(assigns(:goals)).to eq [@goal2, @goal1]
      end

      it 'should filter by status closed' do
        Dorsale::Flyboy::SmallData::FilterForGoals.new(request.cookies)
          .store(status: "closed")

        get :index
        expect(assigns(:goals)).to eq [@goal2]
      end

      it 'should filter by status open' do
        Dorsale::Flyboy::SmallData::FilterForGoals.new(request.cookies)
          .store(status: "open")

        get :index
        expect(assigns(:goals)).to eq [@goal1]
      end
    end

    context "when sorting" do
      before do
        Dorsale::Flyboy::Goal.destroy_all
        @goal1 = FactoryGirl.create(:flyboy_goal, name: "Abc", progress: 100, status: "open")
        @goal2 = FactoryGirl.create(:flyboy_goal, name: "dEF", progress: 0,   status: "closed")
        @goal3 = FactoryGirl.create(:flyboy_goal, name: "xyz", progress: 35,  status: "closed")
      end

      it "sorting by name asc" do
        get :index, sort: "name"
        expect(assigns(:goals).to_a).to eq [@goal1, @goal2, @goal3]
      end

      it "sorting by name desc" do
        get :index, sort: "-name"
        expect(assigns(:goals).to_a).to eq [@goal3, @goal2, @goal1]
      end

      it "sorting by progress asc" do
        get :index, sort: "progress"
        expect(assigns(:goals).to_a).to eq [@goal2, @goal3, @goal1]
      end

      it "sorting by progress desc" do
        get :index, sort: "-progress"
        expect(assigns(:goals).to_a).to eq [@goal1, @goal3, @goal2]
      end

      it "sorting by status asc" do
        get :index, sort: "status"
        expect(assigns(:goals).to_a).to eq [@goal2, @goal3, @goal1]
      end

      it "sorting by status desc" do
        get :index, sort: "-status"
        expect(assigns(:goals).to_a).to eq [@goal1, @goal2, @goal3]
      end
    end
  end

  describe "#show" do
    context "when sorting" do
      before do
        Dorsale::Flyboy::Goal.destroy_all
        Dorsale::Flyboy::Task.destroy_all

        @goal = FactoryGirl.create(:flyboy_goal)

        @task1 = FactoryGirl.create(:flyboy_task,
          taskable: @goal, name: "Abc", progress: 100, term: "21/12/2012", reminder: "21/12/2012")
        @task2 = FactoryGirl.create(:flyboy_task,
          taskable: @goal, name: "dEF", progress: 0,   term: "23/12/2012", reminder: "23/12/2012")
        @task3 = FactoryGirl.create(:flyboy_task,
          taskable: @goal, name: "xyz", progress: 35,  term: "22/12/2012", reminder: "22/12/2012")
      end

      it "sorting by name asc" do
        get :show, id: @goal, sort: "name"
        expect(assigns(:tasks).to_a).to eq [@task1, @task2, @task3]
      end

      it "sorting by name desc" do
        get :show, id: @goal, sort: "-name"
        expect(assigns(:tasks).to_a).to eq [@task3, @task2, @task1]
      end

      it "sorting by progress asc" do
        get :show, id: @goal, sort: "progress"
        expect(assigns(:tasks).to_a).to eq [@task2, @task3, @task1]
      end

      it "sorting by progress desc" do
        get :show, id: @goal, sort: "-progress"
        expect(assigns(:tasks).to_a).to eq [@task1, @task3, @task2]
      end

      it "sorting by term asc" do
        get :show, id: @goal, sort: "term"
        expect(assigns(:tasks).to_a).to eq [@task1, @task3, @task2]
      end

      it "sorting by term desc" do
        get :show, id: @goal, sort: "-term"
        expect(assigns(:tasks).to_a).to eq [@task2, @task3, @task1]
      end
    end
  end

  describe "#close" do
    before(:each) do
      @goal = FactoryGirl.create(:flyboy_goal, status: "open")
    end

    it "should close goal" do
      patch :close, id: @goal
      expect(@goal.reload.status).to eq "closed"
    end

    it "should redirect to goals path" do
      patch :close, id: @goal
      expect(response).to redirect_to flyboy_goals_path
    end
  end

  describe "#open" do
    before(:each) do
      @goal = FactoryGirl.create(:flyboy_goal, status: "closed")
    end

    it "should open goal" do
      patch :open, id: @goal
      expect(@goal.reload.status).to eq "open"
    end

    it "should redirect to goal path" do
      patch :open, id: @goal
      expect(response).to redirect_to flyboy_goal_path(@goal)
    end
  end

end
