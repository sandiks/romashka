FbotWeb::Onln.controllers :thread do

  get ':id/page/:page' do
    LogHelper.log_req(request)

    thr = Threads.first(siteid:5,tid: params[:id])
    @thread_title = thr.title
    @title ="onln::thread::#{@thread_title}"

    @page = params[:page].to_i
    @posts = Posts.where(:tid => params[:id]).order(:addeddate).extension(:pagination).paginate(@page, 25).all
    @thread_users = Posts.where(:tid => params[:id]).select(:addeduid, :addedby).all
    .group_by{ |p| p[:addeduid] }.sort_by{|k,v| -v.size}.map { |k,v| [k,v.first[:addedby],v.size]  }

    @responses = thr.responses.to_i
    @url = "/thread/#{params[:id]}"
    @show_pagination = true

    render 'thread_posts'
  end

  get ':id/all' do
    LogHelper.log_req(request)
    tid =params[:id]

    @thread = Threads.first(siteid:5,tid: tid)
    @posts = Posts.filter(siteid:5, tid:tid)
    .order(:addeddate)
    .all

    render 'thread_posts'
  end

end
