Project 0 Getting Started
====================

**University of Pennsylvania, CIS 5650: GPU Programming and Architecture, Project 0**

* Calvin Lieu
  * [LinkedIn](www.linkedin.com/in/calvin-lieu-91912927b)
* Tested on: Windows 11, i5-13450HX @ 2.40GHz 16GB, NVIDIA GeForce RTX 5050 Laptop GPU 8GB (Personal)

### 

Installing all the tools I need for GPU programming using an unfamiliar interface was certainly tricky! This was my first time setting up my own Windows system and first time using Visual Studio so this setup took a lot longer than expected. Thankfully everything seems to be working as expected. Proof below :)

---

### CUDA project edit
![Name Change](images/1-main-rename.png)  
*First time editing a CUDA project.*

---

### Nsight CUDA debugging
![Thread Match](images/2-matched-thread-break.png)  
*Breakpoint hit on a matched thread.*

![Thread ID](images/3-thread-ids.png)  
*The matching thread's info in locals tab.*

The Nsight debugging tool looks like it will be very useful in identifying bugs in specific threads.

---

### Nsight Systems profiling
![Nsight Sys](images/4-nsight-sys.png)  
*Nsight Systems timeline.*

![Nsight Sys Report](images/5-nsight-sys-rep.png)  
*Summary report.*

The Nsight Systems tool will be essential for optimizing code and ensuring efficient scaling with its detailed metrics and visualisations.

---

### Web graphics capability
![WebGL](images/6-webgl-rep.png)  
*WebGL compatibility report.*

![WebGPU](images/7-webgpu-rep.png)  
*WebGPU compatibility report.*

My system is compatible with both WebGL and WebGPU—happy days.


