# Typekit In Situ

Typekit is an awesome service for getting web fonts onto your site. [Their site](http://typekit.com) allows you to type in text and see how phrases look in your selected text, but you can only really see the font in isolation. Even the best fonts can look dull and uninspiring on a plain white background.

TIS (Typekit In Situ) hopes to solve that by making it easy to inject your own HTML and CSS onto the Typekit preview page. It comes with a few prefab templates, and makes it very easy to create your own original templates.

## What is it?

TIS is little more than a Rake script that compiles your HTML, CSS, and Javascript templates into JSON, and provides you with the JS to inject it into the Typekit preview page.

## Dependencies

* [Coffeescript](http://jashkenas.github.com/coffee-script/)
* [HAML](http://haml-lang.com/)
* [FSSM](http://github.com/ttilley/fssm)
* [Rake](http://rake.rubyforge.org/)
* [JSON](http://flori.github.com/json/)

### A note about my biases

This project was put together in about 2 hours. As such, it's strongly suited towards my preferred tools. I intend to fix that over time, but for the time being, it's a very opinionated piece of software.

TIS currently only works with HAML and SASS. It won't work if you edit the HTML or CSS files directly. I intend to fix that eventually, but that's how it is for now.

I less than three Chrome, so the prefab templates currently have a strong preference for Webkit based browsers. That said, you can easily add your own templates that will conform to your browser's rendering engine.

I adore CSS3, so the prefab templates make heavy use of it. If you're the knuckle-dragging sort (AKA an IE user) then you're out of luck.

I'm a Mac user, so I'm not sure if this runs well outside OS X. The script uses pbcopy, which should be available on *nix based machines, so I imagine it would run well on Linux. Windows users might be able to find a pbcopy equivalent in Cygwin.

## How do I use it?

Open the TIS directory in your terminal and run

    rake watch

This will start the watcher script, which will recompile the templates and add the injection code to your clipboard whenever a file changes.

Once you've made a change to a file, go to Typekit's website and find a font you like. For instance, try this page: [http://typekit.com/fonts/changeling-neo](http://typekit.com/fonts/changeling-neo)

Now use your developer toolbar to run the javascript. If you're using Chrome, then you would:

* Right-click on the page an select 'Inspect Element'.
* Once the developer bar comes up, click on the 'Console' tab.
* Paste the text into the console and run it. (Remember, the watcher process should copy the JS to your clipboard when you change a template file)

That's it! If you'd like to get the old page content back, just refresh the page.

## How do I add my own templates?

The HAML, SASS, and Coffeescript directories contain the templates. To make a new one, just create a new HAML file in the haml directory and a new SASS file in the sass directory. Make sure they have the same name (Except the extension, of course). There's no need to reference the SASS/CSS or JS file in your HAML, it will be compiled and inlined by the watcher process.

In order to use a different template, you'll need to edit coffeescripts/application.coffee, and change this line of code:

    $("body").append(templates["temp2"])

You'll need to change "temp2" to the name of your template (the filename minus the extension).

## FAQ

### Is Typekit worth the money?

In a word; yes. It's really made my designs come to life.

### Does TIS allow me to use Typekit on my site without paying for it?

No, and please kindly jump off a cliff.

TIS just lets you see a more realistic preview of a font. When first looking at the font previews on Typekit, I thought a lot of the fonts looked rather boring. Then I went to the gallery section and I was floored. The examples were gorgeous, especially the ones using fonts that I had specifically written off as boring not 30 seconds before. The font didn't change, but its context did.

Fonts are rarely beautiful in isolation, you have to see them in a real page. Typography is more than just a font, it has to do with cadence, layout, contrast, etc. An editable textarea is like seeing a mountain lion at a zoo, TIS hopes to be like coming face to face with a mountain lion in the jungle.

### I made an awesome template. Would you like to add it to the official repo?

**YES!** I'm a programmer by trade. I like to think I'm not terrible at web design, but let's be honest; I'm more comfortable with recursive algorithms than IE's broken box model.

If you've got a design you'd like to submit, then I'd love to see it.

## Work in progress

* TIS should allow users to write plain HTML, Javascript, and CSS. Right now, only HAML, SASS, and Coffeescript work.
* Come up with a way to include images. Possibly using [inline data](http://en.wikipedia.org/wiki/Data_URI_scheme).

## Legal notice

While I'm a huge fan of the Typekit team and the work that they do, I'm not an employee or in any way affiliated with them.
