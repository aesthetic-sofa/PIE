classdef Engine < handle
    %ENGINE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        cylinders
        block
        mounts
        cylinder_diameter = 0.10;
    end
    
    methods
        function obj = Engine()
            %ENGINE Construct an instance of this class
            %   Detailed explanation goes here
            obj.cylinders=Cylinder.empty;
        end
        
        function obj=addCylinder(obj, piston_mass, conrod_mass, conrod_length,...
                conrod_cog_factor, crank_mass, crank_length, crank_angle)
            obj.cylinders=[obj.cylinders Cylinder(piston_mass, conrod_mass, conrod_length,...
                conrod_cog_factor, crank_mass, crank_length, crank_angle)];
        end

        function obj=addBlock(obj, cylindersNumber)
            obj.block=EngineBlock(cylindersNumber);
        end

        function obj=addMounts(obj, cylindersNumber)
            obj.mounts=EngineMounts(cylindersNumber*obj.cylinder_diameter, 0.4);
        end

        function radial_force_y = radial_force_y(obj, theta, omega)
            radial_force_y=0;
            for i=1:length(obj.cylinders)
                radial_force_y=radial_force_y+obj.cylinders(1,i).radial_force_y(theta, omega);
            end
        end

        function radial_force_z = radial_force_z(obj, theta, omega)
            radial_force_z=0;
            for i=1:length(obj.cylinders)
                radial_force_z=radial_force_z+obj.cylinders(1,i).radial_force_z(theta, omega);
            end
        end

        function reciprocating_force = reciprocating_force(obj, theta, omega)
            reciprocating_force=0;
            for i=1:length(obj.cylinders)
                reciprocating_force=reciprocating_force+obj.cylinders(1,i).reciprocating_force(theta, omega);
            end
        end

        function shaking_moment = shaking_moment(obj, theta, omega)
            shaking_moment=0;
            for i=1:length(obj.cylinders)
                shaking_moment=shaking_moment+obj.cylinders(1,i).shaking_moment(theta, omega);
            end
        end

        function moment_y = moment_y(obj, theta, omega)
            %We verify if the number of cylinders is even or odd.
%             offset=0;
%             if(mod(length(obj.cylinders), 2)==0)
%                 offset=obj.cylinder_diameter/2;
%             else
%                 offset=0;
%             end

            moment_y=0;
            offset=0;
            for i=1:length(obj.cylinders)
%                 if(i<ceil(length(obj.cylinders)/2) && i~=0)
%                     offset=-obj.cylinder_diameter/2;
%                 elseif (i~=0)
%                     offset=obj.cylinder_diameter/2;
%                 end
                if i<ceil(length(obj.cylinders)/2)
                    offset=-obj.cylinder_diameter/2;
                end
                if i>ceil(length(obj.cylinders)/2)
                    offset=obj.cylinder_diameter/2;
                end
                if mod(length(obj.cylinders), 2)~=0
                    offset=0;
                end

                moment_y=moment_y+((obj.cylinders(1,i).radial_force_z(theta, omega)+obj.cylinders(1,i).reciprocating_force(theta, omega))*(((i-((length(obj.cylinders)/2)+0.5))*obj.cylinder_diameter)));
            end
        end

        function moment_z = moment_z(obj, theta, omega)
            %We verify if the number of cylinders is even or odd.
%             offset=0;
%             if(mod(length(obj.cylinders), 2)==0)
%                 offset=obj.cylinder_diameter/2;
%             else
%                 offset=0;
%             end

            moment_z=0;
            offset=0;
            for i=1:length(obj.cylinders)
%                 if(i<ceil(length(obj.cylinders)/2) && i~=0)
%                     offset=-obj.cylinder_diameter/2;
%                 elseif (i~=0)
%                     offset=obj.cylinder_diameter/2;
%                 end
                if i<ceil(length(obj.cylinders)/2)
                    offset=-obj.cylinder_diameter/2;
                end
                if i>ceil(length(obj.cylinders)/2)
                    offset=obj.cylinder_diameter/2;
                end
                if mod(length(obj.cylinders), 2)~=0
                    offset=0;
                end
                
                moment_z=moment_z+((obj.cylinders(1,i).radial_force_y(theta, omega))*(((i-((length(obj.cylinders)/2)+0.5))*obj.cylinder_diameter)));
            end
        end
    end
end

