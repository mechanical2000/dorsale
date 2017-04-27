require "rails_helper"

describe Dorsale::Flyboy::TasksController, type: :controller do
  routes { Dorsale::Engine.routes }

  let(:user) { create(:user) }

  before(:each) { sign_in(user) }

  let!(:task) {
    create(:flyboy_task, done: false)
  }

  let(:valid_attributes) {{
    :name => "New Task" ,
    :term => Time.zone.now.to_date,
  }}

  describe "#complete" do
    before(:each) do
      request.env["HTTP_REFERER"] = "where_i_came_from"
    end

    it "should mark the task as done" do
      patch :complete, params: {id: task.id}
      expect(task.reload.done).to be true
    end

    it "should set progress to 100" do
      patch :complete, params: {id: task.id}
      expect(task.reload.progress).to eq(100)
    end

    it "should add a task_comment" do
      count = task.comments.count
      patch :complete, params: {id: task.id}
      expect(task.reload.comments.count).to eq(count+1)
      expect(task.comments.last.progress).to eq(100)
    end

    it "should redirect to the referer page" do
      patch :complete, params: {id: task.id}
      expect(response).to redirect_to "where_i_came_from"
    end
  end

  describe "GET index" do
    context "when applying filter" do
      before do
        Dorsale::Flyboy::Task.destroy_all
        @task1 = create(:flyboy_task, done: true)
        @task2 = create(:flyboy_task, done: false)
      end

      it 'should display both when not filtered' do
        get :index
        expect(assigns(:tasks).to_a.sort).to eq [@task1, @task2].sort
      end

      it 'should filter by status closed' do
        cookies["filters"] = {'fb_status' => "closed"}.to_json
        get :index
        expect(assigns(:tasks).to_a).to eq [@task1]
      end

      it 'should filter by status opened' do
        cookies["filters"] = {'fb_status' => "opened"}.to_json
        get :index
        expect(assigns(:tasks).to_a).to eq [@task2]
      end
    end

    context "when sorting" do
      before do
        Dorsale::Flyboy::Task.destroy_all
        @corporation1 = create(:customer_vault_corporation, name: "Abc")
        @corporation2 = create(:customer_vault_corporation, name: "dEF")
        @corporation3 = create(:customer_vault_corporation, name: "xyz")

        @task1 = create(:flyboy_task, taskable: @corporation1, name: "Abc", progress: 100, term: "21/12/2012", reminder_type: "custom", reminder_date: "21/12/2012")
        @task2 = create(:flyboy_task, taskable: @corporation2, name: "dEF", progress: 0,   term: "23/12/2012", reminder_type: "custom", reminder_date: "23/12/2012")
        @task3 = create(:flyboy_task, taskable: @corporation3, name: "xyz", progress: 35,  term: "22/12/2012", reminder_type: "custom", reminder_date: "22/12/2012")
      end

      it "sorting by taskable asc" do
        get :index, params: {sort: "taskable"}
        expect(assigns(:tasks).to_a).to eq [@task1, @task2, @task3]
      end

      it "sorting by taskable desc" do
        get :index, params: {sort: "-taskable"}
        expect(assigns(:tasks).to_a).to eq [@task3, @task2, @task1]
      end

      it "sorting by name asc" do
        get :index, params: {sort: "name"}
        expect(assigns(:tasks).to_a).to eq [@task1, @task2, @task3]
      end

      it "sorting by name desc" do
        get :index, params: {sort: "-name"}
        expect(assigns(:tasks).to_a).to eq [@task3, @task2, @task1]
      end

      it "sorting by progress asc" do
        get :index, params: {sort: "progress"}
        expect(assigns(:tasks).to_a).to eq [@task2, @task3, @task1]
      end

      it "sorting by progress desc" do
        get :index, params: {sort: "-progress"}
        expect(assigns(:tasks).to_a).to eq [@task1, @task3, @task2]
      end

      it "sorting by term asc" do
        get :index, params: {sort: "term"}
        expect(assigns(:tasks).to_a).to eq [@task1, @task3, @task2]
      end

      it "sorting by term desc" do
        get :index, params: {sort: "-term"}
        expect(assigns(:tasks).to_a).to eq [@task2, @task3, @task1]
      end
    end
  end

  describe "GET show" do
    it "assigns the requested task as @task" do
      get :show, params: {:id => task.to_param}
      expect(assigns(:task)).to eq(task)
    end
  end

  describe "GET edit" do
    it "assigns the requested task as @task" do
      get :edit, params: {:id => task.to_param}
      expect(assigns(:task)).to eq(task)
    end
  end

  describe "POST create" do
    describe "with valid params" do

      it "creates a new Task" do
        expect {
          post :create, params: {:task => valid_attributes}
        }.to change(Dorsale::Flyboy::Task, :count).by(1)
      end

      it "assigns a newly created task as @task" do
        post :create, params: {:task => valid_attributes}
        expect(assigns(:task)).to be_a(Dorsale::Flyboy::Task)
        expect(assigns(:task)).to be_persisted
      end

      it "redirects to the created task" do
        post :create, params: {:task => valid_attributes}
        expect(response).to redirect_to Dorsale::Flyboy::Task.last_created
      end

      it "should send a mail to the owner" do
        owner = create(:user)
        ActionMailer::Base.deliveries.clear
        post :create, params: {:task => valid_attributes.merge(owner_id: owner.id)}
        expect(ActionMailer::Base.deliveries.count).to eq 1
        email = ActionMailer::Base.deliveries.last
        expect(email.to).to include owner.email
        expect(email.subject).to include "New Task"
        expect(email.body).to include @user.to_s
        expect(email.body).to include "http://"
      end

      it "should not send a mail if there is no owner" do
        ActionMailer::Base.deliveries.clear
        post :create, params: {:task => valid_attributes}
        expect(ActionMailer::Base.deliveries.count).to eq 0
      end

      it "should not send a mail if the author is the owner" do
        ActionMailer::Base.deliveries.clear
        post :create, params: {:task => valid_attributes}
        expect(ActionMailer::Base.deliveries.count).to eq 0
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "assigns the requested task as @task" do
        task = Dorsale::Flyboy::Task.create! valid_attributes
        patch :update, params: {:id => task.to_param, :task => valid_attributes}
        expect(assigns(:task)).to eq(task)
      end

      it "redirects to the task" do
        task = Dorsale::Flyboy::Task.create! valid_attributes
        patch :update, params: {:id => task.to_param, :task => valid_attributes}
        expect(response).to redirect_to(task)
      end
    end

    describe "with invalid params" do
      it "assigns the task as @task" do
        task = Dorsale::Flyboy::Task.create! valid_attributes

        patch :update, params: {
          :id   => task.to_param,
          :task => {:name => nil}
        }

        expect(assigns(:task)).to eq(task)
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested task" do
      task = create(:flyboy_task)
      expect {
        delete :destroy, params: {:id => task.to_param}
      }.to change(Dorsale::Flyboy::Task, :count).by(-1)
    end

    it "redirects to the tasks list" do
      task = create(:flyboy_task)
      delete :destroy, params: {:id => task.to_param}
      expect(response).to redirect_to(flyboy_tasks_path)
    end
  end

  describe "snooze" do
    it "should redirect to the task list to refresh it" do
      task = create(:flyboy_task, term: 3.days.ago)
      patch :snooze, params: {:id => task.to_param}
      expect(response).to redirect_to(task)
    end
  end

  describe "summary" do
    let(:summary_user) { create :user }

    before(:each) do
      Dorsale::Flyboy::Task.destroy_all
      sign_in summary_user

      Timecop.freeze "2016-03-09 15:00:00"
      @delayed_task        = create(:flyboy_task, term: Date.yesterday)           # tuesday
      @today_task          = create(:flyboy_task, term: Time.zone.now.to_date)    # thursday - today
      @tomorrow_task       = create(:flyboy_task, term: Date.tomorrow)            # wednesday
      @this_week_task      = create(:flyboy_task, term: Date.parse("2016-03-12")) # sunday
      @next_week_task      = create(:flyboy_task, term: Date.parse("2016-03-14")) # monday next week
      @next_next_week_task = create(:flyboy_task, term: Date.parse("2016-03-22")) # tuesday next next week
    end

    it "should not assign tasks when owner is an other person" do
      other_user = create(:user)
      Dorsale::Flyboy::Task.update_all(owner_id: other_user.id)

      Timecop.freeze "2016-03-09 15:00:00"
      controller.setup_tasks_summary
      expect(assigns(:delayed_tasks)).to        eq []
      expect(assigns(:today_tasks)).to          eq []
      expect(assigns(:tomorrow_tasks)).to       eq []
      expect(assigns(:this_week_tasks)).to      eq []
      expect(assigns(:next_week_tasks)).to      eq []
      expect(assigns(:next_next_week_tasks)).to eq []
    end

    it "should assign tasks when owner is nil" do
      Dorsale::Flyboy::Task.update_all(owner_id: nil)

      Timecop.freeze "2016-03-09 15:00:00"
      controller.setup_tasks_summary
      expect(assigns(:delayed_tasks)).to        eq [@delayed_task]
      expect(assigns(:today_tasks)).to          eq [@today_task]
      expect(assigns(:tomorrow_tasks)).to       eq [@tomorrow_task]
      expect(assigns(:this_week_tasks)).to      eq [@this_week_task]
      expect(assigns(:next_week_tasks)).to      eq [@next_week_task]
      expect(assigns(:next_next_week_tasks)).to eq [@next_next_week_task]
    end

    it "should assign tasks when owner is me" do
      Dorsale::Flyboy::Task.update_all(owner_id: summary_user.id)

      Timecop.freeze "2016-03-09 15:00:00"
      controller.setup_tasks_summary
      expect(assigns(:delayed_tasks)).to        eq [@delayed_task]
      expect(assigns(:today_tasks)).to          eq [@today_task]
      expect(assigns(:tomorrow_tasks)).to       eq [@tomorrow_task]
      expect(assigns(:this_week_tasks)).to      eq [@this_week_task]
      expect(assigns(:next_week_tasks)).to      eq [@next_week_task]
      expect(assigns(:next_next_week_tasks)).to eq [@next_next_week_task]
    end

  end # describe summary

end
