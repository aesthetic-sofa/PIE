classdef Conrod
    %CONROD Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        mass
        length
        cog_factor
        J_conrod
        J_0
        mass_a
        mass_b
    end
    
    methods
        function obj = Conrod(mass,length,cog_factor)
            %CONROD Construct an instance of this class
            %   Detailed explanation goes here
            obj.mass=mass;
            obj.length=length;
            obj.cog_factor=cog_factor;

            %We calculate the moments of inertia and store the data
            obj.J_conrod=(obj.mass*obj.length^2)/12+obj.mass*((obj.length/2)-(obj.length/obj.cog_factor))^2;
            obj.J_0=obj.J_conrod-obj.mass*(obj.length/obj.cog_factor)*(obj.length-obj.length/obj.cog_factor);

            %We calculate the substitution masses
            obj.mass_b=obj.mass/obj.cog_factor;
            obj.mass_a=obj.mass-obj.mass_b;
        end
    end
end