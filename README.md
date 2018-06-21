# 18.06.20

## Cloud9

CRUD 코드 다 외우도록! / 



#### daum_cafe_app  만들기

- controller ( 이름 : board) / model ( 이름 : post) 에서 method 사용하기 + 필터
- Session(Login)
- Relation(1:n) - m:n 은 가능하면 구현.
  - 내 유저가 여러개의 글을 쓸 수 있도록
  - 

```ruby
# 전체 흐름도

$ cd
$ rails _5.0.6_ new daum_cafe_app
$ cd daum_cafe_app
$ rails g model post
# 20180620003908_create_posts.rb  # 수정
$ rails g controller board index show new edit

# routes.rb 수정
# board_controller 수정

view 파일 index -> show -> new -> edit

서버 생성 오류 pending 오류

rake db:migrate

실행

+ 간단과제

```

##### 20180620003908_create_posts.rb

```ruby
class CreatePosts < ActiveRecord::Migration[5.0]
  def change
    create_table :posts do |t|

      t.string :title
      t.text   :contents
      t.timestamps
    end
  end
end
```

rails g controller board index show new edit



routes.rb + put과 patch의 차이

```ruby
Rails.application.routes.draw do
    root 'board#index'
    get '/boards'           => 'board#index' # 전체목록 보기
    get '/board/new'        => 'board#new'      # :id 가 먼저오면 /new 를 파라미터로 보고 오류날 수 있음.
    get '/board/:id'        => 'board#show'     # board의 글 하나로 오면 show 액션으로 가고
    post '/boards'          => 'board#create'   #
    get '/board/:id/edit'   => 'board#edit' # 수정하기

    put '/board/:id'        => 'board#update'  # 둘다 수정이지만, put 은 전체 수정
    patch '/board/:id'      => 'board#update'   # patch는 부분 수정 
    # 똑같은 모양이지만 요청 방식이 다름.
    delete '/board/:id'     => 'board#destroy'
    # 가장 restful 하게 짜여진 라우팅.
    # '/board/:id' 가 get / put / patch 
end
```



board_controller.rb

```ruby

```





view 파일 index -> show -> new -> edit



서버 생성 오류 pending 오류



rake db:migrate











------

간단과제(CRUD 두 개 만들기)

- BoardController는 완성함.

- User 모델과 UserController CRUD
  - columns: id, password, ip_address
  - show에서는 id와 ip_address만 보이게 (pw 제외)
  - delete 없음
  - /user/new -> /sign_up
- Cafe 모델과 CafeController CRUD
  - columns: title, description
- View 까지
  - bootstrap4

```ruby
rails g model user
rails g controller user
```



### routes.rb

```ruby
Rails.application.routes.draw do
    root 'board#index'
    get '/boards' => 'board#index'
    get '/board/new' => 'board#new'
    get '/board/:id' => 'board#show'
    post '/boards' => 'board#create'
    get '/board/:id/edit' => 'board#edit'
    put '/board/:id' => 'board#update'
    patch '/board/:id' => 'board#update'
    delete '/board/:id' => 'board#destroy'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
    get '/users' => 'user#index'
    get '/sign_up' => 'user#new'
    get '/user/:id' => 'user#show'
    post '/users' => 'user#create'
    get '/user/:id/edit' => 'user#edit'
    put '/user/:id' => 'user#update'
    patch '/user/:id' => 'user#update'
end
```



### model(user)

```ruby
class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :user_id
      t.string :password
      t.string :ip_address
      t.timestamps
    end
  end
end
```



### user_controller.rb

```ruby
class UserController < ApplicationController
  def index
    @users = User.all
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

  def edit
    @user = User.find(params[:id])
  end
end
```



### index.html.erb

```ruby
<div>
    <% @posts.each do |post| %>
    <a href = "/board/<%= post.id%>"><%= post.title %></a>
    <%end%>
</div>
<%= link_to "새글쓰기", "/board/new"%>
<%= link_to "회원가입하기", "/user/new"%>
```



### new.html.erb

```ruby
<div>
    <% @posts.each do |post| %>
    <a href = "/board/<%= post.id%>"><%= post.title %></a>
    <%end%>
</div>
<%= link_to "새글쓰기", "/board/new"%>
<%= link_to "회원가입하기", "/user/new"%>
```



### 

### 쿠키와 세션

쿠키는 정보를 client가 갖고있음		

세션에서 server는 client의 session-id를 통해 정보의 위치를 저장









find_by_user_id(params[:user_id])  user_id로 찾을땐 find_by_user_id!



session[:user_id] = user.id 이 사람의 고유번호, 몇번째로 가입했는지를 넣어둠

session은 계속 정보를 유지할 수 잇는 방안임

session.delete(:user_id) : 로그아웃 할 때, session을 지움으로서 해결함

# 에러

```ruby
@post / post 구별 할것!!!

# 완성된 코드를 순서대로 차근차근 곱 씹어볼것 
```



