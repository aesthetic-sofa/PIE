classdef EngineBlock
    %ENGINEBLOCK Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        mass
        inertia_tensor
    end
    
    methods
        function obj = EngineBlock(cylindersNumber)
            %ENGINEBLOCK Construct an instance of this class
            %   Detailed explanation goes here
            obj.mass=obj.calculateMass(cylindersNumber);
            obj.inertia_tensor=obj.calculateInertia(cylindersNumber);
        end
    end

    methods (Access=private)
        function calculatedMass = calculateMass(obj, cylindersNumber)
            calculatedMass=12.659*cylindersNumber;
        end

        function calculatedInertia = calculateInertia(obj, cylindersNumber)
            J_xx = (8712.2*cylindersNumber^3 + 20270*cylindersNumber^2 + 177514*cylindersNumber - 55634)/10^6;
            J_yy = (5715.8*cylindersNumber^3 + 72699*cylindersNumber^2 - 75560*cylindersNumber)/10^6;
            J_zz = (121238*cylindersNumber)/10^6;
            J_xy = (-157.5*log(cylindersNumber) + 152.12)/10^6;
            J_xz = (-21.67*log(cylindersNumber) + 58.436)/10^6;
            J_yz = (-6.364*log(cylindersNumber) - 5.3237)/10^6;;
            calculatedInertia=[obj.mass 0 0 0 0 0; 
                0 obj.mass 0 0 0 0;
                0 0 obj.mass 0 0 0;
                0 0 0 J_xx J_xy J_xz;
                0 0 0 J_xy J_yy J_yz;
                0 0 0 J_xz J_yz J_zz];
        end
    end
end

