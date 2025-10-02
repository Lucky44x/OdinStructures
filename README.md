## OdinStructures

This is just a small library I made for my Odin-Projects
It contains the following Structures:
  - Pool
  - Queue
  - Registry
  - Stack

The Registry acts like a Map of Pointers, useful when working with Resource like Raylibs Texture2D etc...

The Pool and Registry also require both a constructor and destructor method, which will define how an "Entry" is created and how it is "Disposed of". Memory safety is for the user to consider as these are only the Data Types used to store the data
