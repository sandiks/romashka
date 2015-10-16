FbotWeb::Sqlru.controllers :thread do

  get :index, :with => [:id, :page] do
    LogHelper.log_req(request)
    sid=6

    tp = Threads.first(siteid:sid, tid: params[:id])
    @title = tp.title

    #binding.pry

    @page = params[:page].to_i
    @posts = Posts.where(siteid:sid, :tid => params[:id]).order(:addeddate).extension(:pagination).paginate(@page, 25).all
    @thread_users = Posts.where(siteid:sid, :tid => params[:id]).select(:addeduid, :addedby).all
    .group_by{ |p| p[:addeduid] }.sort_by{|k,v| -v.size}.map { |k,v| [k,v.first[:addedby],v.size]  }

    @responses = tp.responses.to_i
    @url = "/sqlru/thread/#{params[:id]}"
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
end
