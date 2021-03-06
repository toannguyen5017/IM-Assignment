void sound() {
  // load sample
  String audioFileName = sketchPath("") +  "data/326016__vincepest11__ambiance-food-market.wav";
  
  SamplePlayer player = new SamplePlayer(ac, SampleManager.sample(audioFileName));
  
  Envelope rate = new Envelope(ac, 1);
  player.setRate(rate);
  
  player.setLoopType(SamplePlayer.LoopType.LOOP_FORWARDS);
  
  gain = new Gain(2, 1.0);
  
  gain.addInput(player);
  ac.out.addInput(gain);
  ac.start(); 
}
