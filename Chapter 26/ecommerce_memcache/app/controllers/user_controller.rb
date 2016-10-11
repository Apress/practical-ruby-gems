class UserController < ApplicationController
  def login
    test_read = session['user_id']
    session['user_id'] = 33
    session['cart_contents']= [ 
                  [ :id=>1,
                    :quantity=>3,
                    :description=>'23 inch Television'],
                  [ :id=>2,
                    :quantity=>1,
                    :description=>'Misc DVD Lot'],

                  [ :id=>3,
                    :quantity=>1,
                    :description=>'Digitial Video Recorder']
                              ]
    render :text=>'Thank you for signing in!' 
  end
  def test_session
    session[:oogle]='frempter'
    render :text=>"<pre>#{session[:oogle]}</pre><br><pre>#{YAML.dump(session)}</pre> <a href='/user/test_session_2/'>test</a>"
  end
  def test_session_2
    render :text=>"<pre>#{session[:oogle]}</pre>"
  end
end
