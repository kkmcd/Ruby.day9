# Day10 (180621)



## 검색

- 사용자 혹은 개발자가 원하는 데이터를 찾고자 할 때 사용.

- 검색방법

  - 일치
  - 포함
  - 범위
  - ...

- 우리가 그 동안에 검색했던 방법은? **일치**. table에 있는 id와 일치하는 것. 이 컬럼은 인덱싱이 되어 있기 때문에 검색 속도가 매우 빠르고 항상 고유한 값을 가진다.

  - Table에 있는 id로 검색을 할 때에는 Model.find(id)를 사용한다.

- Table에 있는 id값으로 해결하지 못하는 경우?

  - 사용자가 입력했던 값으로 검색해야 하는 경우(`user_name`)
  - 게시글을 검색하는데, 작성자, 제목으로 검색할 경우
  - Table에 있는 다른 컬럼으로 검색할 경우에는 `Model.find_by_컬럼명(value)`, `Model.find_by(컬럼명: value)`
  - `find_by`의 특징: 1개만 검색됨. 일치하는 값이 없는 경우 `nil`값이 됨.
  - 1개만 검색된다는 것은 결과값에 limit가 1인것을 보고 1개만 출력함을 알 수 있음.

- 추가적인 검색방법: `Model.where(컬럼명: 검색어값)`

  - `User.where(user_name: "Hello")`
  - `where`의 특징: 검색결과가 여러개 나옴. 위에서 제시한 방법들은 한 개의 결과만을 리턴함.
  - 결과값이 배열형태. 일치하는 값이 없는 경우에도 **빈 배열**이 나옴.
  - 주의해야 할 사항은, 배열형태이지 배열은 아님. 하지만, each 등의 배열에 적용되는 함수를 그대로 사용할 수 있음.
  - 결과값이 비어있는 경우에 `nil?`메소드의 결과값이 `false`로 나옴.

- 포함?

  - 텍스트가 특정 단어/문장을 포함하고 있는가?
  - `Model.where("컬럼명 LIKE ?","%#{value}%")`
  - 왜 `Model.where("컬럼명 LIKE '%#{value}%'")`라고 안쓰고 위의 방법처럼 사용할까?
  - 위의 방법이 되기는 하지만 쓰면 안됨.
    - SQL Injection(해킹) 이 발생할 수 있음.
  - `Full text search` 방식으로 더 나은 검색을 할 수 있음.

- where에서 nil을 검색하는 방법

  - length의 사용
  - u = User.where(user_id: "zxcv") 
    - u.empty? 로 검색

- set_post 함수 선언

  ```ruby
  def set_post
    @post = Post.find(params[:id])
  end
  ```

  ```ruby
    def update
      set_post
      #@post= Post.find(params[:id])
      @post.title = params[:title]
      @post.contents = params[:contents]
      @post.save
      redirect_to "/board/#{post.id}"
    end
  ```

  - 위와같이 사용하는게 어떤점이 좋은가?

    - filter의 사용!!!

      - 함수 사용에 대한 요청이 들어왔을 때만 사용가능하게 함.

        ```ruby
        before_action :set_post, only: [:show, :edit, :update, :destroy]
        ```

        ```ruby
        before_action :set_post, except: [:index, :new, :create] #except에 있는거 빼고 set_post를 설정해라
        ```

        ```ruby
          def show
          end
        ```

        ```ruby
          def update
            @post.title = params[:title]
            @post.contents = params[:contents]
            @post.save
            redirect_to "/board/#{post.id}"
          end
        ```

      - before_action을 통해 위와같이 함수선언을 간단하게 할 수 있다!

- ! : Bang으로 읽음. 내가 의도하지않은 액션이 발생할 때 쓰는 메소드. 



#### application_controller.rb

