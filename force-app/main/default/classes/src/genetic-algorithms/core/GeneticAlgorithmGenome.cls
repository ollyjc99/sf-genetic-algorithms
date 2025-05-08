/**
    @author      Oliver Carter
    @description Wrapper Class for Genomes
    @created     04-06-2024
    @version     1.0
*/
public class GeneticAlgorithmGenome implements Comparable {

  public List<Integer> dna;
  public Integer fitness;

  public GeneticAlgorithmGenome(Object dna) {
    this.dna = (List<Integer>) JSON.deserialize(JSON.serialize(dna), List<Integer>.class);
  }

  public GeneticAlgorithmGenome(List<Integer> dna) {
    this.dna = dna;
  }

  public Integer compareTo(Object compareTo)
  {
    Integer compareToFitness = ((GeneticAlgorithmGenome) compareTo).fitness;
    return this.fitness > compareToFitness ? -1 : this.fitness < compareToFitness ? 1 : 0;
  }
}