@isTest
private class OptimisePartsTest {

  private static List<OptimiseParts.Thing> things = new List<OptimiseParts.Thing>
  {
    new OptimiseParts.Thing('1', 'watch', 120, 5, 2),
    new OptimiseParts.Thing('2', 'book', 5, 12, 1),
    new OptimiseParts.Thing('3', 'laptop', 500, 50, 3),
    new OptimiseParts.Thing('4', 'car', 5000, 90, 10),
    new OptimiseParts.Thing('5', 'shoes', 80, 10, 4),
    new OptimiseParts.Thing('6', 'glasses', 50, 2, 0)
  };

  @isTest
  static void main()
  {
    List<GeneticAlgorithmThing> optimalSolution = new OptimiseParts(things, 0.05, 0.5, 100).execute(50);

    for (GeneticAlgorithmThing thing : optimalSolution)
    {
      OptimiseParts.Thing opThing = (OptimiseParts.Thing) thing;
      System.debug('Thing: ' + opThing.name + ', Age: ' + opThing.age);
    }
  }
}