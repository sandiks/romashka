FbotWeb::Sqlru.controllers :stat do

  get :users do
    #LogHelper.log_req(request)

    from = DateTime.now.new_offset(3/24.0).beginning_of_day
    today_posts = Posts.filter('siteid=? and addeddate > ?',6,from)
    .order(:addeddate)
    .select(:addeduid, :addedby, :addeddate, :body, :tid).all

    @threads = Threads.filter('siteid=? and updated > ?',6,from).to_hash(:tid, :title)

    @posts = [ today_posts ]
    @dates = [from.to_date]

    render 'users_for_week'
  end


  get :user_posts, :with => [:id, :date] do

    #LogHelper.log_req(request)

    from = DateTime.parse(params[:date])

    @threads = Threads.filter('siteid=? and  updated > ?',6,from).to_hash(:tid, :title)
    @posts = Posts.filter('siteid=? and addeddate > ? and addeddate < ?',6, from, from +1)
    .where(:addeduid => params[:id])
    .order(:addeddate)
    .all

    render 'user_posts'
  end

  get :show_recent_posts do

    #LogHelper.log_req(request)

    from = DateTime.now.new_offset(3/24.0) - 2/24.0

    @threads = Threads.filter('siteid=? and updated > ?',6, from).to_hash(:tid, :title)
    @posts = Posts.filter('siteid=? and addeddate > ? ',6, from).order(:addeddate).all


    render 'posts_grouped_by_thread'
  end

  get :users_posts_by_hour do

    #LogHelper.log_req(request)

    hh = params[:h]
    curr_hour = DateTime.now.new_offset(3/24.0).hour
    today = DateTime.now.new_offset(3/24.0).beginning_of_day

    from = hh.nil? ? today+(curr_hour/24.0) : today+(hh.to_i/24.0)

    @threads = Threads.filter('siteid=? and updated > ?',6, from).to_hash(:tid, :title)

    @posts = Posts.filter('siteid=? and addeddate > ? and addeddate < ?',6, from, from+ 1/24.0)
    .reverse_order(:addeddate)
    .select(:addeduid, :addedby, :addeddate, :body, :tid).all

    render 'users_posts_by_hour'
  end


  get :users_posts_timetable do

    #LogHelper.log_req(request)

    hh = params[:h]
    now=DateTime.now.new_offset(3/24.0)
    from =  now-0.5

    #@threads = Threads.filter('sitedid=? and updated > ?',6, from).to_hash(:tid, :title)

    @posts = Posts.filter('siteid=? and addeddate > ? and addeddate < ?',6, from, now)
    .reverse_order(:addeddate)
    .select(:addeduid, :addedby, :addeddate, :tid).all

    render 'users_posts_timetable'
  end

end
