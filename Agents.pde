/**
* @brief The agent class helps set an instance of an agent that seeks or and agent that flees.
*
*/
class Agent{
  SteeringBehaviour instance_steeringBehaviour;
//  Game instance_game;
  Path path;
  PVector m_position, m_velocity, m_desiredVel;
  int m_currentNode, m_pathDir, m_squadSize;
  float m_maxForce, m_maxSpeed, m_mass, m_targetDistance, m_slowingRadius;
  boolean isSeeking;
  ArrayList<Agent> m_queue, m_squad;
  ArrayList<PVector> m_squadPositions;
  /**
  * @brief Constructor of the agent class takes four parameters in.
  * @param t_pos sets the initial position of the agent.
  * @param t_maxForce sets the limit for the agent's steering force
  * @param t_maxSpeed sets the max speed of the agent.
  * @param t_mass defines the mass and the width and height of the agent.
  */
  public Agent(PVector t_pos, float t_maxForce, float t_maxSpeed, float t_mass){
    instance_steeringBehaviour = new SteeringBehaviour();
    m_position = t_pos;;
    m_velocity = new PVector(0,0);
    m_desiredVel = new PVector(0,0);
    m_maxForce = t_maxForce;
    m_maxSpeed = t_maxSpeed;
    m_mass = t_mass;
    m_targetDistance = 0;
    m_slowingRadius = t_mass * 2.5;
    isSeeking = false;
    m_pathDir = 1;
    m_queue = null;
    m_squad = null;
    m_squadPositions = null;
    m_squadSize = 0;
  }
  
  /**
  * @brief Constructor of the agent class takes four parameters in.
  * @param t_pos sets the initial position of the agent.
  * @param t_maxForce sets the limit for the agent's steering force
  * @param t_maxSpeed sets the max speed of the agent.
  * @param t_mass defines the mass and the width and height of the agent.
  */
  public Agent(PVector t_pos, float t_maxForce, float t_maxSpeed, float t_mass, Path t_path){
    instance_steeringBehaviour = new SteeringBehaviour();
    m_position = t_pos;;
    m_velocity = new PVector(0,0);
    m_desiredVel = new PVector(0,0);
    m_maxForce = t_maxForce;
    m_maxSpeed = t_maxSpeed;
    m_mass = t_mass;
    m_targetDistance = 0;
    m_slowingRadius = t_mass * 2.5;
    isSeeking = false;
    path = t_path;
    m_currentNode = 0;
    m_pathDir = 1;
    m_queue = null;
    m_squad = null;
    m_squadPositions = null;
    m_squadSize = 0;
  }
  
  /**
  * @brief Function that takes in one parameter to set the target the agent is going to seek after.
  * @param t_target is the current position of the target.
  */
  public void seek(PVector t_target){
    keepInScreenLimits();
    instance_steeringBehaviour.seek(this, t_target);
    isSeeking = true;
    arrival(isSeeking);
  }
  
  /**
  * @brief Function that takes in one parameter to set the target the agent is going to flee from.
  * @param t_target is the currenmt position of the target.
  */
  public void flee(PVector t_target){
    keepInScreenLimits();
    instance_steeringBehaviour.flee(this, t_target); 
    isSeeking = false;
    arrival(isSeeking);
  }
  
  /**
  * @brief Function that slows down the agent on arrival to the target or that slowly accelerates the agent's flee speed depending on the type of agent.
  * @param t_isSeeking sets the nature of the agent, it could be an agent that is seeking or otherwise an agent that is fleeing.
  */
  public void arrival(boolean t_isSeeking) {
    instance_steeringBehaviour.arrival(this, t_isSeeking); 
  }
  
  /**
  * @brief Function that makes the agent wander off.
  * @param t_circleDistance sets a distance from the agent's position point in the forward direction.
  * @param t_circleRadius sets the size of the virtual circle created in front of the agent.
  * @param t_angleChange limits the angle of the wandering possibilities.
  */
  public void wander(float t_circleDistance, float t_circleRadius, float t_angleChange){
    //m_velocity = new PVector(10,5);
    instance_steeringBehaviour.wander(this, t_circleDistance, t_circleRadius, t_angleChange);
  }
  
  /**
  * @brief Function that makes this agent pursuit a target by predicting where the target's position will be in the future. 
  * @param t_target sets the target that will be chased by the agent calling the function.
  */
  public void pursuit(Agent t_target){
    keepInScreenLimits();
    instance_steeringBehaviour.pursuit(this, t_target);
    isSeeking = true;
    arrival(isSeeking);
  }
  
  /**
  * @brief Function that makes the agent that calls the function evade a specific target.
  * @param t_target set the target to be evaded.
  */
  public void evade(Agent t_target){
    keepInScreenLimits();
    instance_steeringBehaviour.evade(this, t_target);
    isSeeking = false;
    arrival(isSeeking);
  }
  
  /**
  * @brief Function that makes the agent follow a specific path predetermined in the constructor. Once the path is finished the agent retraces the path back to the beginning and then starts all over.
  *
  */
  public void pathFollowing(){
    keepInScreenLimits();
    instance_steeringBehaviour.pathFollowing(this);

    //arrival(isSeeking);
  }
  
  /**
  * @brief Function that sets the agent that calls the function as the leader of a Squad that follows it arround in a specific formation.
  *
  */  
  public void leader(){
    //keepInScreenLimits();
    instance_steeringBehaviour.leader(this, this.m_squad);
    //for(Agent squadMember : this.m_squad){
    //  squadMember.keepInScreenLimits();
    //}
  }
  
  /**
  * @brief Function that sets the agent that calls the function as the leader of a squad that follows it around in a line formation. 
  *
  */
  public void leaderQueue(){
      keepInScreenLimits();
      instance_steeringBehaviour.leaderQueue(this);
  }
  
  
  /**
  * @brief Function that keeps the agents inside the screen limits by making them spawn on the opposite side from where they try to leave the screen.
  *
  */
  public void keepInScreenLimits(){
    
    int buffer = 30;
    
    if(m_position.x > width - width && m_position.x < width 
    && m_position.y > height- height && m_position.y < height){
       return; 
    }
    if(m_position.x < width - width){
      m_position.x = width - buffer; 
    }
    if(m_position.x > width){
      m_position.x = width - width + buffer;
    }
    if(m_position.y < height - height){
     m_position.y = height - buffer;  
    }
    if(m_position.y > height){
     m_position.y = height - height + buffer; 
    }
  }
  
  /**
  * @brief Function that renders the agent in the screen. It is set to draw a circle by default.
  *
  */
  public void paint(){
    circle(m_position.x, m_position.y, m_mass);
  }
}
