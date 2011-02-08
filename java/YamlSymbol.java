
import org.yaml.snakeyaml.*;

class YamlSymbol{
  public static void main(String[] args){
    Yaml yaml = new Yaml();
    String document = "order: [ :year, :month, :day ]";
    System.out.println(yaml.load(document));
  }
}
