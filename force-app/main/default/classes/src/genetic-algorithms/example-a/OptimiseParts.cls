public class OptimiseParts extends GeneticAlgorithm {

  public OptimiseParts (List<Thing> things, Decimal mr, Decimal cr, Integer wl) {
    super(things, mr, cr, wl);
  }

  public override Integer calculateFitness(List<Integer> dna)
  {
    Integer weight = 0;
    Integer value = 0;

    for (Integer i = 0; i < this.things.size(); i++)
    {
      Thing thing = (Thing) this.things.get(i);

      if (dna[i] == 1) {
        weight += thing.weight;
        value += thing.value;

        if (weight > this.weightLimit) { return 0; }
      }
    }
    return value;
  }

  public class Thing extends GeneticAlgorithmThing {

    public Integer age;

    public Thing(String recordId, String name, Integer value, Integer weight, Integer age) {
      super(recordId, name, value, weight);
      
      this.age = age;
    }
  }

}