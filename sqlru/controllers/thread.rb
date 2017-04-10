FbotWeb::Sqlru.controllers :thread do
  SID = 6
  
  get :index, :map => "/thread/:id/p/:page" do
    #LogHelper.log_req(request)
    @tid=tid = params[:id]
    @page = params[:page].to_i

    tp = Threads.first(siteid:SID, tid: tid)
    @title = tp.title
    #binding.pry

    @pages_count =Tpages.filter(siteid:SID, tid:tid).map([:page,:postcount])

    @posts = Posts.where(siteid:SID, :tid => tid).reverse_order(:addeddate).extension(:pagination).paginate(@page, 25).all

    @thread_users = @posts.map{ |pp| {addeduid: pp.addeduid, addedby: pp.addedby}}
    .group_by{ |p| p[:addeduid] }.sort_by{|k,v| -v.size}.map { |k,v| [k,v.first[:addedby],v.size]  }

    @responses = tp.responses.to_i
    @url = "/sqlru/thread/#{tid}"

    render 'index'
  end
  get :rindex, :map => "/rthread/:id/p/:page" do
    #LogHelper.log_req(request)
    @tid = tid = params[:id]
    @page = params[:page].to_i

    tp = Threads.first(siteid:6, tid: tid)
    @title = tp.title
    @pages_count =Tpages.filter(siteid:6, tid:tid).map([:page,:postcount])

    @posts = Posts.where(siteid:6, :tid => tid).order(:addeddate).extension(:pagination).paginate(@page, 25).all

    @thread_users = @posts.map{ |pp| {addeduid: pp.addeduid, addedby: pp.addedby}}
    .group_by{ |p| p[:addeduid] }.sort_by{|k,v| -v.size}.map { |k,v| [k,v.first[:addedby],v.size]  }

    @responses = tp.responses.to_i
    @url = "/sqlru/rthread/#{tid}"

    render 'index'
  end

  get :by_user, :map => "/thread/:id/by_user/:uid" do

    LogHelper.log_req(request)

    tp = Threads.first(siteid:SID, tid: params[:id])
    @title = tp.title

    @posts = Posts.where(siteid:SID,:tid => params[:id], :addeduid => params[:uid]).order(:addeddate).all #extension(:pagination).paginate(@page, 20).all
    @thread_users = Posts.where(siteid:SID,:tid => params[:id]).select(:addeduid, :addedby).all
    .group_by{ |p| p[:addeduid] }.sort_by{|k,v| -v.size}.map { |k,v| [k,v.first[:addedby],v.size]  }

    @responses = tp.responses.to_i
    @url = "/sqlru/thread/#{params[:id]}"
    @page = 1
    render 'index'

  end
  get :users_time, :map => "/thread/:tid/users_time/:uid" do

    tp = Threads.first(siteid:SID, tid: params[:tid])
    @title = tp.title

    @posts_time = Posts.where(siteid:SID,:tid => params[:tid], :addeduid => params[:uid]).order(:addeddate).map(:addeddate)

    render 'thread_time_table'

  end

  get :with_images, :map => "/thread/:id/images" do

    #LogHelper.log_req(request)

    tp = Threads.first(siteid:SID, tid: params[:id])
    @title = tp.title

    @posts = Posts.where(siteid:SID, tid: params[:id]).where(Sequel.like(:body, '%actualfile.aspx?%')).reverse_order(:addeddate).all #extension(:pagination).paginate(@page, 20).all
    @posts = @posts.select { |pp| SqlRuForumHelper.remove_quoted_from_post(pp[:body]).include? "actualfile.aspx?"  }

    @thread_users = Posts.where(siteid:SID,:tid => params[:id]).select(:addeduid, :addedby).all
    .group_by{ |p| p[:addeduid] }.sort_by{|k,v| -v.size}.map { |k,v| [k,v.first[:addedby],v.size]  }

    @responses = tp.responses.to_i
    @url = "/sqlru/thread/#{params[:id]}"
    @page = 1
    render 'index'

  end

  get '/check_thread/:id' do
    #LogHelper.log_req(request)
    tid=params[:id]
    system "cd '#{ForumHelper::CRAWLER_DIR}'; ruby sqlr.rb dt #{tid} 3" #tid, pages_back
    redirect "/sqlru/thread/#{tid}/p/1"
  end

end
