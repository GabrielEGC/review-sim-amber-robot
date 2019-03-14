# review-sim-amber-robot
A review and simulation of "First Steps Toward Underactuated Human-Inspired Bipedal Robotic Walking", paper from AMBER Lab

This repository contains the a review and a simulation of the paper “First Steps Toward Underactuated Human-Inspired Bipedal Robotic Walking” form Amber LAB, https://ieeexplore.ieee.org/document/6225360.

Main code is in folder "Model", aditional but required functions are in "Functions". Read pdf for more details.

AMBER robot has 5 links, 2 legs, 2 shanks and the torso, and it's actuated at boths hips and both knees. It's an underactuated robot.

In the paper, they collect data from angles of people walking, make some affine transformations and apply optimization in order to make regression to the new variables. They have the form:

<p align="center">
<img src="graphics/track.png">
</p>

But here comes the difference from classic tracking. Let *y<sub>a</sub>(t)* be the vector containing the variables of the system, and *y<sub>d</sub>(t)* the desired vector function obtained by regression on *y<sub>H</sub>(t)* (only last 4 trajectories). The control law doesn't exactly drive the error between *y<sub>a</sub>(t)* and *y<sub>d</sub>(t)* obtained by regression, but the law control wants to drive the following error function to *0*.

<p align="center">
<img src="graphics/Output.png">
</p>

Where:

<p align="center">
<img src="graphics/tau.png">
</p>

They do this based in the fact that the position of the hip seems to evolve linear with time, with constant velocity *v<sub>hip</sub>*. The position of the hip is independent of the 4 variables tracked, so this corresponds to the Zero Dynamics. There is no guarantee that the Zero Dynamics will behave linearly and growing, so in order to force this, an optimization in the regression is performed, imposing conditions that define a hybrid limit cycle under collision.


<p align="center">
<img src="graphics/optimiz.png">
</p>

This optimization ensures the existence and stability of the hybrid limit cycle, ensures that the position of the hip will grow, although it doesn't force exactly that the position must grow linearly. But it ensures the hybrid limit cycle, so underactuated walking is achieved.

<p align="center">
<img src="graphics/AMBERwalk.gif">
</p>

However, the hip position in the simulation finally appears to grow linearly. This, in fact, is possible because the system behaves like an inverted pendulum with initial velocity *v<sub>hip</sub>* on the hip (this is part of the second restriction), but the global center of mass is close to the vertical line, so the torque applied at the ankle by gravity is almost *0*, and the velocity remains almost constant.

<p align="center">
<img src="graphics/Hipposit.png">
</p>

From this, we can compute the approximate value of *tau*:

<p align="center">
<img src="graphics/tauus.png">
</p>

Ideally we will have 1.8743 be just 1, but we have a great difference mainly because we estimate the values of lengths, masses and inertias through Zatsiorsky-Leyva parameters (Paper doesn't provide exact values used in optimization).

<p align="center">
<img src="graphics/Error_y.png">
</p>

Ideally, with the correct physical parameters of the robot for which the optimization was performed, we will have a permanent *y=0*, 0 error. This is because the optimization forces that if the system is in the Zero Dynamics surface, it will be mapped again to the Zero Dynamics ater a collision, implying that *y=0* at the beggining. We are no using the exact values, so we don't have permanente *y=0*, but it is still a good performance.

This is really amazing given the fact that, if you want to track directly the angles *𝑦<sub>d</sub>(t)*, you will only obtain a falling robot, so tracking the "human-inspired output" is useful in this case.
