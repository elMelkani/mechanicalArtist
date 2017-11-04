# mechanicalArtist
A robotic arm that, when connected to a computer through an Arduino, can trace any image given to it as input. The arm has three Servo Motors attached to it giving it three angles as degrees of freedom. A MATLAB code pre-processes the chosen image and computes the values of angles for which the pen is to be up (or down). This computed information is fed to the Arduino through its Serial Port. The Arduino then moves the arm correspondingly.