#!/usr/bin/sbcl --script

;Varibles that are the same for setting up the cube with or without the partition
(defvar A)                                              ;mutlidimentional array
(defvar N 10.0)                                         ;maxsize
(defvar n 10)                                           ;maxsize integer
(defvar D 0.175)                                        ;diffusion coefficient
(defvar r 5.0)                                          ;room size in meters
(defvar s 250.0)                                        ;speed of gas molecule based on 100 g/mol gas at RT
(defvar timestep (/ r s N))                             ;basis for spatial stepsizes with respect to position in seconds
(defvar disblock (/ r N))                               ;is the distance between blocks
(defvar dterm (/ (* D timestep) (* disblock disblock))) ;
(defvar R 0.0)                                          ;the ratio of the min concentration/max concentration in A
(defvar tim 0.0)                                        ;keeps track of simulation time
(defvar change)                                         ;is the change of concentrations between blocks
(defvar sumval)                                         ;sum of the concentrations of every block in the cube
(defvar maxval)                                         ;block with the highest concentration
(defvar minval)                                         ;block with the lowest concentration

(setf A(make-array'(10 10 10)))

;sets the initial value for A to 0
(dotimes (i 10)
    (dotimes (j 10)
        (dotimes (k 10)
            (setf (aref A i j k) 0.0)
        )
    )
)

;sets the initial value
(setf (aref A 0 0 0) 1.0e21)

;prints the mutli array
;(dotimes (i 10)
;    (dotimes (j 10)
;        (dotimes (k 10)
;            (print (aref A i j k))
;            (write-line "string") ;\n affect after write-line
;        )
;    )
;)

;goes through each block of A(i,j,k) and compares the concentration (ratio) of every block next to it
;the change (change of concentration) between the ratios is subtracted from the original and added to the new, in order to show the concentration
;of the gas changes as time continues
(loop
    (dotimes (i 10)
        (dotimes (j 10)
            (dotimes (k 10)
                (if (>= (- i 1) 0)      ;checks if i-1 >= 0
                    (progn
                    (setf change (* dterm (- (aref A i j k) (aref A (- i 1) j k))))
                    (setf (aref A i j k) (- (aref A i j k) change))
                    (setf (aref A (- i 1) j k) (+ (aref A (- i 1) j k) change)))
                )
                (if (< (+ i 1) 10)      ;checks if i+1 < maxsize
                    (progn
                    (setf change (* dterm (- (aref A i j k) (aref A (+ i 1) j k))))
                    (setf (aref A i j k) (- (aref A i j k) change))
                    (setf (aref A (+ i 1) j k) (+ (aref A (+ i 1) j k) change)))
                )
                (if (< (+ j 1) 10)      ;checks if j+1 < maxsize
                    (progn
                    (setf change (* dterm (- (aref A i j k) (aref A i (+ j 1) k))))
                    (setf (aref A i j k) (- (aref A i j k) change))
                    (setf (aref A i (+ j 1) k) (+ (aref A i (+ j 1) k) change)))
                )
                (if (>= (- j 1) 0)      ;checks if j-1 >= 0
                    (progn
                    (setf change (* dterm (- (aref A i j k) (aref A i (- j 1) k))))
                    (setf (aref A i j k) (- (aref A i j k) change))
                    (setf (aref A i (- j 1) k) (+ (aref A i (- j 1) k) change)))
                )
                (if (>= (- k 1) 0)      ;checks if k-1 >= 0
                    (progn
                    (setf change (* dterm (- (aref A i j k) (aref A i j (- k 1)))))
                    (setf (aref A i j k) (- (aref A i j k) change))
                    (setf (aref A i j (- k 1)) (+ (aref A i j (- k 1)) change)))
                )
                (if (< (+ k 1) 10)      ;checks if k+1 < maxsize
                    (progn
                    (setf change (* dterm (- (aref A i j k) (aref A i j (+ k 1)))))
                    (setf (aref A i j k) (- (aref A i j k) change))
                    (setf (aref A i j (+ k 1)) (+ (aref A i j (+ k 1)) change)))
                )
            )
        )
    )
    (setf tim (+ tim timestep))     ;increments the simulation time
    
    ;check for mass consistency: to make sure that we are accounting for every molecule of gas, and that none of the gas goes outside the cube
    ;determines the new ratio after 1 step: divides the new min by the new max
    (setf sumval 0.0)               ;sets the sumval to 0.0
    (setf maxval (aref A 0 0 0))    ;sets the maxval to the value in A 0 0 0
    (setf minval (aref A 0 0 0))    ;sets the minval to the value in A 0 0 0
    (dotimes (i 10)
        (dotimes (k 10)
            (dotimes (j 10)
                (setf maxval (max (aref A i j k) maxval))       ;the max function returns the bigger of the 2 numbers and stores it in maxval
                (setf minval (min (aref A i j k) minval))       ;the min function returns the smaller of the 2 numbers and stores it in minval
                (setf sumval (+ sumval (aref A i j k)))
            )
        )
    )
    (setf R (/ minval maxval))  ;gets an updated ratio
    (format t "~F    ~F    ~e ~%" tim R sumval)
    (when (>= R 0.99) (return R))
)
(format t "Box equilibrated in ~f seconds of simulated time." tim)
