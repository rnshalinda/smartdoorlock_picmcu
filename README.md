# Smart door lock security system using PIC Microcontroller 

## Fully functional EXAMPLE code with proteus simulations of a keypad accessed security system for hotel rooms

There are so many types of security systems present today but behind the scene, for authentication, they all rely on Fingerprint, Retina Scanner, Face ID, RFID Reader, Password, Pin, Patterns etc. Out Of all the solutions the low-cost one is to use a password or pin-based system.

This project showcases two methods to use a functional keypad accessed security system for hotel rooms, implemented using a PIC microcontroller and programmed in C,C++. The system provides a cost-effective solution for room authentication, using a password or pin-based system. 
* Please refer 'source code' & 'source code 2' folders


## Used software:

This project is developed using mikroC PRO V7.2.0 for programming the PIC microcontroller, and Proteus V8.0 for simulation purposes.



## Instructions for Running the Simulation: 

1. Please install the above mentioned softwares.

2. Open the 'Auto_door_lock.pdsprj' file in Proteus and click 'Play' to start the simulation.

3. If the simulation does not work, reallocate the .HEX files as follows:

    * Double click and open the PIC16F877A component in the Proteus simulation.
    * Set processor clock frequency to 8MHz.
    * Under the program file, select the 'Door_lock.hex' or 'door_lock2.hex' file located in the source code folders.
    * Repeat the same process for the TOUCH SENSOR by adding the 'TouchSensorTEP.HEX' file in the provided sensor library folder.

4. Keypad correct password '1234'.

5. Any incorrect attempt will display 'Access Denied'.

6. The system LCD will go to sleep after a couple of seconds if no input is given.

Additional instructions and information about the system specifications are provided with 'SystemProposal.pdf' document located in instructions folder.



## How to tweak this project for your own uses:

To customize this project for your specific needs, follow these steps:

1. Clone the project repository and rename it to reflect your purpose.

2. Ensure you have mikroC PRO V7.2.0 installed on your system.

3. Open source code folder and use mikroC PRO V7.2.0 to open the 'Door_lock.mcppi' file in the cloned project.

4. Customize the code according to your preferences by editing the 'Door_lock.mcppi' file.

5. In mikroC PRO V7.2.0, add the following libraries from the library manager:
    * Conversions
    * C_Math
    * C_String
    * Keypad 4by4
    * Lcd
    * PWM

6. Compile the modified code, ensuring there are no errors. Test the project on your hardware or in a simulation environment.

7. Update the README file to provide a brief overview of your modifications.

Feel free to experiment and adapt the project to suit your unique requirements. If you need help, refer to the project documentation or seek assistance from relevant communities.


## Known errors:
* Potential software compatibility issues may require code adjustments.
* IRP bit configuration may be necessary, but it did not cause any problems in my setup.
* Problems with LCD character display may be related to the IRP bit issue.

## Support and Feedback

⭐️ [Leave a Star](https://github.com/rnshalinda/smartdoorlock_picmcu) : leaving a star on the GitHub repository would mean a lot to me.

Happy customization!
