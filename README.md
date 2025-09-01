Project 0 Getting Started
====================

**University of Pennsylvania, CIS 5650: GPU Programming and Architecture, Project 0**

* Aaron Jiang
  * [LinkedIn](https://www.linkedin.com/in/aaronpjiang/), [personal website](https://aaron-jiang.com/)
* Tested on: Windows 11, i5-13420H @ 1.99GHz 15.6GB, GTX 4050 13.8MB (Personal Computer)

### GPU Setup Documentation

I confirmed that my personal machine is capable of running CUDA projects. The Compute Capability of my personal laptop is **8.9**  

#### 2.1.2  
My machine successfully runs cuda-gl-check and produces this image output.  
![](images/Screenshot%202025-08-29%20162758.png)  

#### 2.1.3  
I was able to use the Nsight debugger to control which thread to view in debug mode. 
![](images/Screenshot%202025-08-29%20184157.png)  

#### 2.1.4  
I was also able to produce a report using Nsight Systems on statistics of cuda-gl-check.  
![](images/Screenshot%202025-08-29%20194907.png)

#### 2.1.5  
I was not able to use Nsight Compute, running into the error found in the pinned message on Ed, linked [here](https://edstem.org/us/courses/81464/discussion/6880884), of an unknown error occuring.  
![](images/Screenshot%202025-08-29%20232639.png)

#### 2.2   
My browser is capable of running both WebGL1 and WebGL2.  
![](images/Screenshot%202025-08-29%20232804.png)  
![](images/Screenshot%202025-08-29%20232927.png)  

#### 2.3   
And it was also capable of running WebGPU.  
![](images/Screenshot%202025-08-29%20233005.png)  