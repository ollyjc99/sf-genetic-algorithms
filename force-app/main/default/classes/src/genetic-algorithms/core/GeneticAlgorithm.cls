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
  private List<Genome> population;

  public GeneticAlgorithm() {
    this(new List<GeneticAlgorithmThing>(), 0, 0, 0);
  }

  public GeneticAlgorithm (
    List<GeneticAlgorithmThing> things,
    Decimal mr,
    Decimal cr,
    Integer wl
  ) {
    if (things == null || things.isEmpty()) {
      throw new ListException('List of GeneticAlgorithmThings cannot be empty.');
    }

    this.things = things;
    this.mutationRate = mr;
    this.crossoverRate = cr;
    this.populationSize = things.size() * 2;
    this.weightLimit = wl;
    this.population = new List<Genome>();
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
    for (Genome genome : this.population) { fitnessTotal += genome.fitness; }

    System.debug('Starting fitness average: ' + fitnessTotal / this.population.size());

    for (Integer i = 0; i < evolutions; i++)
    {
      List<Genome> nextGeneration = new List<Genome>();

      for (Integer j = 0; j < this.population.size() / 2; j++)
      {
        Genome parentX = this.generateTournament();
        Genome parentY = this.generateTournament();

        List<Genome> childGenomes = this.singlePointCrossover(parentX, parentY);

        nextGeneration.addAll(childGenomes);
      }
      this.population.addAll(nextGeneration);

      fitnessTotal = 0;
      for (Genome genome : this.population)
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
  public Genome generateTournament()
  {
    Integer x = Math2.randomIndex(this.population);
    Integer y = x;

    while (y == x) { y = Math2.randomIndex(this.population); }

    Genome genomeX = this.population[x];
    Genome genomeY = this.population[y];

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
  public List<Object> generateGenome(Integer length)
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
      Genome genome = new Genome(this.generateGenome(genomeLength));
      genome.fitness = this.calculateFitness(genome.dna);

      this.population.add(genome);
    }
  }

  /**
      @author      Oliver Carter
      @description Abstract function to calculate the fitness of a genome
      @param       List<Integer> Genome DNA
      @return      Integer Fitness value of Genome
      @created     04-06-2024
  */
  public abstract Integer calculateFitness(List<Integer> dna);

  /**
      @author      Oliver Carter
      @description Function to return the chromosomic section of two genomes
      @param       Genome First genome for single point crossover
      @param       Genome Second genome for single point crossover
      @created     04-06-2024
  */
  public List<Genome> singlePointCrossover(Genome a, Genome b)
  {
    if (a.dna.size() != b.dna.size()) {
      throw new IllegalArgumentException('Genomes must be the same length.');
    }
    if (a.dna.size() < 2) {
      return new List<Genome> {a, b};
    }
    
    Integer p = Math2.randomIndex(this.things);

    Genome bitSwappedA = new Genome(Math2.splice(a.dna, 0, p));
    Genome bitSwappedB = new Genome(Math2.splice(b.dna, 0, p));

    Genome bitSwappedA2 = new Genome(Math2.splice(b.dna, p + 1, b.dna.size()));
    Genome bitSwappedB2 = new Genome(Math2.splice(a.dna, p + 1, a.dna.size()));

    bitSwappedA.dna.addAll(bitSwappedA2.dna);
    bitSwappedB.dna.addAll(bitSwappedB2.dna);

    bitSwappedA.fitness = this.calculateFitness(bitSwappedA.dna);
    bitSwappedB.fitness = this.calculateFitness(bitSwappedB.dna);
    
    return new List<Genome> {
      this.mutate(bitSwappedA),
      this.mutate(bitSwappedB)
    };
  }

  /**
      @author      Oliver Carter
      @description Function to randomly mutate a genome bit if a random float is less than the mutation rate
      @param       Genome Genome to randomly mutate
      @created     04-06-2024
  */
  public Genome mutate(Genome genome)
  {
    Integer index = Math.round(Math.random() * (genome.dna.size() - 1));

    genome.dna[index] = Math.random() > this.mutationRate ? genome.dna[index] : Math.abs(genome.dna[index] - 1);

    return genome;
  }

  /**
      @author      Oliver Carter
      @description Wrapper Class for Genomes
      @created     04-06-2024
      @version     1.0
  */
  public class Genome implements Comparable {

    public List<Integer> dna;
    public Integer fitness;

    public Genome(Object dna) {
      this.dna = (List<Integer>) JSON.deserialize(JSON.serialize(dna), List<Integer>.class);
    }

    public Genome(List<Integer> dna) {
      this.dna = dna;
    }

    public Integer compareTo(Object compareTo)
    {
      Integer compareToFitness = ((Genome) compareTo).fitness;
      return this.fitness > compareToFitness ? -1 : this.fitness < compareToFitness ? 1 : 0;
    }
  }

}