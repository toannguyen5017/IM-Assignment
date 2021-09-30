void sound() {
  // load sample
  String audioFileName = "C:/Users/larzi/OneDrive/Desktop/UTS/Second Year/Spring/Interactive Media/Group Assignment/IM-Assignment/assignment_1/326016__vincepest11__ambiance-food-market.wav";
  SamplePlayer player = new SamplePlayer(ac, SampleManager.sample(audioFileName));
  
  Envelope rate = new Envelope(ac, 1);
  player.setRate(rate);
  
  player.setLoopType(SamplePlayer.LoopType.LOOP_FORWARDS);
  
  g = new Gain(2, 1.0);
  
  g.addInput(player);
  ac.out.addInput(g);
  ac.start();
}
