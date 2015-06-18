require "spec_helper"

describe Dorsale::Flyboy::TasksController, type: :controller do
  routes { Dorsale::Engine.routes }

  let!(:task) {
    FactoryGirl.create(:flyboy_task, done: false)
  }

  let!(:task2) {
    FactoryGirl.create(:flyboy_task, taskable: task.taskable, done: true)
  }

  let(:valid_attributes) {
    { name: "New Task" , taskable_id: task.taskable.id, taskable_type: task.taskable.class, reminder: Date.today, term: Date.today}
  }

  describe "#complete" do
    before(:each) do
      request.env["HTTP_REFERER"] = "where_i_came_from"
    end

    it "should mark the task as done" do
      patch :complete, {id: task.id}
      expect(task.reload.done).to be true
    end

    it "should set progress to 100" do
      patch :complete, {id: task.id}
      expect(task.reload.progress).to eq(100)
    end

    it "should add a task_comment" do
      count = task.comments.count
      patch :complete, {id: task.id}
      expect(task.reload.comments.count).to eq(count+1)
      expect(task.comments.last.progress).to eq(100)
    end

    it "should redirect to the referer page" do
      patch :complete, {id: task.id}
      expect(response).to redirect_to "where_i_came_from"
    end
  end

  describe "GET index" do
    it "assigns all tasks as @tasks" do
      get :index, {}
      expect(assigns(:tasks).sort).to eq Dorsale::Flyboy::Task.all.sort
    end

    context "when applying filter" do
      before do
        Dorsale::Flyboy::Task.destroy_all
        @task1 = FactoryGirl.create(:flyboy_task, done: true)
        @task2 = FactoryGirl.create(:flyboy_task, done: false)
      end

      it 'should display both when not filtered' do
        get :index
        expect(assigns(:tasks)).to eq [@task1, @task2]
      end

      it 'should filter by status closed' do
        Dorsale::Flyboy::SmallData::FilterForTasks.new(request.cookies).store({'status' => "closed"})
        get :index
        expect(assigns(:tasks)).to eq [@task1]
      end

      it 'should filter by status opened' do
        Dorsale::Flyboy::SmallData::FilterForTasks.new(request.cookies).store({'status' => "opened"})
        get :index
        expect(assigns(:tasks)).to eq [@task2]
      end
    end

    context "when sorting" do
      before do
        Dorsale::Flyboy::Goal.destroy_all
        Dorsale::Flyboy::Task.destroy_all
        @goal1 = FactoryGirl.create(:flyboy_goal, name: "Abc")
        @goal2 = FactoryGirl.create(:flyboy_goal, name: "dEF")
        @goal3 = FactoryGirl.create(:flyboy_goal, name: "xyz")

        @task1 = FactoryGirl.create(:flyboy_task, taskable: @goal1, name: "Abc", progress: 100, term: "21/12/2012", reminder: "21/12/2012")
        @task2 = FactoryGirl.create(:flyboy_task, taskable: @goal2, name: "dEF", progress: 0,   term: "23/12/2012", reminder: "23/12/2012")
        @task3 = FactoryGirl.create(:flyboy_task, taskable: @goal3, name: "xyz", progress: 35,  term: "22/12/2012", reminder: "22/12/2012")
      end

      it "sorting by taskable asc" do
        get :index, sort: "taskable"
        expect(assigns(:tasks).to_a).to eq [@task1, @task2, @task3]
      end

      it "sorting by taskable desc" do
        get :index, sort: "-taskable"
        expect(assigns(:tasks).to_a).to eq [@task3, @task2, @task1]
      end

      it "sorting by name asc" do
        get :index, sort: "name"
        expect(assigns(:tasks).to_a).to eq [@task1, @task2, @task3]
      end

      it "sorting by name desc" do
        get :index, sort: "-name"
        expect(assigns(:tasks).to_a).to eq [@task3, @task2, @task1]
      end

      it "sorting by progress asc" do
        get :index, sort: "progress"
        expect(assigns(:tasks).to_a).to eq [@task2, @task3, @task1]
      end

      it "sorting by progress desc" do
        get :index, sort: "-progress"
        expect(assigns(:tasks).to_a).to eq [@task1, @task3, @task2]
      end

      it "sorting by term asc" do
        get :index, sort: "term"
        expect(assigns(:tasks).to_a).to eq [@task1, @task3, @task2]
      end

      it "sorting by term desc" do
        get :index, sort: "-term"
        expect(assigns(:tasks).to_a).to eq [@task2, @task3, @task1]
      end
    end
  end

  describe "GET show" do
    it "assigns the requested task as @task" do
      get :show, {:id => task.to_param}
      expect(assigns(:task)).to eq(task)
    end
  end

  describe "GET new" do
    it "assigns a new task as @task" do
      get :new, {:goal_id => task.taskable.id}
      expect(assigns(:task)).to be_a_new(Dorsale::Flyboy::Task)
    end
  end

  describe "GET edit" do
    it "assigns the requested task as @task" do
      get :edit, {:id => task.to_param}
      expect(assigns(:task)).to eq(task)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Task" do
        expect {
          post :create, {:task => valid_attributes}
        }.to change(Dorsale::Flyboy::Task, :count).by(1)
      end

      it "assigns a newly created task as @task" do
        post :create, {:task => valid_attributes}
        expect(assigns(:task)).to be_a(Dorsale::Flyboy::Task)
        expect(assigns(:task)).to be_persisted
      end

      it "redirects to the created task" do
        post :create, {:task => valid_attributes}
        expect(response).to redirect_to Dorsale::Flyboy::Task.order("id ASC").last
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved task as @task" do
        post :create, task: {name: nil, taskable_id: task.taskable.id, taskable_type: task.taskable.class}
        expect(assigns(:task)).to be_a_new(Dorsale::Flyboy::Task)
      end
    end

  end

  describe "PUT update" do
    describe "with valid params" do
      it "assigns the requested task as @task" do
        task = Dorsale::Flyboy::Task.create! valid_attributes
        patch :update, {:id => task.to_param, :task => valid_attributes}
        expect(assigns(:task)).to eq(task)
      end

      it "redirects to the task" do
        task = Dorsale::Flyboy::Task.create! valid_attributes
        patch :update, {:id => task.to_param, :task => valid_attributes}
        expect(response).to redirect_to(task)
      end
    end

    describe "with invalid params" do
      it "assigns the task as @task" do
        task = Dorsale::Flyboy::Task.create! valid_attributes

        patch :update, {
          :id   => task.to_param,
          :task => {:name => nil}
        }

        expect(assigns(:task)).to eq(task)
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested task" do
      task = Dorsale::Flyboy::Task.create! valid_attributes
      expect {
        delete :destroy, {:id => task.to_param}
      }.to change(Dorsale::Flyboy::Task, :count).by(-1)
    end

    it "redirects to the tasks list" do
      task = Dorsale::Flyboy::Task.create! valid_attributes
      delete :destroy, {:id => task.to_param}
      expect(response).to redirect_to(flyboy_tasks_path)
    end
  end

  describe "snooze" do
    it "should redirect to the task list to refresh it" do
      task = Dorsale::Flyboy::Task.create! valid_attributes
      patch :snooze, {:id => task.to_param}
      expect(response).to redirect_to(flyboy_tasks_path)
    end
  end

end
