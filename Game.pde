PVector target;
Path p1, p2;
Agent a1, a2, a3, a4, a5, a6, a7;
Agent aLeader, aSquad0, aSquad1, aSquad2, aSquad3, aSquad4, aSquad5, aSquad6, aSquad7;

/**
* @brief Sets up the window and the instances for the agents. 
*
*/
void setup(){
  size(800, 800);
  p1 = new Path(60);
  p1.addNode(new PVector(20, 20));
  p1.addNode(new PVector(600, 20));
  p1.addNode(new PVector(500, 650));
  p1.addNode(new PVector(60, 700));
  p2 = new Path(60);
  p2.addNode(new PVector(50, 50));
  p2.addNode(new PVector(700, 30));
  p2.addNode(new PVector(600, 400));
  p2.addNode(new PVector(20, 650));
  a1 = new Agent(new PVector(width*0.5, height*0.5), 80, 25, 200);
  a2 = new Agent(new PVector(50,400), 30, 30 , 50);
  a3 = new Agent(new PVector(width*.5, height*.5), 2, 2, 40);
  a4 = new Agent(new PVector(width*.2, height*.2), 2, 2, 80, p1);
  a5 = new Agent(new PVector(200,600), 3, 3 , 60, p1);
  a6 = new Agent(new PVector(600,600), 3, 3, 60);
  a7 = new Agent(new PVector(600,600), 3, 3, 60);
  
  a5.m_queue = new ArrayList();
  a5.m_queue.add(a6);
  a5.m_queue.add(a7);
  
  aLeader = new Agent(new PVector(400, 600), 4, 4, 30, p2);
  aSquad0 = new Agent(new PVector(100, 60), 5, 5, 30);
  aSquad1 = new Agent(new PVector(500, 70), 5, 5, 30);
  aSquad2 = new Agent(new PVector(20, 600), 5, 5, 30);
  aSquad3 = new Agent(new PVector(50, 600), 5, 5, 30);
  aSquad4 = new Agent(new PVector(100, 60), 5, 5, 30);
  aSquad5 = new Agent(new PVector(500, 70), 5, 5, 30);
  aSquad6 = new Agent(new PVector(20, 600), 5, 5, 30);
  aSquad7 = new Agent(new PVector(50, 600), 5, 5, 30);
  
  aLeader.m_squadSize = 8;
  aLeader.m_squad = new ArrayList();
  aLeader.m_squad.add(aSquad0);
  aLeader.m_squad.add(aSquad1);
  aLeader.m_squad.add(aSquad2);
  aLeader.m_squad.add(aSquad3);
  aLeader.m_squad.add(aSquad4);
  aLeader.m_squad.add(aSquad5);
  aLeader.m_squad.add(aSquad6);
  aLeader.m_squad.add(aSquad7);

  
}

/**
* @brief Draws the whole scene, the background, the cursor and the agents.
*
*/
void draw(){
  background(60, 60, 150);

  fill(155, 120, 120);
  a1.pursuit(a2); 
  a1.paint();

  fill(120, 155, 120);
  a2.evade(a1);
  a2.wander(6.5, 1, 2);
  a2.paint();
  
  fill(120, 120, 155);
  a3.seek(new PVector(1,1));
  a3.wander(10, 4, 8);
  a3.paint();
  
  fill(35, 35, 35);
  a4.pathFollowing();
  a4.paint();
  
  fill(100, 100, 20);
  //a5.wander(2, 1.5, 1);
  a5.pathFollowing();
  a5.paint();
  a5.leaderQueue();
  a6.paint();
  a7.paint();
  
  fill(200, 100, 0);
  aLeader.pathFollowing();
  aLeader.leader();
  aLeader.paint();
  
  fill(0, 100, 220);
  
  aSquad0.paint();
  aSquad1.paint();
  aSquad2.paint();
  aSquad3.paint();
  aSquad4.paint();
  aSquad5.paint();
  aSquad6.paint();
  aSquad7.paint();
}
