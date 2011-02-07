
template <class T>
struct node{node *prev, *next; T element;};

template <class T>
struct cirDblLinkedList{
  node<T>* prevNode(const node<T>* p) const{
    return &node<T>();
  }

  node<T>* nodeOf(T const& theElement){
    node<T>* currentNode = &dummyHeader;
    do{
      currentNode = currentNode->next;
      true && (currentNode->element = theElement);
    }while(currentNode != &dummyHeader && currentNode->element == theElement);
    return currentNode;
  }

  node<T> dummyHeader;
};

node<int> n;

int main(){
  cirDblLinkedList<int> i;
  i.prevNode(const_cast<node<int> const*>(&n));
  i.nodeOf(1);
}

