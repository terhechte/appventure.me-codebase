---
  title: Sublime video floating lightbox with Javascript
  category: Code
  tags: [code, javascript]
  keywords: [sublime, sublimevideo, javascript, floating, lightbox, prepareAndPlay, api]
  layout: post
---
I just spend the better half of today trying to get the [Sublime Video
plugin](http://sublimevideo.net)
in lightbox mode working via calls from the Javascript API.

I finally got it working and decided to my findings on here, to help others
with similar problems.

You can see the end result of my work [here](http://www.instadesk-app.com)
(click on the 'Screencast' button).

[Sublimevideo](http://sublimevideo.net) is a cloud services that offers a complete HTML5 ready video
player with Flash fallback and very good support for various browsers. I
decided to use Sublime video because updates come in realtime over the cloud,
and because it is hosted on a fast cdn so that it reduces the amount of http request to
my own domain, and because it seemed to be the least amount of work.

The initial setup was really fast, and I got a working html5 videoplayer in a
couple of minutes. After that, things were bleak though. I wanted to have a
floating lightbox, so that the video would only appear after the user clicked a
button. There is demo code for this [on the sublime website](http://docs.sublimevideo.net/put-video-in-a-floating-lightbox):

{% highlight html %}
 <a class="sublime" href="http://yoursite.com/video-mobile.mp4">
   <img src="http://yoursite.com/video-thumb.jpg" alt="" />
 </a>
 <video style="display:none" class="sublime zoom" width="640" height="360" poster="http://yoursite.com/video-poster.jpg" preload="none">
    <source src="http://yoursite.com/video.mp4" />
    <source src="http://yoursite.com/video.webm" />
 </video>
{% endhighlight %}

So far, so good, this didn't work in the beginning, as I had the <code>a</code> tag and the
<code>video</code> tag at different places within the document. In order to get this to work,
the link has to be the first sibling of the <code>video</code> tag. In all other
circumstances, this doen't work. This already took me a while to figure out, as
it is not even documented in the Sublime documentation. As soon as you have
even one <code>&lt;br&gt;</code> tag in between your link and your video tag, it already
doesn't work anymore.

### The Problem

I wanted to integrate the video on the InstaDesk website in such a way, that
upon hovering on one of the screenshots, a huge play button would appear, and
clicking the play button would start the movie. This led to two problems with
the approach outlined above:

- My play button was actually a <code>div</code> tag with a bit of CSS3, the example above
  only works with <code>a</code> tags though.
- I have 5 screenshots that move in and out of the screen. I needed to have a
  play button on each of these, but each play button would start the same
  video. With the above solution, I would have needed to add the same
  <code>&lt;video&gt;</code> tag 5 times - not an ideal solution.

That's why I tried to use the [Sublimevideo Javascript API](http://docs.sublimevideo.net/javascript-api/methods) to play the video.
The API site specifically states that the [<code>sublimevideo.play</code>](http://docs.sublimevideo.net/javascript-api/methods#play) command works
with zoomable videos (read, floating lightboxes).

Based on the examples on the site, I tried this code:
{% highlight html %}
<script type="text/javascript">
 <video id="videotrailer" style="display:none" class="sublime zoom" width="640" height="360" poster="http://yoursite.com/video-poster.jpg" preload="none">
    <source src="http://yoursite.com/video.mp4" />
 </video>
</script>
{% endhighlight %}

{% highlight Javascript %}
function play() {
    sublimevideo.play("videotrailer");
}
{% endhighlight %}

That didn't work though. I then tried, over hours, multiple variations with
<code>sublimevideo.load</code>, <code>sublimevideo.prepare</code>, and <code>sublimevideo.prepareAndPlay</code>

### The Solution

It was at this point, that I really realized how important the dependency
between the <code>a</code> tag and the <code>video</code> tag (described above) probably really is.
So I changed the code to this, and it worked right away.

{% highlight html %}
<a style="display: none;" class="sublime" href="http://yoursite.com/video-mobile.mp4">&nbsp;</a>
<script type="text/javascript">
 <video id="videotrailer" style="display:none" class="sublime zoom" width="640" height="360" poster="http://yoursite.com/video-poster.jpg" preload="none">
    <source src="http://yoursite.com/video.mp4" />
 </video>
</script>
{% endhighlight %}

{% highlight Javascript %}
function play() {
    sublimevideo.play("videotrailer");
}
{% endhighlight %}

As you can see, the only change is that I added the original link again and set
it to <code>'display: none'</code>, so that it won't even appear in my document. And now,
the Javascript calls worked right away.

Just adding this small line and hiding it did the trick.

{% highlight html %}
<a style="display: none;" class="sublime" href="http://yoursite.com/video-mobile.mp4">&nbsp;</a>
{% endhighlight %}

This is a rather stupid behaviour, and I think it should be documented
properly, after all I lost a couple of hours until I figured this out.


