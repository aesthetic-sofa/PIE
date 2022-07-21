classdef Cylinder
    %CYLINDER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        piston
        conrod
        crank
        crank_angle
        lambda
    end
    
    methods
        function obj = Cylinder(piston_mass, conrod_mass, conrod_length,...
                conrod_cog_factor, crank_mass, crank_length, crank_angle)
            %CYLINDER Construct an instance of this class
            %   Detailed explanation goes here
            obj.piston=Piston(piston_mass);
            obj.conrod=Conrod(conrod_mass, conrod_length, conrod_cog_factor);
            obj.crank=Crank(crank_mass, crank_length);
            obj.lambda=obj.crank.length/obj.conrod.length;
            obj.crank_angle=crank_angle;
        end

        function radial_force_y = radial_force_y(obj, theta, omega)
            radial_force=(obj.crank.mass*obj.crank.length/2)*omega*omega+obj.conrod.mass_a*obj.crank.length*omega*omega;
            radial_force_y=sin(theta+obj.crank_angle)*radial_force;
        end

        function radial_force_z = radial_force_z(obj, theta, omega)
            radial_force=(obj.crank.mass*obj.crank.length/2)*omega*omega+obj.conrod.mass_a*obj.crank.length*omega*omega;
            radial_force_z=cos(theta+obj.crank_angle)*radial_force;
        end

        function reciprocating_force = reciprocating_force(obj, theta, omega)
            reciprocating_force=(obj.piston.mass+obj.conrod.mass_b)*obj.crank.length*omega^2*(cos(theta+obj.crank_angle)-obj.crank.length*((obj.conrod.length^2-2*obj.conrod.length^2*cos(theta+obj.crank_angle)^2-obj.crank.length^2*sin(theta+obj.crank_angle)^4)/(obj.conrod.length^2-obj.crank.length^2*sin(theta+obj.crank_angle)^2)^(3/2)));
        end

        function shaking_moment = shaking_moment(obj, theta, omega)
            shaking_moment=obj.conrod.J_0*(2*sqrt(2)*obj.lambda*(obj.lambda^2-1)*omega^2*sin(theta+obj.crank_angle))./(-obj.lambda^2+obj.lambda^2.*cos(2*theta+obj.crank_angle)+2)^(3/2);
        end
    end
end

