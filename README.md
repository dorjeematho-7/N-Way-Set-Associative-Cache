# N-Way-Set-Associative-Cache

# Introduction
**Date : 2026-05-31**  
  
Hello, after learning about Caches in ECE243, I would like to deepen my understanding in this topic by buildilng a N-Way Set Associattive Cache in Verilog. The Cache will be a parameterised, synthesisable N-way set-associative cache written in Verilog, that has LRU replacement, write-back with write-allocate and a victim cache for reduced conflict misses  
# Defining the structure
The Cache shall have...  

**Tag**: Bits uniquely identifies the memory block.  
**Set Number**: bits that identify the set number  
**Byte Number**: bits that determine the byte in the line    
**Valid bit**: bit that idenfities a valid data access  
**Dirty Bit**: bit that identifies if a piece of data has been changed  
Thus I am assuming that the memory is byte addressable.  


