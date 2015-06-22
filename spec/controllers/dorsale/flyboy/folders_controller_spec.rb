describe Dorsale::Flyboy::FoldersController, type: :controller do
  routes { Dorsale::Engine.routes }

  let(:folder){
    create(:flyboy_folder)
  }

  describe '#index' do
    context 'when applying filter' do
      before(:each) do
        Dorsale::Flyboy::Folder.destroy_all
        @folder1 = create(:flyboy_folder, status: "open")
        @folder2 = create(:flyboy_folder, status: "closed")
      end

      it 'should display both when not filtered' do
        get :index
        expect(assigns(:folders)).to eq [@folder2, @folder1]
      end

      it 'should filter by status closed' do
        Dorsale::Flyboy::SmallData::FilterForFolders.new(request.cookies)
          .store(status: "closed")

        get :index
        expect(assigns(:folders)).to eq [@folder2]
      end

      it 'should filter by status open' do
        Dorsale::Flyboy::SmallData::FilterForFolders.new(request.cookies)
          .store(status: "open")

        get :index
        expect(assigns(:folders)).to eq [@folder1]
      end
    end

    context "when sorting" do
      before do
        Dorsale::Flyboy::Folder.destroy_all
        @folder1 = create(:flyboy_folder, name: "Abc", progress: 100, status: "open")
        @folder2 = create(:flyboy_folder, name: "dEF", progress: 0,   status: "closed")
        @folder3 = create(:flyboy_folder, name: "xyz", progress: 35,  status: "closed")
      end

      it "sorting by name asc" do
        get :index, sort: "name"
        expect(assigns(:folders).to_a).to eq [@folder1, @folder2, @folder3]
      end

      it "sorting by name desc" do
        get :index, sort: "-name"
        expect(assigns(:folders).to_a).to eq [@folder3, @folder2, @folder1]
      end

      it "sorting by progress asc" do
        get :index, sort: "progress"
        expect(assigns(:folders).to_a).to eq [@folder2, @folder3, @folder1]
      end

      it "sorting by progress desc" do
        get :index, sort: "-progress"
        expect(assigns(:folders).to_a).to eq [@folder1, @folder3, @folder2]
      end

      it "sorting by status asc" do
        get :index, sort: "status"
        expect(assigns(:folders).to_a).to eq [@folder2, @folder3, @folder1]
      end

      it "sorting by status desc" do
        get :index, sort: "-status"
        expect(assigns(:folders).to_a).to eq [@folder1, @folder2, @folder3]
      end
    end
  end

  describe "#show" do
    context "when sorting" do
      before do
        Dorsale::Flyboy::Folder.destroy_all
        Dorsale::Flyboy::Task.destroy_all

        @folder = create(:flyboy_folder)

        @task1 = create(:flyboy_task,
          taskable: @folder, name: "Abc", progress: 100, term: "21/12/2012", reminder: "21/12/2012")
        @task2 = create(:flyboy_task,
          taskable: @folder, name: "dEF", progress: 0,   term: "23/12/2012", reminder: "23/12/2012")
        @task3 = create(:flyboy_task,
          taskable: @folder, name: "xyz", progress: 35,  term: "22/12/2012", reminder: "22/12/2012")
      end

      it "sorting by name asc" do
        get :show, id: @folder, sort: "name"
        expect(assigns(:tasks).to_a).to eq [@task1, @task2, @task3]
      end

      it "sorting by name desc" do
        get :show, id: @folder, sort: "-name"
        expect(assigns(:tasks).to_a).to eq [@task3, @task2, @task1]
      end

      it "sorting by progress asc" do
        get :show, id: @folder, sort: "progress"
        expect(assigns(:tasks).to_a).to eq [@task2, @task3, @task1]
      end

      it "sorting by progress desc" do
        get :show, id: @folder, sort: "-progress"
        expect(assigns(:tasks).to_a).to eq [@task1, @task3, @task2]
      end

      it "sorting by term asc" do
        get :show, id: @folder, sort: "term"
        expect(assigns(:tasks).to_a).to eq [@task1, @task3, @task2]
      end

      it "sorting by term desc" do
        get :show, id: @folder, sort: "-term"
        expect(assigns(:tasks).to_a).to eq [@task2, @task3, @task1]
      end
    end
  end

  describe "#close" do
    before(:each) do
      @folder = create(:flyboy_folder, status: "open")
    end

    it "should close folder" do
      patch :close, id: @folder
      expect(@folder.reload.status).to eq "closed"
    end

    it "should redirect to folders path" do
      patch :close, id: @folder
      expect(response).to redirect_to flyboy_folders_path
    end
  end

  describe "#open" do
    before(:each) do
      @folder = create(:flyboy_folder, status: "closed")
    end

    it "should open folder" do
      patch :open, id: @folder
      expect(@folder.reload.status).to eq "open"
    end

    it "should redirect to folder path" do
      patch :open, id: @folder
      expect(response).to redirect_to flyboy_folder_path(@folder)
    end
  end

end
