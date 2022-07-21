classdef parametric_inline_engine_simulator < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        ParametricInlineEngineSimulatorUIFigure  matlab.ui.Figure
        GridLayout                      matlab.ui.container.GridLayout
        LeftPanel                       matlab.ui.container.Panel
        CrankshafteccentricitySlider    matlab.ui.control.Slider
        CrankshafteccentricityLabel     matlab.ui.control.Label
        ConstantrpmButton               matlab.ui.control.StateButton
        RunButton                       matlab.ui.control.Button
        PistonmassvariationSlider       matlab.ui.control.Slider
        PistonmassvariationSliderLabel  matlab.ui.control.Label
        DefectsLabel                    matlab.ui.control.Label
        CylindersnumberSpinner          matlab.ui.control.Spinner
        CylindersnumberSpinnerLabel     matlab.ui.control.Label
        TestingtimesSlider              matlab.ui.control.Slider
        TestingtimesSliderLabel         matlab.ui.control.Label
        CrankanglesdegEditField         matlab.ui.control.EditField
        CrankanglesdegEditFieldLabel    matlab.ui.control.Label
        FinalrevolutionsSlider          matlab.ui.control.Slider
        FinalrevolutionsSliderLabel     matlab.ui.control.Label
        InitialrevolutionsSlider        matlab.ui.control.Slider
        InitialrevolutionsSliderLabel   matlab.ui.control.Label
        EnginebuilderLabel              matlab.ui.control.Label
        EnginelayoutLabel               matlab.ui.control.Label
        TestingconditionsrpmLabel       matlab.ui.control.Label
        CrankmassSlider                 matlab.ui.control.Slider
        CrankmassSliderLabel            matlab.ui.control.Label
        ConrodmassSlider                matlab.ui.control.Slider
        ConrodmassSliderLabel           matlab.ui.control.Label
        PistonmassSlider                matlab.ui.control.Slider
        PistonmassSliderLabel           matlab.ui.control.Label
        MassgLabel                      matlab.ui.control.Label
        CranklengthSlider               matlab.ui.control.Slider
        CranklengthSliderLabel          matlab.ui.control.Label
        ConrodlengthSlider              matlab.ui.control.Slider
        ConrodlengthSliderLabel         matlab.ui.control.Label
        GeometrymmLabel                 matlab.ui.control.Label
        CenterPanel                     matlab.ui.container.Panel
        ForcingspectrumButton           matlab.ui.control.Button
        DetailedforcingreportButton     matlab.ui.control.Button
        ForcingLabel                    matlab.ui.control.Label
        Shakingmoment                   matlab.ui.control.UIAxes
        Forcinginput                    matlab.ui.control.UIAxes
        RightPanel                      matlab.ui.container.Panel
        TransmittedforcesButton         matlab.ui.control.Button
        ResponsespectrumButton          matlab.ui.control.Button
        DetailedresponsereportButton    matlab.ui.control.Button
        ResponseLabel                   matlab.ui.control.Label
        Angles                          matlab.ui.control.UIAxes
        Displacement                    matlab.ui.control.UIAxes
    end

    % Properties that correspond to apps with auto-reflow
    properties (Access = private)
        onePanelWidth = 576;
        twoPanelWidth = 768;
    end

    
    properties (Access = private)
        responseGlobal
        forcingGlobal
        timeGlobal
        detailedForcingGlobal
        modes
        dynoGlobal
        timeStepGlobal
        transmittedGlobal
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startup(app)
            movegui(app.ParametricInlineEngineSimulatorUIFigure,"center");
        end

        % Button pushed function: RunButton
        function run(app, event)
            %Cleanup
            cla(app.Forcinginput);
            cla(app.Shakingmoment);
            cla(app.Displacement);
            cla(app.Angles);

            crank_angles=str2double(strsplit(app.CrankanglesdegEditField.Value))*pi/180;
            if length(crank_angles)<app.CylindersnumberSpinner.Value
                crank_angles=zeros(app.CylindersnumberSpinner.Value);
            end
            
            %Engine building and testing
            myFactory=EngineFactory();
            myEngine=myFactory.buildEngine(app.CylindersnumberSpinner.Value,...
                app.PistonmassSlider.Value/1000, app.ConrodmassSlider.Value/1000,...
                app.ConrodlengthSlider.Value/1000, 3, app.CrankmassSlider.Value/1000,...
                app.CranklengthSlider.Value/1000, crank_angles, app.PistonmassvariationSlider.Value/100);
            myDyno=Dyno(app.InitialrevolutionsSlider.Value*(2*pi/60), app.FinalrevolutionsSlider.Value*(2*pi/60),...
                app.TestingtimesSlider.Value, myEngine);
            myForcing=myDyno.fullForcingMeasurement();
            myResponse=myDyno.displacementAndAngles();

            %Static variables
            app.forcingGlobal=myForcing;
            app.responseGlobal=myResponse;
            app.timeGlobal=myDyno.time;
            app.detailedForcingGlobal=myDyno.forcingMeasurement();
            app.modes=myDyno.findModes(myDyno.engine.mounts.k, myDyno.engine.block.inertia_tensor);
            app.dynoGlobal=myDyno;
            app.timeStepGlobal=myDyno.time_step;
            app.transmittedGlobal=myDyno.transmittedForcesAndMoments(myResponse);

            %Plotting Inputs
            hold(app.Forcinginput,'on')
            plot(app.Forcinginput, myDyno.time, myForcing(1,:),'color', '#0072BD', 'DisplayName', 'Force, x');
            plot(app.Forcinginput, myDyno.time, myForcing(2,:),'color', '#D95319', 'DisplayName', 'Force, y');
            plot(app.Forcinginput, myDyno.time, myForcing(3,:),'color', '#EDB120', 'DisplayName', 'Force, z');
            legend(app.Forcinginput);
            hold(app.Forcinginput,'off')
            
            hold(app.Shakingmoment,'on')
            plot(app.Shakingmoment, myDyno.time, myForcing(4,:),'color', '#7E2F8E', 'DisplayName', 'Moment, x');
            plot(app.Shakingmoment, myDyno.time, myForcing(5,:),'color', '#77AC30', 'DisplayName', 'Moment, y');
            plot(app.Shakingmoment, myDyno.time, myForcing(6,:),'color', '#4DBEEE', 'DisplayName', 'Moment, z');
            legend(app.Shakingmoment);
            hold(app.Shakingmoment,'off')

            %Plotting Outputs
            hold(app.Displacement, 'on')
            plot(app.Displacement, myDyno.time, myResponse(1,:),'color', '#0072BD', 'DisplayName', 'Displacement, x');
            plot(app.Displacement, myDyno.time, myResponse(2,:),'color', '#D95319', 'DisplayName', 'Displacement, y');
            plot(app.Displacement, myDyno.time, myResponse(3,:),'color', '#EDB120', 'DisplayName', 'Displacement, z');
            legend(app.Displacement);
            hold(app.Displacement,'off')
            
            hold(app.Angles,'on')
            plot(app.Angles, myDyno.time, myResponse(4,:),'color', '#7E2F8E', 'DisplayName', '\theta_x');
            plot(app.Angles, myDyno.time, myResponse(5,:),'color', '#77AC30', 'DisplayName', '\theta_y');
            plot(app.Angles, myDyno.time, myResponse(6,:),'color', '#4DBEEE', 'DisplayName', '\theta_z');
            legend(app.Angles);
            hold(app.Angles,'off')
            updateAppLayout(app)

        end

        % Value changed function: ConstantrpmButton
        function makeRpmConstant(app, event)
            app.FinalrevolutionsSlider.Value=app.InitialrevolutionsSlider.Value;
            app.ConstantrpmButton.Value=0;
        end

        % Button pushed function: DetailedresponsereportButton
        function DetailedResponseButtonPushed(app, event)
            timeResponseFigure=figure('Name', 'Detailed Response Report: Time Response', 'NumberTitle','off');

            subplot(3,2,1)
            plot(app.timeGlobal, app.responseGlobal(1,:))
            title('Displacement, x')
            xlabel('Time [s]') 
            ylabel('Displacement [m]')

            subplot(3,2,3)
            plot(app.timeGlobal, app.responseGlobal(2,:))
            title('Displacement, y')
            xlabel('Time [s]') 
            ylabel('Displacement [m]')

            subplot(3,2,5)
            plot(app.timeGlobal, app.responseGlobal(3,:))
            title('Displacement, z')
            xlabel('Time [s]') 
            ylabel('Displacement [m]')

            subplot(3,2,2)
            plot(app.timeGlobal, app.responseGlobal(4,:))
            title('\theta_x (angle around x axis)')
            xlabel('Time [s]') 
            ylabel('Angle [rad]')

            subplot(3,2,4)
            plot(app.timeGlobal, app.responseGlobal(5,:))
            title('\theta_y (angle around y axis)')
            xlabel('Time [s]') 
            ylabel('Angle [rad]')

            subplot(3,2,6)
            plot(app.timeGlobal, app.responseGlobal(6,:))
            title('\theta_z (angle around z axis)')
            xlabel('Time [s]') 
            ylabel('Angle [rad]')

            modesFigure=figure('Name', 'Detailed Response Report: Mode Shapes', 'NumberTitle','off');
            plot([0:7], [zeros(1, 6); app.modes; zeros(1, 6)], 'DisplayName', 'Mode shapes');
            title('Mode shapes')
            xlabel('Components') 
            ylabel('Coefficient')
            xticklabels({''; '1st'; '2nd'; '3rd'; '4th'; '5th'; '6th'; ''})
            legend('1st mode', '2nd mode', '3rd mode', '4th mode', '5th mode', '6th mode')
        end

        % Button pushed function: DetailedforcingreportButton
        function DetailedForcingButtonPushed(app, event)
            forcingFigure=figure('Name', 'Detailed Forcing Report: Time Domain', 'NumberTitle','off');

            subplot(3,2,1)
            plot(app.timeGlobal, app.forcingGlobal(1,:))
            title('Force, x')
            xlabel('Time [s]') 
            ylabel('Intensity [N]')

            subplot(3,2,3)
            plot(app.timeGlobal, app.forcingGlobal(2,:))
            title('Force, y')
            xlabel('Time [s]') 
            ylabel('Intensity [N]')

            subplot(3,2,5)
            temp = [app.forcingGlobal(3,:)
                app.detailedForcingGlobal(2,:)
                app.detailedForcingGlobal(3,:)];
            plot(app.timeGlobal, temp)
            title('Force, z (radial and reciprocating)')
            xlabel('Time [s]') 
            ylabel('Intensity [N]')
            legend('Total z force', 'Radial z force', 'Reciprocating z force')

            subplot(3,2,2)
            plot(app.timeGlobal, app.forcingGlobal(4,:))
            title('Moment, x (given by conrod)')
            xlabel('Time [s]') 
            ylabel('Intensity [Nm]')

            subplot(3,2,4)
            plot(app.timeGlobal, app.forcingGlobal(5,:))
            title('Moment, y (given by radial and alternating forces)')
            xlabel('Time [s]') 
            ylabel('Intensity [Nm]')

            subplot(3,2,6)
            plot(app.timeGlobal, app.forcingGlobal(6,:))
            title('Moment, z (given by radial forces)')
            xlabel('Time [s]') 
            ylabel('Intensity [Nm]')

        end

        % Button pushed function: ForcingspectrumButton
        function ForcingSpectrum(app, event)
            forcingSpectrumFigure = figure('Name', 'Forcing Spectrum', 'NumberTitle','off');
            N = length(app.timeGlobal);
            samplingFreq = 1/app.timeStepGlobal;
            dF = samplingFreq/N;
            freq = 0:dF:samplingFreq/2; 
            
            subplot(3,2,1)
            forcingSpectrum = fft(app.forcingGlobal(1,:));
            loglog(freq,2*abs(forcingSpectrum(1:floor(N/2)+1))/N);
            title('Force, x')
            xlabel('Frequency [Hz]') 
            ylabel('Intensity [N]')
            
            subplot(3,2,3)
            forcingSpectrum = fft(app.forcingGlobal(2,:));
            loglog(freq,2*abs(forcingSpectrum(1:floor(N/2)+1))/N);
            title('Force, y')
            xlabel('Frequency [Hz]') 
            ylabel('Intensity [N]')

            subplot(3,2,5)
            forcingSpectrum = fft(app.forcingGlobal(3,:));
            loglog(freq,2*abs(forcingSpectrum(1:floor(N/2)+1))/N);
            title('Force, z')
            xlabel('Frequency [Hz]') 
            ylabel('Intensity [N]')

            subplot(3,2,2)
            forcingSpectrum = fft(app.forcingGlobal(4,:));
            loglog(freq,2*abs(forcingSpectrum(1:floor(N/2)+1))/N);
            title('Moment, x')
            xlabel('Frequency [Hz]') 
            ylabel('Intensity [Nm]')

            subplot(3,2,4)
            forcingSpectrum = fft(app.forcingGlobal(5,:));
            loglog(freq,2*abs(forcingSpectrum(1:floor(N/2)+1))/N);
            title('Moment, y')
            xlabel('Frequency [Hz]') 
            ylabel('Intensity [Nm]')

            subplot(3,2,6)
            forcingSpectrum = fft(app.forcingGlobal(6,:));
            loglog(freq,2*abs(forcingSpectrum(1:floor(N/2)+1))/N);
            title('Moment, z')
            xlabel('Frequency [Hz]') 
            ylabel('Intensity [Nm]')
        end

        % Button pushed function: ResponsespectrumButton
        function ResponseSpectrum(app, event)
            responseSpectrumFigure = figure('Name', 'Response Spectrum', 'NumberTitle','off');
            N = length(app.timeGlobal);
            samplingFreq = 1/app.timeStepGlobal;
            dF = samplingFreq/N;
            freq = 0:dF:samplingFreq/2; 
            
            subplot(3,2,1)
            responseSpectrum = fft(app.responseGlobal(1,:));
            loglog(freq,2*abs(responseSpectrum(1:floor(N/2)+1))/N);
            title('Displacement, x')
            xlabel('Frequency [Hz]') 
            ylabel('Displacement [m]')
            
            subplot(3,2,3)
            responseSpectrum = fft(app.responseGlobal(2,:));
            loglog(freq,2*abs(responseSpectrum(1:floor(N/2)+1))/N);
            title('Displacement, y')
            xlabel('Frequency [Hz]') 
            ylabel('Displacement [m]')

            subplot(3,2,5)
            responseSpectrum = fft(app.responseGlobal(3,:));
            loglog(freq,2*abs(responseSpectrum(1:floor(N/2)+1))/N);
            title('Displacement, z')
            xlabel('Frequency [Hz]') 
            ylabel('Displacement [m]')

            subplot(3,2,2)
            responseSpectrum = fft(app.responseGlobal(4,:));
            loglog(freq,2*abs(responseSpectrum(1:floor(N/2)+1))/N);
            title('Angle, x')
            xlabel('Frequency [Hz]') 
            ylabel('Angle [rad]')

            subplot(3,2,4)
            responseSpectrum = fft(app.responseGlobal(5,:));
            loglog(freq,2*abs(responseSpectrum(1:floor(N/2)+1))/N);
            title('Angle, y')
            xlabel('Frequency [Hz]') 
            ylabel('Angle [rad]')

            subplot(3,2,6)
            responseSpectrum = fft(app.responseGlobal(6,:));
            loglog(freq,2*abs(responseSpectrum(1:floor(N/2)+1))/N);
            title('Angle, z')
            xlabel('Frequency [Hz]') 
            ylabel('Angle [rad]')
        end

        % Button pushed function: TransmittedforcesButton
        function Transmittedforces(app, event)
            transmittedFigure=figure('Name', 'Transmitted forces', 'NumberTitle','off');

            subplot(3,2,1)
            plot(app.timeGlobal, app.transmittedGlobal(1,:))
            title('Force, x')
            xlabel('Time [s]') 
            ylabel('Intensity [N]')

            subplot(3,2,3)
            plot(app.timeGlobal, app.transmittedGlobal(2,:))
            title('Force, y')
            xlabel('Time [s]') 
            ylabel('Intensity [N]')

            subplot(3,2,5)
            plot(app.timeGlobal, app.transmittedGlobal(3,:))
            title('Force, z')
            xlabel('Time [s]') 
            ylabel('Intensity [N]')

            subplot(3,2,2)
            plot(app.timeGlobal, app.transmittedGlobal(4,:))
            title('Moment, x')
            xlabel('Time [s]') 
            ylabel('Intensity [Nm]')

            subplot(3,2,4)
            plot(app.timeGlobal, app.transmittedGlobal(5,:))
            title('Moment, y')
            xlabel('Time [s]') 
            ylabel('Intensity [Nm]')

            subplot(3,2,6)
            plot(app.timeGlobal, app.transmittedGlobal(6,:))
            title('Moment, z')
            xlabel('Time [s]') 
            ylabel('Intensity [Nm]')
        end

        % Changes arrangement of the app based on UIFigure width
        function updateAppLayout(app, event)
            currentFigureWidth = app.ParametricInlineEngineSimulatorUIFigure.Position(3);
            if(currentFigureWidth <= app.onePanelWidth)
                % Change to a 3x1 grid
                app.GridLayout.RowHeight = {696, 696, 696};
                app.GridLayout.ColumnWidth = {'1x'};
                app.CenterPanel.Layout.Row = 1;
                app.CenterPanel.Layout.Column = 1;
                app.LeftPanel.Layout.Row = 2;
                app.LeftPanel.Layout.Column = 1;
                app.RightPanel.Layout.Row = 3;
                app.RightPanel.Layout.Column = 1;
            elseif (currentFigureWidth > app.onePanelWidth && currentFigureWidth <= app.twoPanelWidth)
                % Change to a 2x2 grid
                app.GridLayout.RowHeight = {696, 696};
                app.GridLayout.ColumnWidth = {'1x', '1x'};
                app.CenterPanel.Layout.Row = 1;
                app.CenterPanel.Layout.Column = [1,2];
                app.LeftPanel.Layout.Row = 2;
                app.LeftPanel.Layout.Column = 1;
                app.RightPanel.Layout.Row = 2;
                app.RightPanel.Layout.Column = 2;
            else
                % Change to a 1x3 grid
                app.GridLayout.RowHeight = {'1x'};
                app.GridLayout.ColumnWidth = {328, '1x', 351};
                app.LeftPanel.Layout.Row = 1;
                app.LeftPanel.Layout.Column = 1;
                app.CenterPanel.Layout.Row = 1;
                app.CenterPanel.Layout.Column = 2;
                app.RightPanel.Layout.Row = 1;
                app.RightPanel.Layout.Column = 3;
            end
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create ParametricInlineEngineSimulatorUIFigure and hide until all components are created
            app.ParametricInlineEngineSimulatorUIFigure = uifigure('Visible', 'off');
            app.ParametricInlineEngineSimulatorUIFigure.AutoResizeChildren = 'off';
            app.ParametricInlineEngineSimulatorUIFigure.Position = [100 100 1022 696];
            app.ParametricInlineEngineSimulatorUIFigure.Name = 'Parametric Inline Engine Simulator';
            app.ParametricInlineEngineSimulatorUIFigure.Icon = 'PIE_icon.png';
            app.ParametricInlineEngineSimulatorUIFigure.SizeChangedFcn = createCallbackFcn(app, @updateAppLayout, true);

            % Create GridLayout
            app.GridLayout = uigridlayout(app.ParametricInlineEngineSimulatorUIFigure);
            app.GridLayout.ColumnWidth = {328, '1x', 351};
            app.GridLayout.RowHeight = {'1x'};
            app.GridLayout.ColumnSpacing = 0;
            app.GridLayout.RowSpacing = 0;
            app.GridLayout.Padding = [0 0 0 0];
            app.GridLayout.Scrollable = 'on';

            % Create LeftPanel
            app.LeftPanel = uipanel(app.GridLayout);
            app.LeftPanel.Layout.Row = 1;
            app.LeftPanel.Layout.Column = 1;

            % Create GeometrymmLabel
            app.GeometrymmLabel = uilabel(app.LeftPanel);
            app.GeometrymmLabel.FontWeight = 'bold';
            app.GeometrymmLabel.FontColor = [0.2235 0.3059 0.4314];
            app.GeometrymmLabel.Position = [9 558 106 22];
            app.GeometrymmLabel.Text = 'Geometry [mm]';

            % Create ConrodlengthSliderLabel
            app.ConrodlengthSliderLabel = uilabel(app.LeftPanel);
            app.ConrodlengthSliderLabel.HorizontalAlignment = 'right';
            app.ConrodlengthSliderLabel.Position = [13 537 81 22];
            app.ConrodlengthSliderLabel.Text = 'Conrod length';

            % Create ConrodlengthSlider
            app.ConrodlengthSlider = uislider(app.LeftPanel);
            app.ConrodlengthSlider.Limits = [0 300];
            app.ConrodlengthSlider.Position = [115 546 188 3];
            app.ConrodlengthSlider.Value = 142;

            % Create CranklengthSliderLabel
            app.CranklengthSliderLabel = uilabel(app.LeftPanel);
            app.CranklengthSliderLabel.HorizontalAlignment = 'right';
            app.CranklengthSliderLabel.Position = [13 496 74 22];
            app.CranklengthSliderLabel.Text = 'Crank length';

            % Create CranklengthSlider
            app.CranklengthSlider = uislider(app.LeftPanel);
            app.CranklengthSlider.Limits = [0 300];
            app.CranklengthSlider.Position = [108 505 195 3];
            app.CranklengthSlider.Value = 43;

            % Create MassgLabel
            app.MassgLabel = uilabel(app.LeftPanel);
            app.MassgLabel.FontWeight = 'bold';
            app.MassgLabel.FontColor = [0.2235 0.3059 0.4314];
            app.MassgLabel.Position = [9 455 69 22];
            app.MassgLabel.Text = 'Mass [g]';

            % Create PistonmassSliderLabel
            app.PistonmassSliderLabel = uilabel(app.LeftPanel);
            app.PistonmassSliderLabel.HorizontalAlignment = 'right';
            app.PistonmassSliderLabel.Position = [10 430 71 22];
            app.PistonmassSliderLabel.Text = 'Piston mass';

            % Create PistonmassSlider
            app.PistonmassSlider = uislider(app.LeftPanel);
            app.PistonmassSlider.Limits = [0 1000];
            app.PistonmassSlider.Position = [102 439 198 3];
            app.PistonmassSlider.Value = 380;

            % Create ConrodmassSliderLabel
            app.ConrodmassSliderLabel = uilabel(app.LeftPanel);
            app.ConrodmassSliderLabel.HorizontalAlignment = 'right';
            app.ConrodmassSliderLabel.Position = [9 389 77 22];
            app.ConrodmassSliderLabel.Text = 'Conrod mass';

            % Create ConrodmassSlider
            app.ConrodmassSlider = uislider(app.LeftPanel);
            app.ConrodmassSlider.Limits = [0 1500];
            app.ConrodmassSlider.Position = [107 398 195 3];
            app.ConrodmassSlider.Value = 635;

            % Create CrankmassSliderLabel
            app.CrankmassSliderLabel = uilabel(app.LeftPanel);
            app.CrankmassSliderLabel.HorizontalAlignment = 'right';
            app.CrankmassSliderLabel.Position = [10 347 70 22];
            app.CrankmassSliderLabel.Text = 'Crank mass';

            % Create CrankmassSlider
            app.CrankmassSlider = uislider(app.LeftPanel);
            app.CrankmassSlider.Limits = [0 1500];
            app.CrankmassSlider.Position = [101 356 201 3];
            app.CrankmassSlider.Value = 1430;

            % Create TestingconditionsrpmLabel
            app.TestingconditionsrpmLabel = uilabel(app.LeftPanel);
            app.TestingconditionsrpmLabel.FontWeight = 'bold';
            app.TestingconditionsrpmLabel.FontColor = [0.2235 0.3059 0.4314];
            app.TestingconditionsrpmLabel.Position = [11 293 150 22];
            app.TestingconditionsrpmLabel.Text = 'Testing conditions [rpm]';

            % Create EnginelayoutLabel
            app.EnginelayoutLabel = uilabel(app.LeftPanel);
            app.EnginelayoutLabel.FontWeight = 'bold';
            app.EnginelayoutLabel.FontColor = [0.2235 0.3059 0.4314];
            app.EnginelayoutLabel.Position = [9 636 95 22];
            app.EnginelayoutLabel.Text = 'Engine layout';

            % Create EnginebuilderLabel
            app.EnginebuilderLabel = uilabel(app.LeftPanel);
            app.EnginebuilderLabel.HorizontalAlignment = 'center';
            app.EnginebuilderLabel.FontSize = 16;
            app.EnginebuilderLabel.FontWeight = 'bold';
            app.EnginebuilderLabel.Position = [46 669 234 22];
            app.EnginebuilderLabel.Text = 'Engine builder';

            % Create InitialrevolutionsSliderLabel
            app.InitialrevolutionsSliderLabel = uilabel(app.LeftPanel);
            app.InitialrevolutionsSliderLabel.HorizontalAlignment = 'right';
            app.InitialrevolutionsSliderLabel.Position = [8 272 95 22];
            app.InitialrevolutionsSliderLabel.Text = 'Initial revolutions';

            % Create InitialrevolutionsSlider
            app.InitialrevolutionsSlider = uislider(app.LeftPanel);
            app.InitialrevolutionsSlider.Limits = [0 20000];
            app.InitialrevolutionsSlider.Position = [124 281 177 3];
            app.InitialrevolutionsSlider.Value = 650;

            % Create FinalrevolutionsSliderLabel
            app.FinalrevolutionsSliderLabel = uilabel(app.LeftPanel);
            app.FinalrevolutionsSliderLabel.HorizontalAlignment = 'right';
            app.FinalrevolutionsSliderLabel.Position = [8 231 93 22];
            app.FinalrevolutionsSliderLabel.Text = 'Final revolutions';

            % Create FinalrevolutionsSlider
            app.FinalrevolutionsSlider = uislider(app.LeftPanel);
            app.FinalrevolutionsSlider.Limits = [0 20000];
            app.FinalrevolutionsSlider.Position = [122 240 179 3];
            app.FinalrevolutionsSlider.Value = 6800;

            % Create CrankanglesdegEditFieldLabel
            app.CrankanglesdegEditFieldLabel = uilabel(app.LeftPanel);
            app.CrankanglesdegEditFieldLabel.HorizontalAlignment = 'right';
            app.CrankanglesdegEditFieldLabel.Position = [9 583 106 22];
            app.CrankanglesdegEditFieldLabel.Text = 'Crank angles [deg]';

            % Create CrankanglesdegEditField
            app.CrankanglesdegEditField = uieditfield(app.LeftPanel, 'text');
            app.CrankanglesdegEditField.Placeholder = '0 120 240 240 120 0';
            app.CrankanglesdegEditField.Position = [130 583 188 22];
            app.CrankanglesdegEditField.Value = '0 120 240 240 120 0';

            % Create TestingtimesSliderLabel
            app.TestingtimesSliderLabel = uilabel(app.LeftPanel);
            app.TestingtimesSliderLabel.HorizontalAlignment = 'right';
            app.TestingtimesSliderLabel.Position = [9 190 86 22];
            app.TestingtimesSliderLabel.Text = 'Testing time [s]';

            % Create TestingtimesSlider
            app.TestingtimesSlider = uislider(app.LeftPanel);
            app.TestingtimesSlider.Limits = [0 5];
            app.TestingtimesSlider.MajorTicks = [0 1 2 3 4 5];
            app.TestingtimesSlider.Position = [116 199 186 3];
            app.TestingtimesSlider.Value = 1;

            % Create CylindersnumberSpinnerLabel
            app.CylindersnumberSpinnerLabel = uilabel(app.LeftPanel);
            app.CylindersnumberSpinnerLabel.HorizontalAlignment = 'right';
            app.CylindersnumberSpinnerLabel.Position = [9 615 100 22];
            app.CylindersnumberSpinnerLabel.Text = 'Cylinders number';

            % Create CylindersnumberSpinner
            app.CylindersnumberSpinner = uispinner(app.LeftPanel);
            app.CylindersnumberSpinner.Editable = 'off';
            app.CylindersnumberSpinner.Position = [124 615 191 22];
            app.CylindersnumberSpinner.Value = 6;

            % Create DefectsLabel
            app.DefectsLabel = uilabel(app.LeftPanel);
            app.DefectsLabel.FontWeight = 'bold';
            app.DefectsLabel.FontColor = [0.2235 0.3059 0.4314];
            app.DefectsLabel.Position = [9 148 81 22];
            app.DefectsLabel.Text = 'Defects [%]';

            % Create PistonmassvariationSliderLabel
            app.PistonmassvariationSliderLabel = uilabel(app.LeftPanel);
            app.PistonmassvariationSliderLabel.HorizontalAlignment = 'right';
            app.PistonmassvariationSliderLabel.Position = [5 103 81 43];
            app.PistonmassvariationSliderLabel.Text = {'Piston mass'; ' variation'};

            % Create PistonmassvariationSlider
            app.PistonmassvariationSlider = uislider(app.LeftPanel);
            app.PistonmassvariationSlider.Limits = [0 10];
            app.PistonmassvariationSlider.Position = [97 133 213 3];

            % Create RunButton
            app.RunButton = uibutton(app.LeftPanel, 'push');
            app.RunButton.ButtonPushedFcn = createCallbackFcn(app, @run, true);
            app.RunButton.Position = [215 20 100 22];
            app.RunButton.Text = 'Run!';

            % Create ConstantrpmButton
            app.ConstantrpmButton = uibutton(app.LeftPanel, 'state');
            app.ConstantrpmButton.ValueChangedFcn = createCallbackFcn(app, @makeRpmConstant, true);
            app.ConstantrpmButton.Text = 'Constant rpm';
            app.ConstantrpmButton.Position = [188 293 100 22];

            % Create CrankshafteccentricityLabel
            app.CrankshafteccentricityLabel = uilabel(app.LeftPanel);
            app.CrankshafteccentricityLabel.HorizontalAlignment = 'right';
            app.CrankshafteccentricityLabel.Visible = 'off';
            app.CrankshafteccentricityLabel.Position = [4 61 81 43];
            app.CrankshafteccentricityLabel.Text = {'Crankshaft'; ' eccentricity'};

            % Create CrankshafteccentricitySlider
            app.CrankshafteccentricitySlider = uislider(app.LeftPanel);
            app.CrankshafteccentricitySlider.Visible = 'off';
            app.CrankshafteccentricitySlider.Position = [96 91 213 3];

            % Create CenterPanel
            app.CenterPanel = uipanel(app.GridLayout);
            app.CenterPanel.Layout.Row = 1;
            app.CenterPanel.Layout.Column = 2;

            % Create Forcinginput
            app.Forcinginput = uiaxes(app.CenterPanel);
            title(app.Forcinginput, 'Input forces')
            xlabel(app.Forcinginput, 'Time [s]')
            ylabel(app.Forcinginput, 'Intensity [N]')
            zlabel(app.Forcinginput, 'Z')
            app.Forcinginput.Position = [6 464 300 185];

            % Create Shakingmoment
            app.Shakingmoment = uiaxes(app.CenterPanel);
            title(app.Shakingmoment, 'Input moments')
            xlabel(app.Shakingmoment, 'Time [s]')
            ylabel(app.Shakingmoment, 'Intensity [Nm]')
            zlabel(app.Shakingmoment, 'Z')
            app.Shakingmoment.Position = [6 242 300 185];

            % Create ForcingLabel
            app.ForcingLabel = uilabel(app.CenterPanel);
            app.ForcingLabel.HorizontalAlignment = 'center';
            app.ForcingLabel.FontSize = 16;
            app.ForcingLabel.FontWeight = 'bold';
            app.ForcingLabel.Position = [66 668 234 22];
            app.ForcingLabel.Text = 'Forcing';

            % Create DetailedforcingreportButton
            app.DetailedforcingreportButton = uibutton(app.CenterPanel, 'push');
            app.DetailedforcingreportButton.ButtonPushedFcn = createCallbackFcn(app, @DetailedForcingButtonPushed, true);
            app.DetailedforcingreportButton.Position = [189 20 134 22];
            app.DetailedforcingreportButton.Text = 'Detailed forcing report';

            % Create ForcingspectrumButton
            app.ForcingspectrumButton = uibutton(app.CenterPanel, 'push');
            app.ForcingspectrumButton.ButtonPushedFcn = createCallbackFcn(app, @ForcingSpectrum, true);
            app.ForcingspectrumButton.Position = [34 20 136 22];
            app.ForcingspectrumButton.Text = 'Forcing spectrum';

            % Create RightPanel
            app.RightPanel = uipanel(app.GridLayout);
            app.RightPanel.Layout.Row = 1;
            app.RightPanel.Layout.Column = 3;

            % Create Displacement
            app.Displacement = uiaxes(app.RightPanel);
            title(app.Displacement, 'Displacement')
            xlabel(app.Displacement, 'Time [s]')
            ylabel(app.Displacement, 'Displacement [mm]')
            zlabel(app.Displacement, 'Z')
            app.Displacement.Position = [27 464 300 185];

            % Create Angles
            app.Angles = uiaxes(app.RightPanel);
            title(app.Angles, 'Angles')
            xlabel(app.Angles, 'Time [s]')
            ylabel(app.Angles, 'Angles [deg]')
            zlabel(app.Angles, 'Z')
            app.Angles.Position = [27 240 300 185];

            % Create ResponseLabel
            app.ResponseLabel = uilabel(app.RightPanel);
            app.ResponseLabel.HorizontalAlignment = 'center';
            app.ResponseLabel.FontSize = 16;
            app.ResponseLabel.FontWeight = 'bold';
            app.ResponseLabel.Position = [60 668 234 22];
            app.ResponseLabel.Text = 'Response';

            % Create DetailedresponsereportButton
            app.DetailedresponsereportButton = uibutton(app.RightPanel, 'push');
            app.DetailedresponsereportButton.ButtonPushedFcn = createCallbackFcn(app, @DetailedResponseButtonPushed, true);
            app.DetailedresponsereportButton.Position = [187 20 147 22];
            app.DetailedresponsereportButton.Text = 'Detailed response report';

            % Create ResponsespectrumButton
            app.ResponsespectrumButton = uibutton(app.RightPanel, 'push');
            app.ResponsespectrumButton.ButtonPushedFcn = createCallbackFcn(app, @ResponseSpectrum, true);
            app.ResponsespectrumButton.Position = [27 20 136 22];
            app.ResponsespectrumButton.Text = 'Response spectrum';

            % Create TransmittedforcesButton
            app.TransmittedforcesButton = uibutton(app.RightPanel, 'push');
            app.TransmittedforcesButton.ButtonPushedFcn = createCallbackFcn(app, @Transmittedforces, true);
            app.TransmittedforcesButton.Position = [27 53 136 22];
            app.TransmittedforcesButton.Text = 'Transmitted forces';

            % Show the figure after all components are created
            app.ParametricInlineEngineSimulatorUIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = parametric_inline_engine_simulator

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.ParametricInlineEngineSimulatorUIFigure)

            % Execute the startup function
            runStartupFcn(app, @startup)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.ParametricInlineEngineSimulatorUIFigure)
        end
    end
end