audience
========

Tunetap audience

Getting started
----------------
Go to [mac.github.com](http://mac.github.com) to download the Github app, and click on your account name on the first page. 
![](http://f.cl.ly/items/2r3c1V300F0c0I3k2u34/Screen%20Shot%202014-01-20%20at%2016.13.29.png)

Select the `audience` repo from the list at the bottom and Clone to computer (remember where you save it). If it's already cloned, select 'My Repositories' from the left and double-click on the repository in the main section. In either case, click Sync Branch in the top-right.
![](http://cl.ly/image/0I3M1F3z3t3r/Screen_Shot_2014-01-20_at_16_18_24-3.png)

Open Terminal.app on your computer, and type in `cd ` followed by the name of the folder you saved the project to. You can easily add the name of the folder by opening the folder in Finder, then dragging the icon of the folder into the Terminal prompt.
![](http://cl.ly/image/3X2k1G0G1z1Y/Screen_Shot_2014-01-20_at_16_30_59-4.png)
Hit Return to set your Terminal to that folder. 

Next, type `bundle` in the Terminal and hit enter. Let that finish running; you'll know it's finished when it's prompting you for input again. 

Then run `rake db:migrate` in the Terminal, followed by `rake admin:reset_and_fill_db`. Finally, to start the server, run `rails s` and go to `localhost:3000` in the browser.

Pushing to heroku
-----------------
First, make sure you are in the ``master`` branch and you merged from ``develop``.

Then, make sure that the ``config/database.yml`` file has the proper AWS production server.

Then, you need to precompile your assets (takes a while):

    bundle exec rake assets:precompile RAILS_ENV=production
    
Add your assets and commit:
    
    git add public/assets
    git commit -am "precompile assets"

And now you can push to heroku!

    git push heroku master 

If you messed up and want to replace the branch on heroku, you can use -f:

    git push heroku -f master

 

