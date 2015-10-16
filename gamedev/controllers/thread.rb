FbotWeb::Gamedev.controllers :thread do

  get :index, :with => [:id, :page] do
    LogHelper.log_req(request)


    tp = Threads.first(:tid => params[:id])
    @title = tp.title

    @page = params[:page].to_i
    @posts = Posts.where(:tid => params[:id]).order(:addeddate).extension(:pagination).paginate(@page, 20).all
    @thread_users = Posts.where(:tid => params[:id]).select(:addeduid, :addedby).all
    .group_by{ |p| p[:addeduid] }.sort_by{|k,v| -v.size}.map { |k,v| [k,v.first[:addedby],v.size]  }

    @responses = tp.responses.to_i
    @url = "/gamedev/thread/#{params[:id]}"
    render 'index'
  end

  get :by_user, :map => "/thread/:id/by_user/:uid" do
    # url_for(:account, :name => "John", :id => 5) => "/the/accounts/John/and/5"
    # access params[:name] and params[:id]
    LogHelper.log_req(request)

    tp = Topics.first(:smid => params[:id])
    @title = tp.title

    @posts = Posts.where(:smid => params[:id], :addeduid => params[:uid]).order(:addedat).all #extension(:pagination).paginate(@page, 20).all
    @thread_users = Posts.where(:smid => params[:id]).select(:addeduid, :addedby).all
    .group_by{ |p| p[:addeduid] }.sort_by{|k,v| -v.size}.map { |k,v| [k,v.first[:addedby],v.size]  }

    @responses = tp.responses.to_i
    @url = "/thread/#{params[:id]}"
    @page = 1
    render 'index'

  end
end
