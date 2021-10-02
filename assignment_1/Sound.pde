void sound() {
  // load sample
  String audioFileName = "/Users/ToanNguyen/Desktop/IM-Assignment/assignment_1/326016__vincepest11__ambiance-food-market.wav";
  
  SamplePlayer player = new SamplePlayer(ac, SampleManager.sample(audioFileName));
  
  Envelope rate = new Envelope(ac, 1);
  player.setRate(rate);
  
  player.setLoopType(SamplePlayer.LoopType.LOOP_FORWARDS);
  
  g = new Gain(2, 1.0);
  
  g.addInput(player);
  ac.out.addInput(g);
  ac.start(); 
}
