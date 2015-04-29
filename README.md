# mac.bundlr

## Foreword

This is just a side project I created about a year ago, when I'm frustrated about organizing my files. It is far from finished and not for everyone. And I doubt that I'll put more effort into it anytime soon.

## Description

Bundlr is a small utility to open general purposed document bundle structure, called *box* in general, in Mac OS X. It aims at define a simple but versitle bundle format called a "box" and open user specified file or folder in that box when accessed via Finder.

It is meant to be used when you have a set of files which are supposed to be kept together but when you actuall use those files you, most of the times, are only interested in certain part of those files.

It works a lot like the webarchive bundle created by Safari, which contains a bunch of files that should be kept together but it has only one *Entry Point*

With Bundler. You can organize the folder manually and add a extension to it and when you double click it in finder it will open specific file or folder in that box.

## The catches

- As for now, it doesn't support QuickLook preview. Technically a QuickLook plugin is provided, but since a QuickLook plugin cannot call another QuickLook plugin to generate the preview for the *Entry Point*, it is useless.

- Also, Spotlight may not index the content of a box

- For now, Bunldr only declare box types and open them, there is no functionality regarding creating box or converting existing folder into box. This has to be done manually (it's very easy though).

## Predefined box types:

- `.library`
- `.box`
- `.tvshowbox`
- `.moviebox`
- `.musicbox`
- `.appbox`
- `.privatebox`

Technically all those box types are all the same. The distinction is only for user to distinquish them by name, icon and sorting by type in Filder.

You can add your own types by editing the Info.plist of Bundlr.

## Structure of box

When a box is double clicked in Finder, Bundlr will start add look for the *Entry Point* of the box in follwing ways:

- If there is a imediate sub folder named `Contents` in the box it would be used as box root. Otherwise, the box folder would be used as box root.
- Look for file named `EntryPoint` under the box root. (tips: you can use a link or an alias for this file to point to what every file in your box.)
- Look for Info.plist under the box root. If found use the value of `BundlrEntryPoint` as *Entry Point*.
- Look for a folder named `Data` under the box root.


