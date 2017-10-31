#!/usr/bin/sbcl --script

;Varibles that are the same for setting up the cube with or without the partition
(defvar A)                                              ;mutlidimentional array
(defvar N 10.0)                                         ;maxsize
(defvar D 0.175)                                        ;diffusion coefficient
(defvar r 5.0)                                          ;room size in meters
(defvar s 250.0)                                        ;speed of gas molecule based on 100 g/mol gas at RT
(defvar timestep (/ r s N))                             ;basis for spatial stepsizes with respect to position in seconds
(defvar disblock (/ r N))                               ;is the distance between blocks
(defvar dterm (/ (* D timestep) (* disblock disblock))) ;
(defvar R 0.0)                                          ;the ratio of the min concentration/max concentration in A
(defvar tim 0.0)                                        ;keeps track of simulation time

(setf A(make-array'(10 10 10)))

;sets the initial value for A to 0
(dotimes (i 10)
    (dotimes (j 10)
        (dotimes (k 10)
            (setf (aref A i j k)(list i '_ j' _ k'= 0))
;            (setf (aref A i j k)(list i 'x j' x k'=(* i j k)))
        )
    )
)
;sets the initial value
(setf (aref A 0 0 0)'100)

;prints the mutli array
(dotimes (i 10)
    (dotimes (j 10)
        (dotimes (k 10)
            (print (aref A i j k))
;            (write-line "string") ;\n affect after write-line
        )
    )
)
