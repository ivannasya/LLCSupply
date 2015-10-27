require 'rails_helper'

RSpec::Matchers.define :allow do |*args|
  match do |permission|
    permission.allow?(*args).should eq(true)
  end
end

describe Permission, type: :model do 

  describe "as guest" do 
    subject { Permission.new(nil) }

    it { should allow("sessions", "new") }
    it { should allow("sessions", "create") }
    it { should allow("sessions", "destroy") }

    it { should_not allow("loads", "index") }
    it { should_not allow("loads", "show") }
    it { should_not allow("loads", "show") }
    it { should_not allow("loads", "new") }
    it { should_not allow("loads", "create") }
    it { should_not allow("loads", "edit") }
    it { should_not allow("loads", "update") }
    it { should_not allow("loads", "destroy") }

    it { should_not allow("orders", "index") }
    it { should_not allow("orders", "show") }
    it { should_not allow("orders", "create") }
    it { should_not allow("orders", "edit") }
    it { should_not allow("orders", "update") }
    it { should_not allow("orders", "destroy") }
    it { should_not allow("orders", "destroy_all") }
  end

  describe "as driver" do 
    let(:user) { create(:user) }
    let(:user_load) { build(:load, driver_id: user.id) }
    let(:other_load) { build(:load, driver_id: user.id+10) }
    subject { Permission.new(user) }

    it { should allow("sessions", "new") }
    it { should allow("sessions", "create") }
    it { should allow("sessions", "destroy") }

    it { should allow("loads", "index") }
    it { should allow("loads", "show", user_load) }
    it { should_not allow("loads", "show"), other_load }
    it { should_not allow("loads", "new") }
    it { should_not allow("loads", "create") }
    it { should_not allow("loads", "edit") }
    it { should_not allow("loads", "update") }
    it { should_not allow("loads", "destroy") }

    it { should_not allow("orders", "index") }
    it { should_not allow("orders", "show") }
    it { should_not allow("orders", "create") }
    it { should_not allow("orders", "edit") }
    it { should_not allow("orders", "update") }
    it { should_not allow("orders", "destroy") }
    it { should_not allow("orders", "destroy_all") }
  end

  describe "as dispatcher" do 
    subject { Permission.new(create(:dispatcher)) }

    it { should allow("sessions", "new") }
    it { should allow("sessions", "create") }
    it { should allow("sessions", "destroy") }
    
    it { should allow("loads", "index") }
    it { should allow("loads", "show") }
    it { should allow("loads", "new") }
    it { should allow("loads", "create") }
    it { should allow("loads", "edit") }
    it { should allow("loads", "update") }
    it { should allow("loads", "destroy") }

    it { should allow("orders", "index") }
    it { should allow("orders", "show") }
    it { should allow("orders", "create") }
    it { should allow("orders", "edit") }
    it { should allow("orders", "update") }
    it { should allow("orders", "destroy") }
    it { should allow("orders", "destroy_all") }
  end
end