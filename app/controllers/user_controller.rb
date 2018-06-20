class UserController < ApplicationController
  def index
    @users = User.all
    @login_user = User.find(session[:user_id]) if session[:user_id]
  end

  def show
    @user = User.find(params[:id])
  end

  def new
  end

  def create
    user = User.new
    user.user_id = params[:user_id]
    user.password = params[:password]
    user.ip_address = request.ip
    user.save
    redirect_to "/user/#{user.id}"
  end
  
  def update
    user = User.find(params[:id])
    user.password = params[:password]
    user.save
    redirect_to "/user/#{user.id}"
  end
  
  def sign_in
    # 로그인 되어있는지 확인하고
    # 로그인 되어있으면 원래 페이지로 돌아가기`
    session.delete(:user_id)
  end
  
  def login
    # 실제로 유저가 입력한 ID와 PW를 바탕으로 
    # 실제로 로그인이 이루어지는 곳
    id = params[:user_id]
    pw = params[:password]
    user = User.find_by_user_id(id)
    # 해당 user_id로 가입한 유저가 있고, 패스워드도 일치하는 경우
    if !user.nil? and user.password.eql?(pw)
      # user가 있고, 비밀번호가 맞는 경우
      flash[:success] = "로그인 되었습니다."
      session[:user_id] = user.id #session[:id] 의 id부분은 파라미터이므로 아무거나 써도됨
      redirect_to '/users'
      
    else
      #user가 비어있거나, 비밀번호가 틀린경우
      flash[:error] = "등록된 유저가 아니거나 비밀번호가 틀립니다."
      redirect_to '/sign_in'
    end
  end

  def edit
    @user = User.find(params[:id])
  end
  
  def logout
    session.delete(:user_id)
    flash[:success] = "로그아웃에 성공했습니다."
    redirect_to '/users'
  end
end
