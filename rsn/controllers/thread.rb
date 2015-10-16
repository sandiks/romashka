FbotWeb::Rsn.controllers :thread do

  get :index, :with => [:id, :page] do
    LogHelper.log_req(request)

    tid = params[:id]
    @page = params[:page].to_i


    tp = Threads.first(siteid:2, tid: tid)
    @title = tp.title

    #binding.pry
    @posts = Posts.where(siteid:2, :tid => tid).order(:addeddate).extension(:pagination).paginate(@page, 20).all
    @thread_users = Posts.where(siteid:2, :tid => tid).select(:addeduid, :addedby).all
    .group_by{ |p| p[:addeduid] }.sort_by{|k,v| -v.size}.map { |k,v| [k,v.first[:addedby],v.size]  }

    @responses = tp.responses.to_i
    @url = "/rsn/thread/#{params[:id]}"

    render 'index'
  end

  get :by_user, :map => "/thread/:id/by_user/:uid" do
    # url_for(:account, :name => "John", :id => 5) => "/the/accounts/John/and/5"
    # access params[:name] and params[:id]
    LogHelper.log_req(request)

    tp = Threads.first(siteid:2, tid: params[:id])
    @title = tp.title

    @posts = Posts.where(siteid:2,:tid => params[:id], :addeduid => params[:uid]).order(:addeddate).all #extension(:pagination).paginate(@page, 20).all
    @thread_users = Posts.where(siteid:2,:tid => params[:id]).select(:addeduid, :addedby).all
    .group_by{ |p| p[:addeduid] }.sort_by{|k,v| -v.size}.map { |k,v| [k,v.first[:addedby],v.size]  }

    @responses = tp.responses.to_i
    @url = "/rsn/thread/#{params[:id]}"
    @page = 1
    render 'index'

  end
end
