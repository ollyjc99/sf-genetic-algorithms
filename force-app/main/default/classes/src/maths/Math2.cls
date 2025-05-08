/**
  @author      Oliver Carter
  @description Class containing reusable mathematical functions that are not possible in OOTB 
  @created     04-06-2024
  @version     1.0
*/
public class Math2 {

  /**
    @author      Oliver Carter
    @description Function to generate a random index from any given array
    @created     05-06-2024
  */
  public static Integer randomIndex(List<Object> itemArray)
  {
    return Math.round(Math.random() * (itemArray.size() - 1));
  }

  public static List<Integer> randomChoices(List<Integer> choices, Integer k)
  {
    return (List<Integer>) randomChoicesANY(choices, k);
  }
  
  /**
    @author      Oliver Carter
    @description Function to return a random selection of choices given an array and integer k
    @created     04-06-2024
  */
  public static List<Object> randomChoicesANY(List<Object> choices, Integer k)
  {
    if (choices == null || choices.isEmpty()) {
      throw new ListException('List argument cannot be empty.');
    }
    if (k == null || k <= 0) {
      throw new IllegalArgumentException('K cannot be less than or equal to 0 or null.');
    }

    List<Object> returnList = choices.clone();
    returnList.clear();

    for (Integer i = 0; i < k; i++)
    {
      returnList.add(choices[randomIndex(choices)]);
    }
    return returnList;
  }

  /**
    @author      Oliver Carter
    @description Function to enumerate a list
    @created     04-06-2024
  */
  public static Map<Integer, Object> enumerate(List<Object> itemArray)
  {
    if (itemArray == null || itemArray.isEmpty()) {
      throw new ListException('List argument cannot be empty.');
    }

    Map<Integer, Object> enumeratedList = new Map<Integer, Object>();
    
    for (Integer i = 0; i < itemArray.size(); i++)
    {
      enumeratedList.put(i, itemArray[i]);
    }
    return enumeratedList;
  }

  /**
    @author      Oliver Carter
    @description Function to splice an array given a start and end
    @created     04-06-2024
  */
  public static List<Integer> splice(List<Integer> itemArray, Integer startIndex, Integer endIndex)
  {
    return (List<Integer>) splice((List<Object>) itemArray, startIndex, endIndex);
  }

  /**
    @author      Oliver Carter
    @description Function to splice an array given a start and end
    @created     04-06-2024
  */
  public static List<Object> splice(List<Object> itemArray, Integer startIndex, Integer endIndex)
  {
    if (startIndex > endIndex) {
      throw new IllegalArgumentException('Start index must be less than the end index.');
    }
    if (startIndex > itemArray.size()) {
      throw new IllegalArgumentException('Start index cannot be greater than array length.');
    }

    for (Integer i = 0; i < startIndex; i++) { itemArray.remove(0); }

    Integer remainingItemCount = endIndex - startIndex + 1;
    
    while (itemArray.size() > remainingItemCount) 
    {
      itemArray.remove(remainingItemCount);
    }
    return itemArray;
  }

}