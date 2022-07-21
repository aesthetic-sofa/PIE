classdef Dyno < handle
    %DYNO Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        omega_start
        omega_finish
        time
        alpha
        omega
        theta
        engine
        time_step=0.0001;
    end
    
    methods
        function obj = Dyno(omega_start,omega_finish,max_time,engine)
            %DYNO Construct an instance of this class
            %   Detailed explanation goes here
            obj.omega_start=omega_start;
            obj.omega_finish=omega_finish;
            obj.alpha=(obj.omega_finish-obj.omega_start)/max_time;
            obj.time=(0:obj.time_step:max_time);
            obj.engine=engine;
            obj.omega=obj.omega_start+obj.alpha.*obj.time;
            obj.theta=obj.omega_start.*obj.time+0.5*obj.alpha.*obj.time.*obj.time;
        end

        function forcingMeasurement = forcingMeasurement(obj)
            forcingMeasurement=zeros(4, 0);
            for i=1:length(obj.omega)
                forcingMeasurement=[forcingMeasurement(1,:) obj.engine.radial_force_y(obj.theta(i), obj.omega(i));...
                    forcingMeasurement(2,:) obj.engine.radial_force_z(obj.theta(i), obj.omega(i));...
                    forcingMeasurement(3,:) obj.engine.reciprocating_force(obj.theta(i), obj.omega(i));...
                    forcingMeasurement(4,:) obj.engine.shaking_moment(obj.theta(i), obj.omega(i))];
            end
        end

        function fullForcingMeasurement = fullForcingMeasurement(obj)
            fullForcingMeasurement=zeros(6, 0); %DUMMY MATRIX, REPLACE!!!
            for i=1:length(obj.omega)
                fullForcingMeasurement=[fullForcingMeasurement(1,:) 0;...
                    fullForcingMeasurement(2,:) obj.engine.radial_force_y(obj.theta(i), obj.omega(i));...
                    fullForcingMeasurement(3,:) obj.engine.radial_force_z(obj.theta(i), obj.omega(i))+obj.engine.reciprocating_force(obj.theta(i), obj.omega(i));...
                    fullForcingMeasurement(4,:) obj.engine.shaking_moment(obj.theta(i), obj.omega(i));...
                    fullForcingMeasurement(5,:) obj.engine.moment_y(obj.theta(i), obj.omega(i));...
                    fullForcingMeasurement(6,:) obj.engine.moment_z(obj.theta(i), obj.omega(i))];
            end
        end

        function modes = findModes(obj, K, I) %Outputs orthonormal modes.
            [modes, omegaSq] = eig(K, I);
            modes=-modes;
        end

        function omega_n = findOmega_n(obj, K, I) %Outputs natural frequencies of the system.
            [modes, omegaSq] = eig(K, I);
            omega_n = sqrt(diag(omegaSq));
        end

        function normalizedInertia = normalizeInertia(obj, modes, I)
            normalizedInertia=modes'*I*modes;
        end

        function normalizedStiffness = normalizeStiffness(obj, modes, K)
            normalizedStiffness=modes'*K*modes;
        end

        function normalizedDamping = normalizeDamping(obj, modes, C)
            normalizedDamping=modes'*C*modes;
        end

        function normalizedForces = normalizeForces(obj, modes, F)
            normalizedForces=modes'*F;
        end

        function zeta = proportionalDamping(obj, damping, stiffness, omega_n)
            beta=damping/stiffness;
            zeta=(beta.*omega_n)/2;
        end

        function omega_d = omegaDamped(obj, omega_n, zeta)
            omega_d = omega_n.*sqrt(1 - zeta.^2);
        end

        function impulse = calculateImpulse(obj, zeta, omega_n)
%             tau = 1 ./ (omega_n.*zeta);
            omega_d=obj.omegaDamped(omega_n, zeta);
            impulse = exp(-zeta.*omega_n.*obj.time).*sin(omega_d*obj.time);
        end

        function timeResponse = timeResponse(obj, omega_d, modes, normalizedForces, impulse)
            q = zeros(6, length(obj.time)*2-1);
            for i = 1:1:6
                temp = conv(normalizedForces(i, :), impulse(i, :))*obj.time(2);
                q(i, :) = 1/omega_d(i) * temp;
            end

            timeResponseDoubled = modes*q;
            timeResponse=zeros(6, round(length(timeResponseDoubled(1,:))/2));
            for j=1:6
                for i=1:round(length(timeResponseDoubled(1,:))/2)
                    timeResponse(j,i)=timeResponseDoubled(j,i);
                end
            end
        end

        function displacementAndAngles = displacementAndAngles(obj)
            modes=obj.findModes(obj.engine.mounts.k, obj.engine.block.inertia_tensor);
            omega_n=obj.findOmega_n(obj.engine.mounts.k, obj.engine.block.inertia_tensor);
            normalizedInertia=obj.normalizeInertia(modes, obj.engine.block.inertia_tensor);
            normalizedStiffness=obj.normalizeStiffness(modes, obj.engine.mounts.k);
            normalizedDamping=obj.normalizeDamping(modes, obj.engine.mounts.c);
            zeta = obj.proportionalDamping(obj.engine.mounts.damping, obj.engine.mounts.stiffness, omega_n);
            omega_d = obj.omegaDamped(omega_n, zeta);
            impulse = obj.calculateImpulse(zeta, omega_n);
            normalizedForces = obj.normalizeForces(modes, obj.fullForcingMeasurement());
            displacementAndAngles = obj.timeResponse(omega_d, modes, normalizedForces, impulse);
        end

        function transmittedForcesAndMoments = transmittedForcesAndMoments(obj, displacementAndAngles)
            derivatives=zeros(6, length(displacementAndAngles));
            doubleDerivatives=zeros(6, length(displacementAndAngles));
            for i=1:6
                derivatives(i, :)=gradient(displacementAndAngles(i,:))./gradient(obj.time);
                doubleDerivatives(i, :)=gradient(derivatives(i, :))./gradient(obj.time);
            end
            transmittedForcesAndMoments=obj.engine.mounts.c*derivatives+obj.engine.mounts.k*displacementAndAngles;
        end

        function inertiaForces = inertiaForces(obj, displacementAndAngles)
            derivatives=zeros(6, length(displacementAndAngles));
            doubleDerivatives=zeros(6, length(displacementAndAngles));
            for i=1:6
                derivatives(i, :)=gradient(displacementAndAngles(i,:))./gradient(obj.time);
                doubleDerivatives(i, :)=gradient(derivatives(i, :))./gradient(obj.time);
            end
            inertiaForces=obj.engine.block.inertia_tensor*doubleDerivatives;
        end
    end
end

