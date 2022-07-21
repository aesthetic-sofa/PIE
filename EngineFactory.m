classdef EngineFactory < handle
    %ENGINEFACTORY Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        
    end
    
    methods
        function obj = EngineFactory()
        end

        function engine = buildEngine(obj, cylindersNumber, piston_mass, conrod_mass, conrod_length,...
                conrod_cog_factor, crank_mass, crank_length, crank_angle, piston_variation_factor)
            engine=Engine();
            for i=1:cylindersNumber % PISTON MASS VARIATION FACTOR ENTERS HERE
                engine.addCylinder(piston_mass+piston_mass*piston_variation_factor*(-1+2*rand), conrod_mass, conrod_length,...
                conrod_cog_factor, crank_mass, crank_length, crank_angle(1,i));
            end
            engine.addBlock(cylindersNumber);
            engine.addMounts(cylindersNumber);
        end
    end
end

