ArrayList<PImage> spriteImg = new ArrayList<PImage>();
ArrayList<Float> spriteScaleX = new ArrayList<Float>();
ArrayList<Float> spriteScaleY = new ArrayList<Float>();


void loadSprites() {
  spriteImg.add(loadImage("data/tree.png"));
  spriteScaleX.add(30.0f); spriteScaleY.add(100.0f);
}
