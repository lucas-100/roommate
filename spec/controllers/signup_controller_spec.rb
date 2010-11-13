
  describe SignupsController do 
    describe "#new" do 
      it "creates a new signup" do
        Signup.should_receive(:new)
      end
    end
  end