```ruby
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :user_signed_in? # ?는 true or false 반환하게함.
  # 현재 로그인 된 상태니?
  def user_signed_in?
    #session[:user_id].nil?  #아래는 nil과 반대
    session[:user_id].present?  
  #else
    #redirect_to '/sign_in'
    #end
  #session[:user_id].present?
  end
  
  #로그인 되어있지 않으면 로그인하는 페이지로 이동시켜라
  def authenticate_user!
    unless user_signed_in?
      redirect_to '/sign_in'
    end
  end
  
  # 현재 로그인 된 사람이 누구니?
  # 로그인 되어 있지 않으면 로그인하는 페이지로 이동 시켜줘
  def current_user
    # 현재 로그인됐니?
    if user_signed_in?
        # 됐다면 로그인 한 사람은 누구니?
        @current_user = User.find(session[:user_id])
    end
  end
end
```

- helper method와 view helper, form helper는 개념이 서로 조금 다름



#### board_controller.rb

```ruby
class BoardController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  #before_action :set_post, except: [:index, :new, :create] #except에 있는거 빼고 set_post를 설정해라
  # 로그인 된 상태에서만 접속할 수 있는 페이지는?
  # index, show만 로그인 하지 않은 상태에서 볼 수 있게
  # 나머지는 반드시 로그인이 필요하게
  before_action :authenticate_user!, except: [:index, :show]
  def index
    @posts = Post.all
    @current_user = current_user
  end

  def show
    #@post = Post.find(params[:id])
    #set_post
    #puts @post
  end

  def new
 
  end

  def create
    post = Post.new
    post.title = params[:title]
    post.contents = params[:contents]
    post.user_id = current_user.id
    post.save
    # post를 등록할 때 이 글을 작성한 사람은
    # 현재 로그인 되어있는 유저이다.
    
    redirect_to "/board/#{post.id}"
  end

  def edit
     #set_post
  end
  
  def update
    #set_post
    #@post= Post.find(params[:id])
    @post.title = params[:title]
    @post.contents = params[:contents]
    @post.save
    redirect_to "/board/#{post.id}"
  end
  
  def destroy
    #set_post
    #@post=Post.find(params[:id])
    @post.destroy
    redirect_to '/boards'
  end

def set_post
  @post = Post.find(params[:id])
end
    
end
```



#### views > board > index.html.erb

```ruby
<% unless user_signed_in? %>
<!-- 로그인 되지 않은 상태 -->
<%=link_to '로그인', '/sign_in' %>
<% else %>
<!-- 로그인 된 상태 -->
<p>현재 로그인 된 유저:<%=@current_user.user_id %></p>
<%= link_to '로그아웃','/logout'%>
<% end %>
<div>
    <% @posts.each do |post| %>
    <a href = "/board/<%= post.id%>"><%= post.title %></a>
    <%end%>
</div>
<%= link_to "새글쓰기", "/board/new"%>
<%= link_to "회원가입하기", "/sign_up"%>
```

```ruby
<% unless user_signed_in? %>
```

- controller view... 사이클은 순서대로 돌기때문에 컨트롤단을 한 번 지나가면 view에서 다시 controller부분으로 돌아갈 수 없음. 따라서 정의되지 않은 함수라고 뜸

- application_controller에 helper_method :user_signed_in? 를 선언함으로서 위의 문제를 해결할 수있음. 즉, 예외를 만들어준다는 말임.

#### views > user > show.html.erb

```ruby
<h2><%= @user.user_id%></h2>
<hr>
<p>LAST LOGIN AT: <%= @user.ip_address %></p>
<p>이 유저가 작성한 글</p>
<% @user.posts.each do |post| %>
    <%= link_to post.title, "/board/#{post.id}" %><br>
<% end %>
```



### relation (1:n relation 구성)

#### models > post.rb

```ruby
class Post < ApplicationRecord
    belongs_to :user
end
```

#### models > user.rb

```ruby
class User < ApplicationRecord
    has_many :posts
end
```

- model > post.rb & user.rb에 각각 한줄코드를 입력함으로서 간단하게 만들 수 있다

