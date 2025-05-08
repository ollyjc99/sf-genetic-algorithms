/**
    @author      Oliver Carter
    @description Base Genetic Algorithm class
    @created     04-06-2024
    @version     1.0
*/
public abstract class GeneticAlgorithm {

  protected List<GeneticAlgorithmThing> things;
  private Integer populationSize;
  private Decimal mutationRate;
  private Decimal crossoverRate;
  protected Integer weightLimit;
  private List<GeneticAlgorithmGenome> population;

  public GeneticAlgorithm (List<GeneticAlgorithmThing> things) {
    this.things = things;
    this.mutationRate = 0;
    this.crossoverRate = 0;
    this.populationSize = things.size() * 2;
    this.weightLimit = 0;
    this.population = new List<GeneticAlgorithmGenome>();
  }

  public GeneticAlgorithm setMutationRate(Decimal mutationRate) {
    this.mutationRate = mutationRate;
    return this;
  }

  public GeneticAlgorithm setCrossoverRate(Decimal crossoverRate) {
    this.crossoverRate = crossoverRate;
    return this;
  }

  public GeneticAlgorithm setWeightLimit(Integer weightLimit) {
    this.weightLimit = weightLimit;
    return this;
  }

  /**
      @author      Oliver Carter
      @description Function to generate a tournament between two genomes
      @param       Integer defining the total number of evolutions in this Genetic Algorithm
      @created     04-06-2024
  */
  public List<GeneticAlgorithmThing> execute(Integer evolutions)
  {
    this.generatePopulation(this.things.size());

    Integer fitnessTotal = 0;
    for (GeneticAlgorithmGenome genome : this.population) { fitnessTotal += genome.fitness; }

    System.debug('Starting fitness average: ' + fitnessTotal / this.population.size());

    for (Integer i = 0; i < evolutions; i++)
    {
      List<GeneticAlgorithmGenome> nextGeneration = new List<GeneticAlgorithmGenome>();

      for (Integer j = 0; j < this.population.size() / 2; j++)
      {
        GeneticAlgorithmGenome parentX = this.generateTournament();
        GeneticAlgorithmGenome parentY = this.generateTournament();

        List<GeneticAlgorithmGenome> childGeneticAlgorithmGenomes = this.singlePointCrossover(parentX, parentY);

        nextGeneration.addAll(childGeneticAlgorithmGenomes);
      }
      this.population.addAll(nextGeneration);

      fitnessTotal = 0;
      for (GeneticAlgorithmGenome genome : this.population)
      {
        fitnessTotal += genome.fitness;
      }
      System.debug('Generation ' + (i + 1) + ' fitness average: ' + fitnessTotal / this.population.size());
    }
    this.population.sort();

    List<GeneticAlgorithmThing> optimalSolution = new List<GeneticAlgorithmThing>();

    for (Integer i = 0; i < this.things.size(); i++)
    {
      if (this.population[0].dna[i] == 1) {
        optimalSolution.add(this.things[i]);
      }
    }
    return optimalSolution;
  }

  /**
      @author      Oliver Carter
      @description Function to generate a tournament between two genomes
      @created     04-06-2024
  */
  public GeneticAlgorithmGenome generateTournament()
  {
    Integer x = Math2.randomIndex(this.population);
    Integer y = x;

    while (y == x) { y = Math2.randomIndex(this.population); }

    GeneticAlgorithmGenome genomeX = this.population[x];
    GeneticAlgorithmGenome genomeY = this.population[y];

    Integer genomeToRemove = genomeX.fitness >= genomeY.fitness ? y : x;
    
    this.population.remove(genomeToRemove);

    return genomeToRemove == y ? genomeX : genomeY;
  }

  /**
      @author      Oliver Carter
      @description Function to generate a genome of 0s and 1s with a given length
      @param       Integer defining the length of the genome to create
      @created     04-06-2024
  */
  public List<Object> generateGeneticAlgorithmGenome(Integer length)
  {
    return Math2.randomChoices(new List<Integer> {0, 1}, length);
  }

  /**
      @author      Oliver Carter
      @description Function generate a population of genomes given a size and genome length
      @param       Integer representing the genome's length
      @created     04-06-2024
  */
  public void generatePopulation(Integer genomeLength)
  {
    for (Integer i = 0; i < this.populationSize; i++)
    {
      GeneticAlgorithmGenome genome = new GeneticAlgorithmGenome(this.generateGeneticAlgorithmGenome(genomeLength));
      genome.fitness = this.calculateFitness(genome.dna);

      this.population.add(genome);
    }
  }

  /**
      @author      Oliver Carter
      @description Abstract function to calculate the fitness of a genome
      @param       List<Integer> GeneticAlgorithmGenome DNA
      @return      Integer Fitness value of GeneticAlgorithmGenome
      @created     04-06-2024
  */
  public abstract Integer calculateFitness(List<Integer> dna);

  /**
      @author      Oliver Carter
      @description Function to return the chromosomic section of two genomes
      @param       GeneticAlgorithmGenome First genome for single point crossover
      @param       GeneticAlgorithmGenome Second genome for single point crossover
      @created     04-06-2024
  */
  public List<GeneticAlgorithmGenome> singlePointCrossover(GeneticAlgorithmGenome a, GeneticAlgorithmGenome b)
  {
    if (a.dna.size() != b.dna.size()) {
      throw new IllegalArgumentException('GeneticAlgorithmGenomes must be the same length.');
    }
    if (a.dna.size() < 2) {
      return new List<GeneticAlgorithmGenome> {a, b};
    }
    
    Integer p = Math2.randomIndex(this.things);

    GeneticAlgorithmGenome bitSwappedA = new GeneticAlgorithmGenome(Math2.splice(a.dna, 0, p));
    GeneticAlgorithmGenome bitSwappedB = new GeneticAlgorithmGenome(Math2.splice(b.dna, 0, p));

    GeneticAlgorithmGenome bitSwappedA2 = new GeneticAlgorithmGenome(Math2.splice(b.dna, p + 1, b.dna.size()));
    GeneticAlgorithmGenome bitSwappedB2 = new GeneticAlgorithmGenome(Math2.splice(a.dna, p + 1, a.dna.size()));

    bitSwappedA.dna.addAll(bitSwappedA2.dna);
    bitSwappedB.dna.addAll(bitSwappedB2.dna);

    bitSwappedA.fitness = this.calculateFitness(bitSwappedA.dna);
    bitSwappedB.fitness = this.calculateFitness(bitSwappedB.dna);
    
    return new List<GeneticAlgorithmGenome> {
      this.mutate(bitSwappedA),
      this.mutate(bitSwappedB)
    };
  }

  /**
      @author      Oliver Carter
      @description Function to randomly mutate a genome bit if a random float is less than the mutation rate
      @param       GeneticAlgorithmGenome GeneticAlgorithmGenome to randomly mutate
      @created     04-06-2024
  */
  public GeneticAlgorithmGenome mutate(GeneticAlgorithmGenome genome)
  {
    Integer index = Math.round(Math.random() * (genome.dna.size() - 1));

    genome.dna[index] = Math.random() > this.mutationRate ? genome.dna[index] : Math.abs(genome.dna[index] - 1);

    return genome;
  }

}