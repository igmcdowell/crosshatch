# About

Crosshatch is a simple tool to "hatch" your Tweets for Facebook. Once you set it up, Crosshatch will automatically detect any new Tweets you make and post them to Facebook for you.

Any time Crosshatch detects an @mention or #hashtag in a Tweet it's handling, it automatically adds an appropriate link back to Twitter

# Example
The tweet:
"The Hitchhiker's Guide to Seacaucus #lessinterestingbooks" 
will post to Facebook as: 
"The Hitchhiker's Guide to Seacaucus #lessinterestingbooks (http://t3l.us/h/lessinterestingbooks)"

# About t3l.us
t3l.us is a simple link shortener customized for twitter. http://t3l.us/username goes to http://twitter.com/username and http://t3l.us/h/hashtag goes to http://twitter.com/#!/search/#hashtag

It's necessary as Facebook does not allow <href> tags from applications, while it will auto-link an http:// prefixed URL. It's not really necessary, but it saves a small number of characters and was fun to implement.
