---
  title: Fast NSDictionary traversal in Objective-C
  tags: cocoa
  layout: post
---
[Dictionaries](http://developer.apple.com/library/mac/#documentation/Cocoa/Reference/Foundation/Classes/nsdictionary_Class/Reference/Reference.html) in Cocoa are really powerful objects that offer a solid base of useful methods, are easy to expand, and fast - especially due to the framework-wide distinction between mutable and immutable classes. One can really see the benefits of nurturing and enhancing a single API over the course of more than 18 years [^foot1].

Nowadays, as soon as your application receives data from any of the various web APIs, you oftentimes and up with a huge JSON file that contains various properties and subproperties of an entity that you intend to display or process in a specific way.
In short, it is more and more the case that you end up with an structure that bears resemblance to well known Russian Dolls.

Take, for example, the data returned from the [Instagram API](http://instagram.com/developer/endpoints/media/) for a media item (I shortened the data a bit)


<div class="hilite_me_code"><pre style="margin: 0; line-height: 125%">{
    <span style="color: #4070a0">&quot;data&quot;</span><span style="color: #666666">:</span> [{
        <span style="color: #4070a0">&quot;location&quot;</span><span style="color: #666666">:</span> {
            <span style="color: #4070a0">&quot;id&quot;</span><span style="color: #666666">:</span> <span style="color: #4070a0">&quot;833&quot;</span>,
            <span style="color: #4070a0">&quot;latitude&quot;</span><span style="color: #666666">:</span> <span style="color: #40a070">37.77956816727314</span>,
            <span style="color: #4070a0">&quot;longitude&quot;</span><span style="color: #666666">:</span> <span style="color: #666666">-</span><span style="color: #40a070">122.41387367248539</span>,
            <span style="color: #4070a0">&quot;name&quot;</span><span style="color: #666666">:</span> <span style="color: #4070a0">&quot;Civic Center BART&quot;</span>
        },
        <span style="color: #4070a0">&quot;comments&quot;</span><span style="color: #666666">:</span> {
            <span style="color: #4070a0">&quot;count&quot;</span><span style="color: #666666">:</span> <span style="color: #40a070">16</span>,
            <span style="color: #4070a0">&quot;data&quot;</span><span style="color: #666666">:</span> [ ... ]
        },
        <span style="color: #4070a0">&quot;caption&quot;</span><span style="color: #666666">:</span> <span style="color: #007020; font-weight: bold">null</span>,
        <span style="color: #4070a0">&quot;link&quot;</span><span style="color: #666666">:</span> <span style="color: #4070a0">&quot;http://instagr.am/p/BXsFz/&quot;</span>,
        <span style="color: #4070a0">&quot;likes&quot;</span><span style="color: #666666">:</span> {
            <span style="color: #4070a0">&quot;count&quot;</span><span style="color: #666666">:</span> <span style="color: #40a070">190</span>,
            <span style="color: #4070a0">&quot;data&quot;</span><span style="color: #666666">:</span> [{
                <span style="color: #4070a0">&quot;username&quot;</span><span style="color: #666666">:</span> <span style="color: #4070a0">&quot;shayne&quot;</span>,
                <span style="color: #4070a0">&quot;full_name&quot;</span><span style="color: #666666">:</span> <span style="color: #4070a0">&quot;Shayne Sweeney&quot;</span>,
                <span style="color: #4070a0">&quot;id&quot;</span><span style="color: #666666">:</span> <span style="color: #4070a0">&quot;20&quot;</span>,
                <span style="color: #4070a0">&quot;profile_picture&quot;</span><span style="color: #666666">:</span> <span style="color: #4070a0">&quot;...&quot;</span>
            }, {...subset of likers...}]
        }}]
} </pre></div>




#### Classical Lookup

Now, if you utilize this structure from Instagram in your Objective-C app, and want to access all the 'likes' for this entity, you'd need to write something like this [^foot2]:


<div class="hilite_me_code"><pre style="margin: 0; line-height: 125%">[[[aDictionary <span style="color: #002070; font-weight: bold">objectForKey:</span><span style="color: #4070a0">@&quot;data&quot;</span>] <span style="color: #002070; font-weight: bold">objectForKey:</span><span style="color: #4070a0">@&quot;likes&quot;</span>]<br/> <span style="color: #002070; font-weight: bold">objectForKey:</span> <span style="color: #4070a0">@&quot;data&quot;</span>]
</pre></div>


Since sending a message to nil objects is allowed in Objective-C, this would run fine even if one of the keys does not exist.
Instead, the main problem here is a visual one: due to Objective-C's very elaborate syntax, adding one or two more hierarchies quickly results in a very cluttered appearance:


<div class="hilite_me_code"><pre style="margin: 0; line-height: 125%">[[[[[aDictionary <span style="color: #002070; font-weight: bold">objectForKey:</span><span style="color: #4070a0">@&quot;data&quot;</span>] <span style="color: #002070; font-weight: bold">objectForKey:</span><span style="color: #4070a0">@&quot;likes&quot;</span>]<br/> <span style="color: #002070; font-weight: bold">objectForKey:</span> <span style="color: #4070a0">@&quot;data&quot;</span>] <span style="color: #002070; font-weight: bold">objectForKey:</span> <span style="color: #4070a0">@&quot;anotherLevel&quot;</span>]<br/> <span style="color: #002070; font-weight: bold">objectForKey:</span> <span style="color: #4070a0">@&quot;andanotherLevel&quot;</span>]
</pre></div>


This certainly looks like it could get out of hand. So, which other options do we have? As it turns out, [KVO (Key-Value-Coding)](http://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/KeyValueObserving/KeyValueObserving.html) offers a terrific alternative:

#### KVO Lookup

KVO lets you access any property on an object through a key or keypath. If, for example, you had a Car object with a Trunk property which is a trunk object with a color property, you could access it like this:


<div class="hilite_me_code"><pre style="margin: 0; line-height: 125%">[Car <span style="color: #002070; font-weight: bold">valueForKeyPath:</span><span style="color: #4070a0">@&quot;trunk.color&quot;</span>];
</pre></div>


As the Apple Docs state, NSDictionaries contain a KVO extension which registers all dictionary keys as KVO properties. This allows us to lookup our beloved 'like' value from Instagram as follows:


<div class="hilite_me_code"><pre style="margin: 0; line-height: 125%">[aDictionary <span style="color: #002070; font-weight: bold">valueForKeyPath:</span> <span style="color: #4070a0">@&quot;data.likes.data&quot;</span>];
</pre></div>


Fantastic isn't it? In fact, that's how I did most of my more complex dictionary lookups in InstaDesk until I recently realized that that could be a terrible performance hog. You see, KVO allows to do fantastic things, but that comes at a certain implementation overhead since much of it's magic is added dynamically runtime. So I wondered how much worse KVO access is against raw dictionary access. To find that out, I wrote this benchmark.

<script extsrc="https://gist.github.com/1444444.js?file=slow_kvo_dictionary_example1.m">//</script>

Shocking! 12 seconds against 1.5 seconds is roughly 8 times as fast. This is a situation in which the added syntax advantages of KVO loose hands down against the performance disadvantages.

Which is kinda sad though, as the KVO access really looks cleaner and is easier to write. This got me thinking. Would it be possible, using the C preprocessor, to write a bit of macro magic that takes in a list of keys and outputs the complex and cluttered Objective-C NSDictionary code? 

#### C Preprocessor Magic

This is a tough problem. The [C preprocessor](http://gcc.gnu.org/onlinedocs/cpp/) is not turing complete and thus rather limited if you want to do more than replace code or conduct simple logical branching [^foot3]. One could, of course, write a macro that spits out C code that does the nitty gritty. But that was not what I wanted. I wanted the end result to be unrolled 'objectForKey:' messages and not calls to a C function that iterates over a string or list. 

Even though the preprocessor doesn't allow us to iterate or loop over lists or strings, it does have support for variadic argument lists (__VA_ARGS__), and, through a neat little hack, allows to count the [number of items in such a variadic list](http://groups.google.com/group/comp.std.c/browse_thread/thread/77ee8c8f92e4a3fb/346fc464319b1ee5?pli=1). Given these constraints I had an idea on how solve the problem at hand:

<script extsrc="https://gist.github.com/1444513.js?file=slow_kvo_dictionary_example2.m">//</script>

As you can see, the C preprocessor code is rather long. But that's only so it can support up to 8 NSDictionary levels. The usage is incredibly simple. Writing:


<div class="hilite_me_code"><pre style="margin: 0; line-height: 125%">KeyPathDictionary(aDictionary, <span style="color: #4070a0">&quot;data&quot;</span>, <span style="color: #4070a0">&quot;likes&quot;</span>, <span style="color: #4070a0">&quot;data&quot;</span>, <span style="color: #4070a0">&quot;friend&quot;</span>,<br/> <span style="color: #4070a0">&quot;voldemort&quot;</span>, <span style="color: #4070a0">&quot;wand&quot;</span>);
</pre></div>


Expands to:


<div class="hilite_me_code"><pre style="margin: 0; line-height: 125%">[[[[[aDictionary <span style="color: #002070; font-weight: bold">objectForKey:</span><span style="color: #4070a0">@&quot;data&quot;</span>] <span style="color: #002070; font-weight: bold">objectForKey:</span><span style="color: #4070a0">@&quot;likes&quot;</span>]<br/> <span style="color: #002070; font-weight: bold">objectForKey:</span> <span style="color: #4070a0">@&quot;data&quot;</span>] <span style="color: #002070; font-weight: bold">objectForKey:</span> <span style="color: #4070a0">@&quot;friend&quot;</span>]<br/> <span style="color: #002070; font-weight: bold">objectForKey:</span> <span style="color: #4070a0">@&quot;voldemort&quot;</span>] <span style="color: #002070; font-weight: bold">objectForKey:</span> <span style="color: #4070a0">@&quot;wand&quot;</span>];
</pre></div>



Isn't that fantastic?

What I did was that I created 8 different main macros, each responsible for one NSDictionary lookup hierarchy (AKeyPathDictionary - HKeyPathDictionary). The 'KeyPathDictionary' macro then gets the argument list and counts the amount of entries in there (the PP_ macros). Based on the result of this, it will call one of the aforementioned 8 main macros and will expand the arguments into it.

I also tried this on an eight-level dictionary with the following benchmarks:

Time  | Implementation      |
-----:|:--------------------|
30.69 | KVO Access          |
 2.35 | Direct Dictionary   |
 2.28 | Preprocessor Macro  |

As you can see, the gap only widens with more levels in your dictionaries.


#### Outlook

I switched almost all multilevel dictionary access in the upcoming InstaDesk 1.3.8 with this code and it increased the overall speed in a tangible manner. Especially during object creation.

[^foot1]: At least the NSDictionary.h header says 1994-2009, though I think that development of it began even earlier at [NeXTSTEP](http://en.wikipedia.org/wiki/NeXTSTEP).
[^foot2]: Actually, in many situations you'd probably abstract the data in a real object with ivars and properties which invalidate most of what I'm explaining here since, property access in Objective-C is far faster than dictionary access. However, there're quite a lot of situations where you need to access multilevel dictionaries, and in these cases the solution outlined here will help you a lot (performance-wise).
[^foot3]: In C++, there's the [Boost](http://www.boost.org) preprocessor which offers more functionality and is actually turing-complete.
