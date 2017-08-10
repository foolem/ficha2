class GroupsController < ApplicationController
  before_action :set_group, only: [:show, :edit, :update, :destroy]
  before_action :bar_define

  # GET /groups
  # GET /groups.json
  def index
    @page = params[:page].to_i

    if(params[:q].blank? and !session[:group_search].blank?)
      query = session[:group_search]
    else
      query = params[:q]
      session[:group_search] = params[:q]
    end

    length_verify()
    @q = Group.ransack(query)
    @groups = @q.result.order(name: :asc)
    @elements = @groups.length

    @page = pages_verify(@page, @elements)

    @groups = @groups.paginate(:per_page => @length, :page => @page)

  end

  # GET /groups/1
  # GET /groups/1.json
  def show
  end

  def search
    puts "oi"
    index
    render :index
  end

def length_verify
  @length = 13
  if user_signed_in? and (current_user.admin? or current_user.secretary?)
    @length = 10
  end
end


  # GET /groups/new
  def new
    @group = Group.new
  end

  # GET /groups/1/edit
  def edit
  end

  # POST /groups
  # POST /groups.json
  def create
    @group = Group.new(group_params)

    respond_to do |format|
      if @group.save
        format.html { redirect_to @group, notice: 'Group was successfully created.' }
        format.json { render :show, status: :created, location: @group }
      else
        format.html { render :new }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /groups/1
  # PATCH/PUT /groups/1.json
  def update
    respond_to do |format|
      if @group.update(group_params)
        format.html { redirect_to @group, notice: 'Group was successfully updated.' }
        format.json { render :show, status: :ok, location: @group }
      else
        format.html { render :edit }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1
  # DELETE /groups/1.json
  def destroy
    @group.destroy
    respond_to do |format|
      format.html { redirect_to groups_url, notice: 'Group was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def pages_verify(page, lines)
    pages = pages_count(lines)
    if(page < 1)
      page = 1
    elsif page > pages
      page = pages
    end
    page
  end

  def pages_count(num)
    result = num/@length
    resto = num.remainder @length
    if( resto > 0)
      result=result+1
    end
    result
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @group = Group.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def group_params
      params.require(:group).permit(:name, :matter_id, :semester_id)
    end


    def bar_define
      session[:page] = "group"
    end
end
