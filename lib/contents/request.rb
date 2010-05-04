# :nodoc: namespace
module Contents


# An item that shows up in the Requests widget.
class Request
  # The User who posted this request.
  attr_accessor :author
  # A (hopefully) short summary of the request.
  attr_accessor :headline
  # The contents of the request.
  attr_accessor :contents
  # Array of actions for responding to the request.
  #
  # Each action is a pair which should respond to the following methods:
  #     first:: the user-visible name for the action 
  #     last::  the link target for the action
  attr_accessor :actions
  
  # The requests for a user.
  def self.for(user, options = {})
    requests = []
    return requests unless user
    
    unless user.profile
      request = Request.new :author => User.first,
          :headline => 'wants you to create a profile',
          :contents => 'You need a profile to have your homework graded.',
          :actions => [
            ['Create Profile', [:url_for, user]]
          ]
      requests << request
    end
    unless user.registration
      request = Request.new :author => User.first,
          :headline => 'wants you to register for the course',
          :contents => 'You must register to get a recitation assignment ' +
                       'and have your homework graded .',
          :actions => [
            ['Answer Survey', [:url_for, user]]
          ]
      requests << request
    end
    requests
  end
  
  # Creates a new request with the given attributes.
  def initialize(attributes = {})
    attributes.each { |name, value| send :"#{name}=", value }
  end  
end  # class Contents::Request

end  # namespace Contents