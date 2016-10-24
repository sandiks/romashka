FbotWeb::Sqlru.controllers :thread do

  get :index, :map => "/thread/:id/p/:page" do
    #LogHelper.log_req(request)
    sid=6
    @tid=tid = params[:id]
    @page = params[:page].to_i

    tp = Threads.first(siteid:sid, tid: tid)
    @title = tp.title
    #binding.pry

    @pages_count =Tpages.filter(siteid:sid, tid:tid).map([:page,:postcount])

    @posts = Posts.where(siteid:sid, :tid => tid).reverse_order(:addeddate).extension(:pagination).paginate(@page, 25).all

    @thread_users = Posts.where(siteid:sid, :tid => tid).select(:addeduid, :addedby).all
    .group_by{ |p| p[:addeduid] }.sort_by{|k,v| -v.size}.map { |k,v| [k,v.first[:addedby],v.size]  }

    @responses = tp.responses.to_i
    @url = "/sqlru/thread/#{tid}"

    render 'index'
  end
  get :rindex, :map => "/rthread/:id/p/:page" do
    #LogHelper.log_req(request)
    sid=6
    @tid = tid = params[:id]
    @page = params[:page].to_i

    tp = Threads.first(siteid:sid, tid: tid)
    @title = tp.title
    @pages_count =Tpages.filter(siteid:sid, tid:tid).map([:page,:postcount])

    @posts = Posts.where(siteid:sid, :tid => tid).order(:addeddate).extension(:pagination).paginate(@page, 25).all
    
    @thread_users = Posts.where(siteid:sid, :tid => tid).select(:addeduid, :addedby).all
    .group_by{ |p| p[:addeduid] }.sort_by{|k,v| -v.size}.map { |k,v| [k,v.first[:addedby],v.size]  }

    @responses = tp.responses.to_i
    @url = "/sqlru/rthread/#{tid}"

    render 'index'
  end

  get :by_user, :map => "/thread/:id/by_user/:uid" do

    LogHelper.log_req(request)

    tp = Threads.first(siteid:6, tid: params[:id])
    @title = tp.title

    @posts = Posts.where(siteid:6,:tid => params[:id], :addeduid => params[:uid]).order(:addeddate).all #extension(:pagination).paginate(@page, 20).all
    @thread_users = Posts.where(siteid:6,:tid => params[:id]).select(:addeduid, :addedby).all
    .group_by{ |p| p[:addeduid] }.sort_by{|k,v| -v.size}.map { |k,v| [k,v.first[:addedby],v.size]  }

    @responses = tp.responses.to_i
    @url = "/sqlru/thread/#{params[:id]}"
    @page = 1
    render 'index'

  end
  get :users_time, :map => "/thread/:tid/users_time/:uid" do

    tp = Threads.first(siteid:6, tid: params[:tid])
    @title = tp.title

    @posts_time = Posts.where(siteid:6,:tid => params[:tid], :addeduid => params[:uid]).order(:addeddate).map(:addeddate)

    render 'thread_time_table'

  end

  get :with_images, :map => "/thread/:id/images" do

    #LogHelper.log_req(request)

    tp = Threads.first(siteid:6, tid: params[:id])
    @title = tp.title

    @posts = Posts.where(siteid:6, tid: params[:id]).where(Sequel.like(:body, '%actualfile.aspx?%')).order(:addeddate).all #extension(:pagination).paginate(@page, 20).all
    @thread_users = Posts.where(siteid:6,:tid => params[:id]).select(:addeduid, :addedby).all
    .group_by{ |p| p[:addeduid] }.sort_by{|k,v| -v.size}.map { |k,v| [k,v.first[:addedby],v.size]  }

    @responses = tp.responses.to_i
    @url = "/sqlru/thread/#{params[:id]}"
    @page = 1
    render 'index'

  end
end
