# Markov-TTS

An application written in [Processing](https://processing.org/) which merges text-to-speech, markov text generation, and the Twitter API. 

![enter image description here](https://lh3.googleusercontent.com/-j04qHupETzo/V924p6KxV6I/AAAAAAAAADc/4gVjdIJngD8-H84W0qGECdDfgWYGM4fmQCLcB/s0/tw1.JPG "tw1.JPG")

Like my [Elm-Fractals](https://github.com/aranarochel/Elm-Fractals) project, Markov-TTS came about as a way to mix art and data sets. Markov-TTS takes different bodies of text, uses markov chains to generate new sentences from those bodies, and then outputs it as speech. The current source texts come from the first 2 chapters of "Pride and Prejudice", a transcription of the David Parker Ray "tapes", and live tweets queried from Twitter. The tweets in their entirety are posted on the application screen.

This application uses several libraries to achieve each component:

 - Text-to-Speech Component: [ttslib](http://www.local-guru.net/blog/pages/ttslib)
 - Markov Sentence Generation: [RiTa](http://rednoise.org/rita/index.php)
 - Java library for Twitter API: [Twitter4J](http://twitter4j.org/en/index.html)


### Note ###
To run the application from the Processing sketchbook, you need to have the associated credentials (Twitter API keys, etc.) in order to query tweets from Twitter. The keys are used in the following section of the code

  

      //Credentials
      ConfigurationBuilder cb = new
      ConfigurationBuilder();
      cb.setDebugEnabled(true);
      cb.setOAuthConsumerKey("");
      cb.setOAuthConsumerSecret("");
      cb.setOAuthAccessToken("");
      cb.setOAuthAccessTokenSecret("");
