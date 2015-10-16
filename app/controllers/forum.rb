FbotWeb::App.controllers :forum do

  get :index2 do
    @mforums = Main_Forums.all

    @mforums_threads= Hash.new
    @mforums.each do |mf|
      site_forums = Site_Forums.filter(mfid: mf.mfid).all
      .group_by{ |ff| ff[:siteid] }
      .map { |k,v| [k,v.map{|sf| sf[:fid]}] }

      #p fids = site_forums
      @mforums_threads[mf.mfid] = []
      site_forums.each do |site_f|
        @mforums_threads[mf.mfid] += Threads.filter(siteid:site_f[0], fid:site_f[1]).reverse_order(:updated).all.take(4)
      end
    end


    render 'index'
  end
  get :index do
    #FbotWeb::App.cache['fbot_forums'] = Forums.all
    @mforums = Main_Forums.all

    @mforums_threads= Hash.new
    @mforums.each do |mf|

      site_forums = Site_Forums.filter(mfid: mf.mfid).all
      @mforums_threads[mf.mfid] = []

      site_forums.each do |site_f|
        site_forum_threads = Threads.filter(siteid:site_f.siteid, fid:site_f.fid).reverse_order(:updated).first(2)

        if @mforums_threads.has_key?(mf.mfid)
          @mforums_threads[mf.mfid] += site_forum_threads
        else
          @mforums_threads[mf.mfid] = site_forum_threads
        end
      end

    end
    render 'index'
  end

end
