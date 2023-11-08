/**
 * @brief SteeringBehaviour class that sets the physics behind the steering behaviour while seeking and fleeing.
 */
class SteeringBehaviour {

  /**
   * @brief Function that changes the current velocity of the agent so that it seeks a given target.
   * @param t_agent is the instance of the agent that is going to seek.
   * @param t_target is the vector position of the target the agent seeks.
   */
  void seek(Agent t_agent, PVector t_target) {
    addSteeringForce(t_agent, t_target, t_agent.m_position);
  }

  /**
   * @brief Function that changes the current velocity of the agent so that if flees from the target.
   * @param t_agent is the instance of the agent that is going to flee.
   * @param t_target is the vector position of the target from wich the agent flees.
   */
  void flee(Agent t_agent, PVector t_target) {
    addSteeringForce(t_agent, t_agent.m_position, t_target);
  }

  /**
  * @brief Function that slows down the agent on arrival to the target or that slowly accelerates the agent's flee speed depending on the type of agent.
  * @param t_agent sets the agent that will be slowing down on arrival if isSeeking is true and speeding up if it is false. 
  * @param t_isSeeking sets the nature of the agent, it could be an agent that is seeking or otherwise an agent that is fleeing.
  */
  void arrival(Agent t_agent, boolean t_isSeeking) {
    float buffer = 10;
    if ((t_isSeeking && t_agent.m_targetDistance + buffer < t_agent.m_slowingRadius) || (!t_isSeeking && t_agent.m_targetDistance + buffer < t_agent.m_slowingRadius)) {
      float ratio = t_isSeeking ? t_agent.m_targetDistance / t_agent.m_slowingRadius : t_agent.m_slowingRadius / t_agent.m_targetDistance;
      t_agent.m_velocity.mult(ratio);
    }
    t_agent.m_position.add(t_agent.m_velocity);
  }
  
  /**
  * @brief Function that makes the agent wander off.
  * @param t_agent sets the agent that will be doing the wandering.
  * @param t_circleDistance sets a distance from the agent's position point in the forward direction.
  * @param t_circleRadius sets the size of the virtual circle created in front of the agent.
  * @param t_angleChange limits the angle of the wandering possibilities.
   */
  void wander(Agent t_agent, float t_circleDistance, float t_circleRadius, float t_angleChange) {
    float circleDistance = t_circleDistance;
    float circleRadius = t_circleRadius;
    float angleChange = t_angleChange;
    PVector circleCenter = t_agent.m_velocity.normalize();
    circleCenter.mult(circleDistance);
    float wanderAngle = random(6.2);
    PVector displacement = PVector.fromAngle(wanderAngle).normalize().mult(circleRadius);
    wanderAngle += (randomGaussian() * angleChange) - (angleChange * .5);
    PVector wanderForce = circleCenter.add(displacement);
    addSteeringForce(t_agent, wanderForce, t_agent.m_position);
  }

  /**
  * @brief Function that makes this agent pursuit a target by predicting where the target's position will be in the future. 
  * @param t_agent sets the agent that will be doing the pursuit.
  * @param t_target sets the target that will be chased by the agent calling the function.
  */
  void pursuit(Agent t_agent, Agent t_target) {
    PVector futurePos = predictTargetPos(t_agent, t_target);
    seek(t_agent, futurePos);
  }

  /**
  * @brief Function that makes the agent that calls the function evade a specific target.
  * @param t_agent sets the agent that will be evading.
  * @param t_target sets the target to be evaded.
  */
  void evade(Agent t_agent, Agent t_target) {
    PVector futurePos = predictTargetPos(t_agent, t_target);
    flee(t_agent, futurePos);
  }



  /**
   * @brief Function that predicts the future forward position of a target based on it's velocity.
   * @param t_agent sets the agent that will be doing the prediction.
   * @param t_target sets the target that will be considered to make a prediction.
   */
  PVector predictTargetPos(Agent t_agent, Agent t_target)
  {
    PVector tarPos = new PVector(t_target.m_position.x, t_target.m_position.y);
    PVector tarDistance = tarPos.sub(t_agent.m_position);
    t_agent.m_targetDistance = tarDistance.mag();
    PVector targetPos = new PVector(tarPos.x, tarPos.y);
    float T = t_agent.m_targetDistance / t_agent.m_maxSpeed;
    PVector targetVel = t_target.m_velocity;
    PVector futurePos = targetPos.add(targetVel).mult(T);
    return futurePos;
  }

  /**
  * @brief Function that makes the agent follow a specific path predetermined in the constructor. Once the path is finished the agent retraces the path back to the beginning and then starts all over.
  * @param t_agent sets the agent that will be following the path.
   */
  void pathFollowing(Agent t_agent) {
    PVector targetNode = null;
    if (t_agent.path != null) {
      ArrayList<PVector> nodes = t_agent.path.getNodes();
      targetNode = nodes.get(t_agent.m_currentNode);

      PVector distance = PVector.sub(targetNode, t_agent.m_position);
      if (mag(distance.x, distance.y) <= t_agent.path.getRadius())
      {
        t_agent.m_currentNode += t_agent.m_pathDir;

        if (t_agent.m_currentNode >= nodes.size() || t_agent.m_currentNode < 0) {
          t_agent.m_pathDir *= -1;
          t_agent.m_currentNode += t_agent.m_pathDir;
        }
      }
    }
    if (targetNode == null) {
      targetNode = new PVector();
    }
    seek(t_agent, targetNode);
    t_agent.m_position.add(t_agent.m_velocity);
  }

