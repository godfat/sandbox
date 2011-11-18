
module OO(Set) where

data Set = Set{
  klass    :: Set -> String     ,
  isEmpty  :: Set -> Bool
  --insert   :: Set -> Int -> Set ,
  --union    :: Set -> Set -> Set ,
  --contains :: Set -> Int -> Bool}
}

empty = Set{
  klass   = \x -> "Empty",
  isEmpty = \x -> True
}
