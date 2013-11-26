class AssignmentsController < ApplicationController
  before_filter :authenticated_as_admin, :except => [:index, :show]
  before_filter :authenticated_as_user, :only => [:index, :show]

  layout lambda { |controller|
    controller.current_user.try(:admin?) ? 'assignments' : 'session'
  }

  # GET /assignments
  def index
    @assignments = Assignment.for current_user, Course.main

    respond_to do |format|
      format.html  # index.html.erb
    end
  end

  # GET /assignments/1
  def show
    @assignment = Assignment.find params[:id]
    puts 'inside show'
    respond_to do |format|
      format.html  # show.html.erb
    end
  end
  
  # GET /assignments/1/dashboard
  def dashboard
    @assignment = Assignment.where(:id => params[:id]).
        includes(:deliverables, :submissions => :subject).first
    @recitation_sections = RecitationSection.all
        
    respond_to do |format|
      format.html  # dashboard.html.erb
    end
  end

  # GET /assignments/new
  def new
    @assignment = Assignment.new
    @assignment.course = Course.main
    @assignment.author = current_user
    
    respond_to do |format|
      format.html  # new.html.erb
    end    
  end

  # GET /assignments/1/edit
  def edit
    @assignment = Assignment.find params[:id]
  end
  
  # POST /assignments
  def create
    @assignment = Course.main.assignments.build assignment_params

    respond_to do |format|
      if @assignment.save
        format.html { redirect_to edit_assignment_path(@assignment) }
      else
        format.html { render :action => :new }
      end
    end
  end

  # PUT /assignments/1
  def update
    @assignment = Assignment.find params[:id]

    respond_to do |format|
      if @assignment.update_attributes assignment_params
        format.html do
          redirect_to dashboard_assignment_url(@assignment),
              notice: 'Assignment successfully updated.'
        end
      else
        format.html { render :action => :edit }
      end
    end
  end


  # DELETE /assignments/1
  def destroy
    @assignment = Assignment.find params[:id]
    @assignment.destroy

    respond_to do |format|
      format.html { redirect_to(assignments_url) }
      format.js do
        render :update do |page|
          add_site_status page, "Assignment #{@assignment.name} destroyed", true
          page.visual_effect :fade, "assignment_row_#{@assignment.id}"
        end
      end
    end
  end

  private
    # Permits updating and creating assignments.
    def assignment_params
      params[:assignment].permit :name, :deadline, :weight, :author, :author_id, :team_partition_id, :feedback_survey_id, :accepts_feedback, :deliverables_ready, :deliverables_attributes, :metrics_ready, :metrics_attributes
      # Note: feedback_survey_id and accepts_feedback are protected in the model but are allowed here
    end 
end