  /**
  * @brief Function that sets the agent that calls the function as the leader of a Squad that follows it arround in a specific formation.
  * @param t_leader sets the leader of a squad.
  * @param t_squad is a list that sets the Agents of the squad.
  */
  void leader(Agent t_leader, ArrayList<Agent> t_squad) {
    PVector behindLeaderPos = t_leader.m_velocity.copy();
    behindLeaderPos.normalize();
    behindLeaderPos.mult(-t_leader.m_mass * 2);

    ArrayList<PVector> squadPositions = new ArrayList<PVector>();


    for (int i = 1; i < (t_squad.size()/2) + 1; i++) {
      squadPositions.add(new PVector(behindLeaderPos.y * -i, behindLeaderPos.x).add(t_leader.m_position));
      squadPositions.add(new PVector(behindLeaderPos.y, behindLeaderPos.x * -i).add(t_leader.m_position));
    };

    //if(t_squad.size() == 1){
    //   seek(t_squad.get(0), behindLeaderPos);
    //   arrival(t_squad.get(0), true);
    //   print(" this ");
    //   return;
    //}
    // if(t_squad.size() % 2 == 0){


    for (int i = 0; i < t_leader.m_squadSize; i++) {
      seek(t_squad.get(i), squadPositions.get(i));
      //t_squad.get(i).m_velocity.add(separation(t_leader, t_squad, t_squad.get(i)));
      arrival(t_squad.get(i), true);
    }

    // }
  }

  /**
   * @brief Function that keesps the squad for colliding with each other and with the leader.
   * @param t_leader sets the leader of the squad.
   * @param t_squad is a list that sets the agents of the squad.
   * @param t_squadAgent sets the agent that is separating itself from the rest.
   */
  PVector separation(Agent t_leader, ArrayList<Agent> t_squad, Agent t_squadAgent) {
    PVector force = new PVector();
    float separationRadius = t_leader.m_mass * 1.5;

    ArrayList<Agent> tempList = new ArrayList();


    for (int i = 0; i < t_leader.m_squadSize; i++) {
      tempList.add(t_squad.get(i));
    }

    tempList.add(t_leader);

    for (int i = 0; i < tempList.size(); i++) {
      Agent b = tempList.get(i);


      if (b != t_squadAgent && PVector.dist(b.m_position, t_squadAgent.m_position) <= separationRadius ) {
        force.x += b.m_position.x - t_squadAgent.m_position.x;
        force.y += b.m_position.y - t_squadAgent.m_position.y;
      }
    }

    //force.x /= t_leader.m_squadSize;
    //force.y /= t_leader.m_squadSize;
    force.normalize();
    force.mult(-1);
    //force.normalize();
    force.mult(3);

    return force;
  }

  /**
  * @brief Function that sets the agent that calls the function as the leader of a squad that follows it around in a line formation. 
  * @param t_leader sets the leader of the squad in line formation.
  */
  void leaderQueue(Agent t_leader) {
    if (t_leader.m_queue == null) {
      t_leader.m_queue = new ArrayList();
    }
    for (int i = 0; i < t_leader.m_queue.size(); i++) {
      if (i == 0) {
        t_leader.m_queue.get(i).seek(t_leader.m_position);
        t_leader.m_queue.get(i).m_position.add(t_leader.m_queue.get(i).m_velocity);
        arrival(t_leader.m_queue.get(i), true);
        continue;
      }
      t_leader.m_queue.get(i).seek(t_leader.m_queue.get(i-1).m_position);
      t_leader.m_queue.get(i).m_position.add(t_leader.m_queue.get(i).m_velocity);
    }
  }


  /**
   * @brief Function that sets the steering force of the agent using the velocity obtained from the desired velocity.
   * The seek or flee velocity depends on the order of the content in the vector one variable and the content in the vector two variable.
   * If the agent is in the vector one position and the target in the vector two position, the agent will flee away from the target.
   * If the agent is in the vector two position and the target in the vector one position, the agent will seek the target.
   * @param t_agent is the agent that is having it's velocity modified by the steering force.
   * @param t_vectorOne is the vector position of either the agent that seeks or the agent that flees.
   * @param t_vectorTwo is the vector position of either the agent that seeks or the agent that flees.
   *
   */
  void addSteeringForce(Agent t_agent, PVector t_vectorOne, PVector t_vectorTwo) {
    t_agent.m_desiredVel = PVector.sub(t_vectorOne, t_vectorTwo); // sets direction.
    t_agent.m_targetDistance = mag(t_agent.m_desiredVel.x, t_agent.m_desiredVel.y);
    t_agent.m_desiredVel.normalize().mult(t_agent.m_maxSpeed);
    PVector steeringForce = PVector.sub(t_agent.m_desiredVel, t_agent.m_velocity);
    steeringForce.limit(t_agent.m_maxForce).div(t_agent.m_mass);
    t_agent.m_velocity.add(steeringForce).limit(t_agent.m_maxSpeed);
  }
}
