FbotWeb::Onln.controllers :stat do

  get :index do

  end

  get :user_posts, :with => :id do
    LogHelper.log_req(request)

    from = DateTime.now.new_offset(3/24.0)
    @threads = Threads.filter(siteid:5).to_hash(:tid, :title)
    @posts = Posts.filter(siteid:5, addeduid: params[:id])
    .order(:addeddate)
    .all

    render 'user_posts'
  end
end
