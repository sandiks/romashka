FbotWeb::Fpda.controllers :thread do

  get '/track/:tid' do
    #LogHelper.log_req(request)
    Threads.where(siteid:10, tid: params[:tid]).update(bot_tracked: 1)
    redirect "#{request.referrer}"
  end

  get '/untrack/:tid' do
    #LogHelper.log_req(request)
    Threads.where(siteid:10, tid: params[:tid]).update(bot_tracked: 0)
    redirect "#{request.referrer}"
  end
  
  get :index, :map => "/thread/:id/p/:page" do
    #LogHelper.log_req(request)

    sid=10
    @tid=tid = params[:id]

    @page = params[:page].to_i

    tp = Threads.first(siteid:sid, tid: tid)
    @title = tp.title
    #binding.pry

    @pages_count =Tpages.filter(siteid:sid, tid:tid).map([:page,:postcount])

    @posts = Posts.where(siteid:sid, :tid => tid).reverse_order(:addeddate).extension(:pagination).paginate(@page, 20).all

    @thread_users = Posts.where(siteid:sid, :tid => tid).select(:addeduid, :addedby).all
    .group_by{ |p| p[:addeduid] }.sort_by{|k,v| -v.size}.map { |k,v| [k,v.first[:addedby],v.size]  }

    @responses = tp.responses.to_i
    @url = "/fpda/thread/#{tid}"

    render 'index'
  end

end
