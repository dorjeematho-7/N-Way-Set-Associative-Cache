

# Introduction
**Date : 2026-05-31**  
  
Hello, after learning about Caches in ECE243, I would like to deepen my understanding in this topic by building a Cache in Verilog. The Cache will be a parameterised, synthesisable N-way set-associative cache written in Verilog, that has LRU replacement, write-back with write-allocate and a victim cache for reduced conflict misses  

## Short Note

I will start this project off by making the simpler files first, that are mostly combinational logic and then progress to finally write the FSM as the final file. This order will allow for me to have a full understanding of each module before writing the FSM and wiring all of the modules together. I will also be using 32 bit memory address for possible future compatibility with my RISC V CPU



      
# DOCUMENT STRUCTURE  
**I will introduce each module, show the inputs and outputs with comments, and then at the end display a big diagram showing how all the parts work together**  

# Tag Comparator Module (tag_comparator.sv)
Using google docs, I will be making diagrams to list the output and inputs of each module as they are introduced


<img width="500" height="184" alt="image" src="https://github.com/user-attachments/assets/d068d573-2622-490c-90ef-ad7a71c002d7" />  

The logic for this module is simple, pass in the inputs, in a always_comb, check if  the tag bits are in any of the stored tags and if the bit is valid, and if there is a match and the valid bit is 1, then a hit has occured.  

# Data Store Module  (data_store.sv)
This is the module responsible for holding the data in the cache lines. For every cache line in every set, the data_store must maintain:  
  
**Data Block**: The actual contents of the memory (the "payload").  
**Tag**: The identifier stored for that line so you can compare it later.  
**Valid Bit**: Tells the hardware if the data in this line is "real" or just uninitialized junk.  
**Dirty Bit**: Tells the cache controller if you have modified this data since it was fetched from main memory. If this is 1, you must write it back to memory before overwriting the line.  
<img width="600" height="184" alt="image" src="https://github.com/user-attachments/assets/7258cdb4-0086-4ebb-b1c0-846dc52baa1a" />


I also want to note that I am going to be using tags_in for read operations and way_indx for write operations on cache misses. Furthermore, I did not include a wr_valid because I assumed that on every write, the valid bit is 1, and so it will be hardcoded to 1 in the module  

# LRU Tracker (lru_tracker.sv)

My original plan for this module was to have a input array and a input most recently accessed way input and then have the correct outputted array that shows the least recently used way in a set, but this approach is not optimal because then we have to find a way to store input and output array somewhere, the most likely location would be data_store, but then it would take away the main purpoose of that module as its purpose is to store the cache line data. After a hour of brainstorming I decided it was much better just to store one array in the LRU_tracker module and then have the cache controller FSM brain send details on what was most recently edited and have the array change and update inside the module and then output the victim way and set index

<img width="600" height="184" alt="image" src="https://github.com/user-attachments/assets/8542afb3-517c-4eda-b845-c63a94d2ae2f" />

# MAIN MEMORY (mem_model.sv)

This will simply be the model for the main memory in this project, as the cpu needs something to request data from and to write too, perhaps I will later connect my RISC V CPU to this cache project, who knows though. Anyways, The inputs and outputs are as follows.  
<img width="500" height="154" alt="image" src="https://github.com/user-attachments/assets/92ac63c6-cb54-41b6-9598-713480a62f08" />

since retrieving data from the main memory takes many cycles, I added a mem_ready flag to tell the cache controller when the main memory is ready to send the requested data

note: since this module is not apart of the cache and is just used for testing, a good chunk of the logic was not written by me, but instead reviewed. This only stands for this module.

# FSM Diagram
Alright, before writing the FSM logic, I like to make state diagrams to have my thoughts down on a page, here is the FSM diagram I drew

<img width="700" height="500" alt="image" src="https://github.com/user-attachments/assets/1bf3052d-9d2b-4af3-a4ae-ae4fa0f86e9a" />



