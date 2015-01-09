class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  helper_method :finder

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
    def finder(genre,value)

        require 'net/https'
        require 'json'

        rand = 1 + rand(999)
        index = rand.to_s

        # http://developer.echonest.com/api/v4/song/search?api_key=LR9PG9SQCWRICWN8Z&format=json&results=10&style=jazz
        uri = URI('http://developer.echonest.com/api/v4/song/search?api_key=LR9PG9SQCWRICWN8Z&format=json&results=1&start='+index+'&style='+genre)
        req = Net::HTTP::Get.new(uri)

        res = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => uri.scheme == 'https') {|http|
          http.request(req)
        }

        code = res.code
        res = res.body

        if code == "200" then
          if value == "artist" then
            artist = JSON.parse(res)['response']['songs'].to_json(:only => ['artist_name'])[17..-4]
            # song = JSON.parse(res)['response']['songs']
          elsif value == "title" then
            title = JSON.parse(res)['response']['songs'].to_json(:only => ['title'])[11..-4]
          end 
        else
          return "I didn't recognize that genre... Care to try again?"
        end
    end
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name,:genre)
    end
end
