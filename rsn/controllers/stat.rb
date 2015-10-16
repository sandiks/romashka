FbotWeb::Rsn.controllers :stat do

    get :recent_posts do

      @title = "rsn:recent"
      from = DateTime.now.new_offset(3/24.0) - (24/24.0)

      @forums = Forums.to_hash(:fid,:name)
      @topics = Topics.filter('updated_at > ?',from).to_hash(:smid)

      @posts = Posts.join(:topics, :smid=>:smid).exclude(fid:[33,34,84]).filter('addedat > ? ', from).order(:addedat).all

      @page =1
      @responses = @posts.size
      @url = "/stat/recent_posts"
      render 'posts_grouped_by_thread'

    end

end
