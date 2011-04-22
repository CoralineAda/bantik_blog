class ApplicationController < ActionController::Base
  protect_from_forgery
  ActionView::Base.default_form_builder = ScaffoldLogic::FormBuilder
end
