
str =
'dogs:
     - name        : Fido
       age         : 2

     - name        : Rufus

     - name        : Doggie
       age         : 4

     - name        : Puppy
       age         : 1'

require 'ostruct'

os = OpenStruct.new
def os.load_from_file(str)
  require 'yaml'
  YAML::load(str)['dogs'].inject([]){ |result_dogs, dog_attr|
    result_dogs << dog_attr.inject(self.class.new){ |new_dog, attr|
      new_dog.__send__ "#{attr[0]}=", attr[1]
      new_dog
    }
  }
end

require 'pp'
pp os.load_from_file(str)
