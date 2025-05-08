/**
  @author      Oliver Carter
  @description Data model to represent a generic genetic algorithm "thing"
  @created     04-06-2024
  @version     1.0
*/
public abstract class GeneticAlgorithmThing {

  public String recordId;
  public String name;
  public Integer value;
  public Integer weight;

  public GeneticAlgorithmThing(String recordId, String name, Integer value, Integer weight) {
    this.recordId = recordId;
    this.name = name;
    this.value = value;
    this.weight = weight;
  }

}