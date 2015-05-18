require 'helper'
require 'action_controller'

class BaseController < ActionController::Base

  def index
    render nil
  end
  
end

class ParamsProtectedController < BaseController
  params_protected :framework
end

class ParamsProtectedControllerTest < ActionController::TestCase
  
  test "should remove protected parameter" do
    with_routing do |set|
      set.draw { match ':controller/:action' }
      p @request.inspect
      get :index, {:user => 'slawosz',:framework => 'rails',:lang => 'ruby'}

      assert_equal ({:user => 'slawosz',:lang => 'ruby'}), @controller.params
    end
  end
end

class ParamsAccessiblecontroller < BaseController
  params_accessible :framework
end

class ParamsAccessiblecontrollerTest < ActiveSupport::TestCase
  
  test "should remove protected parameter" do
    request = ActionDispatch::TestRequestWithParams.new
    request.params = {:user => 'slawosz',:framework => 'rails',:lang => 'ruby'}

    controller = ParamsAccessiblecontroller.new
    controller.dispatch('index', request)

    assert_equal ({:framework => 'rails'}), controller.params
  end
end
