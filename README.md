# PIE
A simple parametric simulator for inline engines

# Abstract
This study’s objective is the definition of the response of an inline-six engine under the forcing 
of its own inertial forces, produced by the crank and slider mechanism present in each cylinder 
of the engine. To do so, a theoretical model of the forcing action and of the engine mounts is 
developed, and its numerical implementation is performed in MATLAB.
Additionally, in order to further expand the scope of the study and provide tools for future 
works on the same matter, a parametric and modular system of classes is developed, allowing 
for studies on any engine characterized by an inline configuration, given a set of arbitrary 
parameters through a purpose-built graphic user interface.
Finally, testing of the model is carried out both in steady forcing conditions and over speed 
ramps, highlighting the amplitude and frequency of the response of the system by analysing the 
time domain and spectra of the resulting signals, both in the case of an ideal engine and of an 
engine built with real dimensional tolerances.
