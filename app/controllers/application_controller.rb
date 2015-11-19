class ApplicationController < ActionController::Base
  authenticates_using_session

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include CourseFilters
  include UserFilters
  include RouteHelpers
end
