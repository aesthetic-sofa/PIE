classdef Crank
    %CRANK Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        mass
        length
    end
    
    methods
        function obj = Crank(mass,length)
            %CRANK Construct an instance of this class
            %   Detailed explanation goes here
            obj.mass = mass;
            obj.length = length;
        end
    end
end

