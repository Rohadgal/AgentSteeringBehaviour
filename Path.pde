/**
*
*
*/
class Path{
   ArrayList<PVector> nodes;
   float radius;
   
   public Path(float t_radius){
       nodes = new ArrayList<PVector>();
       radius = t_radius;
   }
   
   public void addNode(PVector t_node){
     nodes.add(t_node);
   }
   
   public ArrayList<PVector> getNodes(){
     return nodes;
   }
   
   public float getRadius(){
     return radius;
   }
}
