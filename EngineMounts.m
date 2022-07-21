classdef EngineMounts
    %ENGINEMOUNTS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        stiffness = 156666.7;
        damping = 158.4158;
        k;
        c;
        d_yz;
        d_xz;
        d_xy;
    end
    
    methods
        function obj = EngineMounts(engineLength, engineWidth)
            %ENGINEMOUNTS Construct an instance of this class
            %   Detailed explanation goes here
            obj.d_xy=sqrt(0.25*(engineLength^2+engineWidth^2));
            obj.d_xz=engineLength/2;
            obj.d_yz=engineWidth/2;
            obj.k=obj.calculateStiffnessMatrix();
            obj.c=obj.calculateDampingMatrix();
        end
    end
    methods (Access=private)
        function k_matrix = calculateStiffnessMatrix(obj)
            k_matrix = [4*obj.stiffness 0 0 0 -4*obj.stiffness*obj.d_xz 0
                0 4*obj.stiffness 0 4*obj.stiffness*obj.d_yz 0 0
                0 0 4*obj.stiffness 0 0 0
                0 4*obj.stiffness*obj.d_yz 0 8*obj.stiffness*obj.d_yz^2 0 0
                -4*obj.stiffness*obj.d_xz 0 0 0 8*obj.stiffness*obj.d_xz^2 0
                0 0 0 0 0 8*obj.stiffness*obj.d_xy^2];
        end

        function c_matrix = calculateDampingMatrix(obj)
            c_matrix = [4*obj.damping 0 0 0 -4*obj.damping*obj.d_xz 0
                0 4*obj.damping 0 4*obj.damping*obj.d_yz 0 0
                0 0 4*obj.damping 0 0 0
                0 4*obj.damping*obj.d_yz 0 8*obj.damping*obj.d_yz^2 0 0
                -4*obj.damping*obj.d_xz 0 0 0 8*obj.damping*obj.d_xz^2 0
                0 0 0 0 0 8*obj.damping*obj.d_xy^2];
        end
    end
end

