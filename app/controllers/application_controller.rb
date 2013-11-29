class ApplicationController < ActionController::Base
  protect_from_forgery

  layout :layout

  private

  def layout
    # only turn it off for login pages:
    is_a?(Devise::SessionsController) ? false : "application"
    # or turn layout off for every devise controller:
    !devise_controller? && "application"
  end

  def canedit(entry)
  	if current_user.id != entry.user_id
      redirect_to root_url, alert: 'You are not authorized to edit that.'
    end
  end

  def recentgames(userid, durlen)
    @timearray = Array.new(durlen, 0)
    (0..durlen+1).each do |i|
      @timearray[i-1] = i.days.ago.strftime('%D')
    end
    @winscon = Hash.new
    @winsarena = Hash.new
    @arenawins = cularenagames(userid, durlen)
    @conwins = culcongames(userid, durlen)
  end

  def cularenagames(userid, days1)
    winrate = Array.new(days1, 0)
    winrate[0] = 0
    (0..days1).each do |i|
      win = Arena.where(user_id: userid, win: true).where("created_at <= ?", i.days.ago.end_of_day).count
      tot = Arena.where(user_id: userid).where("created_at <= ?", i.days.ago.end_of_day).count
      winrate[i] = [i,(win.to_f / tot).round(4)*100]
    end
    return winrate
  end

  def culcongames(userid, days1)
    winrate = Array.new(days1, 0)
    winrate[0] = 0
    (0..days1).each do |i|
      win = Constructed.where(user_id: userid, win: true).where("created_at <= ?", i.days.ago.end_of_day).count
      tot = Constructed.where(user_id: userid).where("created_at <= ?", i.days.ago.end_of_day).count
      winrate[i] = [i,(win.to_f / tot).round(4)*100]
    end
    return winrate
  end
end
