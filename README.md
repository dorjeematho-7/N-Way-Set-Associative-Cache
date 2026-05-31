# N-Way-Set-Associative-Cache

# Introduction
**Date : 2026-05-31**  
  
Hello, after learning about Caches in ECE243, I would like to deepen my understanding in this topic by buildilng a Cache in Verilog. The Cache will be a parameterised, synthesisable N-way set-associative cache written in Verilog, that has LRU replacement, write-back with write-allocate and a victim cache for reduced conflict misses  

## Short Note

I will start this project off by making the simpler files first, that are mostly combinational logic and then progress to finally write the FSM as the final file. This order will allow for me to have a full understanding of each module before writing the FSM and wiring all of the modules together. I will also be using 32 bit memory address for possible future compatibility with my RISC V CPU

# Tag Comparator  
Using google docs, I will be making diagrams to list the output and inputs of each module as they are introduced


<img width="500" height="184" alt="image" src="https://github.com/user-attachments/assets/d068d573-2622-490c-90ef-ad7a71c002d7" />  

The logic for this module is simple, pass in the inputs, in a always_comb, check if  the tag bits are in any of the stored tags and if the bit is valid, and if there is a match and the bit is valid, then a hit has occured.  

