
public class Co{
  public static void main(String[] args){
    Human h1 = new Human(), h2 = new Mutant();
    h1.touch(new Mutant());
    h2.touch(new Mutant());
  }
}

class Human{
  public Human touch(Mutant m){
    System.out.println("Human touch mutant");
    return m;
  }
}

class Mutant extends Human{
  @Override
  public Mutant touch(Human m){
    System.out.println("Mutant touch human");
    return this;
  }
}
