import twitter4j.*;
import twitter4j.api.*;
import twitter4j.auth.*;
import twitter4j.conf.*;
import twitter4j.json.*;
import twitter4j.media.*;
import twitter4j.management.*;
import twitter4j.util.*;
import twitter4j.util.function.*;

import guru.ttslib.*;
import rita.*;

RiMarkov markov;
twitter4j.Twitter twitter;
ArrayList<String> messages = new ArrayList();

//Text to Speech
TTS tts;
TTS tts2;
TTS tts3;

int currentTweet;

void setup() {
  //Set the size of the stage, and the background to black.
  //size(800,500);
  fullScreen(SPAN);
  background(0);
  smooth();
  textFont(createFont("times", 16));
  
  // set the text-to-speech instance
  System.setProperty("mbrola.base","c:/Program Files (x86)/Mbrola Tools");
  tts = new TTS("mbrola_us1");
  tts2 = new TTS("mbrola_us2");
  tts3 = new TTS("mbrola_us3");
  
  
  //create the markov model
  markov = new RiMarkov(4);
  markov.loadFrom("/text/PPCh1.txt", this);
  markov.loadFrom("/text/PPCh2.txt", this);
  //markov.loadFrom("/text/DavidParkerRay.txt", this);

  //Credentials
  ConfigurationBuilder cb = new ConfigurationBuilder();
  cb.setDebugEnabled(true);
  cb.setOAuthConsumerKey("");
  cb.setOAuthConsumerSecret("");
  cb.setOAuthAccessToken("");
  cb.setOAuthAccessTokenSecret("");

  // set up twitter instance
  TwitterFactory tf = new TwitterFactory(cb.build());
  twitter = tf.getInstance();
  
  getNewTweets();
  // generate new text and use TTS
  //if (markov.ready())
  //{
    //String[] lines = markov.generateSentences(10);
    //String text = RiTa.join(lines, " ");
    //tts.speak(text);
  //}
  currentTweet = 0;
  
  thread("refreshTweets");
}

void draw() {
  //Draw a faint black rectangle over what is currently on the stage so it fades over time.
  fill(0, 45);
  rect(0, 0, width, height);

  currentTweet = currentTweet + 1;

  //Draw a word from the list of words that we've built
  if (currentTweet >= messages.size())
  {
    currentTweet = 0;
  }
  
  String word = messages.get(currentTweet);
 
  //Put it somewhere random on the stage, with a random size and colour
  fill(255, random(140, 255));
  textSize(random(10, 30));
  text(word, random(0,width-350), random(0,height-50), 450, 200);
  delay(3000);
}

void getNewTweets()
{

  //Try making the query request.
  try {
    // set up query
    Query query = new Query("(Trump) OR (sunshine) OR (Alt-Right)");
    query.count(100);
    QueryResult result = twitter.search(query);
    ArrayList tweets = (ArrayList) result.getTweets();
    
    for (int i = 0; i < tweets.size(); i++) {
      Status t = (Status) tweets.get(i);
      String user = t.getUser().getScreenName();
      String msg = t.getText();
      String d = t.getCreatedAt().toString();
      println("Tweet by " + user + " at " + d + ": " + msg);
     
      // remove links, usernames, and hashtags from tweets
      RiString message = new RiString(msg);
      message = message.replaceAll("[@]+[A-Za-z0-9-_]+", "");
      message = message.replaceAll("[#]+[A-Za-z0-9-_]+", "");
      message = message.replaceAll("[A-Za-z]+://[A-Za-z0-9-_]+.[A-Za-z0-9-_:%&~?/.=]+", "");
      
      // add the tweet to the markov model
      markov.loadText(message.text());
      messages.add(msg);
    };
  }
  catch (TwitterException te) {
    println("Couldn't connect: " + te);
  };
}

void refreshTweets()
{
  while (true)
  {
    getNewTweets();
    // generate new text and use TTS
    if (markov.ready())
    {
      String[] lines = markov.generateSentences(10);
      for (int i = 0; i < 10; i++)
      {
        if (i % 2 == 0) {tts2.speakLeft(lines[i]);}
        else if (i == 3 || i == 7) {tts3.speakRight(lines[i]);}
        else {tts.speak(lines[i]);}
      }
     // String text = RiTa.join(lines, " ");
      //tts.speak(text);
    }
    println("Updated Tweets");
    delay(2000);
  }  
}

void mouseClicked()
{
  if (!markov.ready()) return;

  String[] lines = markov.generateSentences(10);
  String text = RiTa.join(lines, " ");
  tts.speak(text);
}