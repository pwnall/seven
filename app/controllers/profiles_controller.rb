class ProfilesController < ApplicationController
  before_filter :authenticated_as_user,
      :only => [:new, :create, :edit, :show, :update, :websis_lookup]
  before_filter :authenticated_as_admin, :only => [:index, :destroy]

  # GET /profiles
  # GET /profiles.xml
  def index
    @profiles = Profile.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @profiles }
    end
  end
  
  # GET /profiles/1
  # GET /profiles/1.xml
  def show
    @profile = Profile.find(params[:id])

    @recitation_section_options = profile_recitation_section_options @profile.recitation_section_id

    respond_to do |format|
      format.html
      format.xml  { render :xml => @profile }
    end
  end

  def new_edit
    if @profile.new_record?
      @profile.athena_username = @s_user.email.split('@')[0]
    else
      if !@profile.editable_by_user? @s_user
        notice[:error] = 'That is not yours to play with! Your attempt has been logged.'
        redirect_to root_url
        return
      end
    end

    respond_to do |format|
      format.html { render :action => :new_edit }
      format.js   { render :action => :edit }
      format.xml  { render :xml => @profile }
    end    
  end
  private :new_edit
  
  # GET /profiles/new
  # GET /profiles/new.xml
  def new
    @profile = Profile.new
    new_edit
  end

  # GET /profiles/1/edit
  def edit
    @profile = Profile.find(params[:id])
    new_edit
  end
  
  def create_update
    if !@profile.editable_by_user? @s_user
      # do not allow random record updates
      notice[:error] = 'That is not yours to play with! Your attempt has been logged.'
      redirect_to root_path
      return
    end
    
    if @profile.new_record?
      success = @profile.save
    else
      success = @profile.update_attributes(params[:profile])
    end
    
    respond_to do |format|
      if success
        flash[:notice] = "Profile successfully #{@profile.new_record? ? 'created' : 'updated'}."
        format.html { redirect_to @profile.user }
        format.js   { render :action => :create_update }
        format.xml do
          if @profile.new_record?
            render :xml => @profile, :status => :created, :location => @profile
          else
            head :ok
          end  
        end  
      else
        format.html { render :action => :new_edit }
        format.js   { render :action => :edit }
        format.xml  { render :xml => @profile.errors, :status => :unprocessable_entity }
      end
    end    
  end
  private :create_update

  # POST /profiles
  # POST /profiles.xml
  def create
    @profile = Profile.new(params[:profile])
    create_update
  end

  # PUT /profiles/1
  # PUT /profiles/1.xml
  def update
    @profile = Profile.find(params[:id])
    create_update
  end
  
  # DELETE /profiles/1
  # DELETE /profiles/1.xml
  def destroy
    @profile = Profile.find(params[:id])
    @profile.destroy

    respond_to do |format|
      format.html { redirect_to(profiles_url) }
      format.xml  { head :ok }
    end
  end
  
  # XHR GET /profiles/websis_lookup?athena_id=costan
  def websis_lookup
    @athena_username = params[:athena_id]
    @athena_info = MitStalker.from_user_name @athena_username
    respond_to do |format|
      format.js # websis_lookup.js.rjs
    end
  end
end
