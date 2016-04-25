FbotWeb::Sqlru.controllers :show do

  get :auto, :map => "/show/:fid/auto" do
    @fid = params[:fid]
    forum = Forums.first(siteid:6, fid: @fid)
    @updated = forum.bot_updated

    @posts = []

    render 'auto'
  end


  get :get_posts, :provides => :json do
    fid = 16
    forum = Forums.first(siteid:6, fid: fid)

    session[:last_posts] = Time.now-600 if session[:last_posts].nil?
    auto_last_viewed = session[:last_posts]
    #auto_last_viewed = Time.now-600

    @threads = Threads.filter('siteid=? and fid=? and updated > ?',6,fid, auto_last_viewed).to_hash(:tid, :title)

    posts = Posts.filter('siteid=?  and addeddate > ?',6 , auto_last_viewed).reverse_order(:addeddate).all

    p "post count #{posts.size}"
    session[:last_posts]  = forum.bot_updated if posts.size>0

    html = "last_posts #{session[:last_posts].strftime("%F %k:%M ") unless session[:last_posts].nil?} <br />"
    posts.each do |post|
      html << partial('show/post', :object => post)
    end
    { posts: html}.to_json
  end

  get :periodic, :map => "/show/:fid/periodic/:sec" do
    @fid = params[:fid]
    forum = Forums.first(siteid:6, fid: @fid)
    #p auto_last_viewed = DateTime.now.new_offset(3/24.0) - (7/3600.0)
    p sec = params[:sec].to_i
    if sec > 0
      @auto_last_viewed =Time.now-sec
    else
      @auto_last_viewed = session[:auto_last_viewed] #Time.now-300
    end
    session[:auto_last_viewed] = @updated = forum.bot_updated
    @threads = Threads.filter('siteid=? and fid=? and updated > ?',6 ,@fid, @auto_last_viewed).to_hash(:tid, :title)
    @posts = Posts.filter('siteid=? and addeddate > ?',6 ,@auto_last_viewed).reverse_order(:addeddate).all

    render 'posts_by_thread'
  end

end
