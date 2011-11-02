# Flash/PHP Microframework

## Features:

### PHP Microframework
- Based on a customized [Limonade-PHP](http://www.limonade-php.net/) build developed internally at [Proximity BBDO](http://www.proximity.bbdo.be).
- Effortlessly maps URLs to static HTML pages (i.e. *yoursite.com/about* is mapped to *app/views/about.html.php*)
- HTML5 History PushState support for Flash implemented via [History.js](https://github.com/balupton/History.js/).
- Best practices Mobile-First workflow support, with [Modernizr 2](http://www.modernizr.com/) for feature detection.
- Utilizes [LESS CSS](lesscss.org) for compiling optimized, minified stylesheets.
- Includes [LESS Elements](http://lesselements.com/), as it is awesome and includes a whole bunch of handy LESS mix-ins.
- Has a global preferences page accessible via *yoursite.com/preferences* that allows users to choose wether or not they want Flash.

### Flash Microframework featuring following capabilities:
- Global Eventdispatcher for effortless decoupled programming. 
- Router class for mapping URLs to controller methods à la Sinatra/Limonade.
- Javascript bridge between Flash and HTML à la [SWFAddress](http://www.asual.com/swfaddress/), but with afforementioned HTML5 History PushState support.
- HashBang-based fallback for crap browsers *cough* Internet Explorer *cough*
- Easy configuration manager: Config.
- Paging system for effortlessly initing and killing DisplayObjects with completely customizable/override-able animations.
- Some handy utility classes.

### Still to come:
I've included an updated version of my Actionscript 3-based Localization framework "MultiLang", which allows you to easily externalize any textual content to XML files, but I'm still debating wether or not to include it as part of this Microframework. My lofty motto for this framework is "Flash done right", which as all Accessibility- and SEO-advocates will tell you, means that every Flash page should have a wholly equivalent HTML alternative. That would mean that, if I were to include my localization framework for the Flash side of things, that I would also have to build a PHP equivalent for the HTML. And that kind of redundancy doesn't sit right with me, especially considering Flash's support for HTML text is shit, at best and Flash's <TEXTFORMAT> tags aren't valid HTML by any stretch of the imagination. 

So I'm considering leaving that part of my Microframework as is, and leaving developers free to choose their own strategy for localizing/externalizing the content.


### Additional Credits

Other people's code I've used in this Framework, other than what I've mentioned already.

- [PHP Mobile Detect](http://code.google.com/p/php-mobile-detect/) for server-side detection of mobile browsers (who should never be served Flash)
- [Spyc](http://code.google.com/p/spyc/) A simple PHP implementation of YAML (for configuration files)
- [Pieter Michels](https://github.com/pierot) and [Jeroen Bourgois](https://github.com/jeroenbourgois), who helped develop the Proximinade framework, based on [Limonade-PHP](http://www.limonade-php.net/), over at where I work: [Proximity BBDO](http://www.proximity.bbdo.be).