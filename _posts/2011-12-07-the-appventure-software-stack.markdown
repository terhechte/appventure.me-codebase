---
layout: post
title: The Appventure Software Stack
tags: [tech, unix]
published: false
---
List the software stack, that makes up my site.
- jekyll with a set of plugins
- git, so that I can create posts from everywhere and modify everything from everywhere
- cloud9 editor, for editing and creating posts online (vim mode!)
- a daemon that imports / syncs posts from my tumblr, google+, quotevault accounts
- a rake script that is called whenever there're git updates, and renders the files to html
- and on my server it is being checked out, curryied, and then rendered to static files with jekyll
- it would be easy to export it from there to other servers (like S3) if necessary
