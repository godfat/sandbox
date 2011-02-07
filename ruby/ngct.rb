
require 'rubygems'
require 'safariwatir'

def ngct_start
  $browser = Watir::Safari.new
  $browser.goto 'http://test.ngct.net'
end

def up_votelink
  $browser_up = $browser.frame(:name, 'up')
  $browser_up.link(:name, 'vote_link').click
end

def up_gamestart
  $browser_up.button(:index, 2).click
end

def up_return

  $browser_up.link(:index, 2).click
end

def up_say text
  $browser_up = $browser.frame(:name, 'up')
  $browser_up.text_field(:id, "say").set(text)
  $browser_up.button(:index, 1).click
end

def up_vote_random
  result = true


  up_votelink
  sleep(0.1)
  begin
    index = rand($browser_up.radios.length) + 1
    $browser_up.radio(:index, index).set
    $browser_up.button(:index, 1).click
  rescue
  end
  sleep(0.1)

  up_return

  result
end

def up_vote name
  result = true

  up_votelink
  sleep(0.1)
  begin

    $browser_up.radio(:value, name).set
    $browser_up.button(:index, 1).click
  rescue
    begin
      index = rand($browser_up.radios.length) + 1
      $browser_up.radio(:index, index).set
      $browser_up.button(:index, 1).click
    rescue
    end

  end
  sleep(0.1)
  up_return

  result
end

def up_start
  result = true

  up_votelink

  sleep(0.1)
  begin
    up_gamestart
  rescue
    result = nil
  end
  sleep(0.1)
  up_return


  result
end

def auto_up_start
  up_say '啟動：自動按開始遊戲(30秒)'
  $thread_stop = false
  while $thread_stop == false
    break unless up_start
    sleep(30)
  end

end

def auto_up_vote_random
  up_say '啟動：自動亂數投票(60秒)'
  $thread_stop = false
  while $thread_stop == false
    break unless up_vote_random
    sleep(60)
  end
end


def auto_up_vote name
  up_say '啟動：自動投票(60秒)'
  $thread_stop = false
  while $thread_stop == false
    break unless up_vote name
    sleep(60)
  end
end
