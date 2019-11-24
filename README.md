# NanoXERA
The smallest working 8 bits CPU I've been able to do.

This is an experimental CPU, designed to use the minimum possible space in the fpga.

Does not use instruction decoders.

The opcode itself incorporates the signals for the CPU.

It includes addition and subtraction, also shift and logical operations.

Device utilization summary:
---------------------------

Selected Device : 6slx9tqg144-2 


Slice Logic Utilization: 

 Number of Slice Registers:              **26**  out of  11440     0%  
 Number of Slice LUTs:                   **83**  out of   5720     1%  

![](/RTL.png)

![](/RTL2.png)
