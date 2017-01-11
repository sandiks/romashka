FbotWeb::Fpda.controllers :bot do

  get '/check_forum/:id' do
    #LogHelper.log_req(request)
    fid = params[:id]
    system "cd '#{ForumHelper::CRAWLER_DIR}'; ruby 4pda.rb df #{fid}"
    redirect "/fpda/forum/show/#{fid}"

  end

  get '/check_forums' do
    #LogHelper.log_req(request)
    system "cd '#{ForumHelper::CRAWLER_DIR}'; ruby 4pda.rb check_forums"
    redirect "#{request.referrer}"
  end
  
  get '/check_thread/:id' do
    #LogHelper.log_req(request)
    tid=params[:id]
    system "cd '#{ForumHelper::CRAWLER_DIR}'; ruby 4pda.rb dt #{tid} 5" #4pda.rb tid, pages_back
    redirect "fpda/thread/#{tid}/p/1"
  end

  get '/check_tracking_threads' do 
    #LogHelper.log_req(request)
    system "cd '#{ForumHelper::CRAWLER_DIR}'; ruby 4pda.rb selected"
    redirect "#{request.referrer}"
  end

end
