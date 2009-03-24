function SenFig = createSenFig(Sen,Obs,SensorFigure)

% CREATESENFIG  Create sensor figure.
%   SENFIG = CREATESENFIG(Sen,Obs,SensorFigure) creates one sensor figure
%   per sensor, containing the following graphics objects:
%       - observed simulated landmarks (virtual world) - in red
%       - estimated landmarks observations, containing measurement and
%       uncertainty ellipsoid - in colors depending on the landmark type,
%       and a label with the landmark ID.
%
%   The output SENFIG is a structure array of handles to all these graphics
%   objects. See the Matlab documentation for information about graphics
%   handles and the way to efficiently manipulate graphics. SENFIG(sen) is
%   the structure of handles for sensor 'sen', with the following fields:
%       .fig     handle to the figure
%       .axes    handle to the axes
%       .raw     handle to raw perception, eg. the simulated landmarks
%       .measure array of handles to measurement points, one handle each
%       .ellipse array of handles to the ellipsoid's contour 'line' objects
%       .label   array of handles to the lmk's label 'text' objects
%
%   The figure is updated using drawSenFig.
%
%   See also DRAWSENFIG, CREATEMAPFIG, LINE, SET, GET.


for sen = 1:numel(Sen)

    % Figure
    SenFig(sen).fig = figure(sen); % if sen==1, [figure_id=10]
    moreindatatip
    rob = Sen(sen).robot;
    set(SenFig(sen).fig,...
        'numbertitle','off',...
        'name',['Robot ' num2str(rob) '  --  Sensor ' num2str(sen) '  (' Sen(sen).type ')'],...
        'renderer','opengl');
    clf


    % Sensor type:
    % ------------
    switch Sen(sen).type

        % camera pinhole
        % --------------
        case {'pinHole'}
            % axes
            axis equal
            SenFig(sen).axes = gca;
            set(SenFig(sen).axes,...
                'position',[.05 .05 .9 .9],...
                'xlim',[0 Sen(sen).par.imSize(1)],...
                'xaxislocation','top',...
                'ylim',[0,Sen(sen).par.imSize(2)],... % size of the image of sensor
                'ydir','reverse',...
                'layer','top',...
                'fontsize',9);

            % raw data
            SenFig(sen).raw = line(...
                'parent',       SenFig(sen).axes,...
                'xdata',        [],...
                'ydata',        [],...
                'color',        'r',...
                'linestyle',    'none',...
                'marker',       '+');

            % observations
            for lmk = 1:size(Obs,2)
                SenFig(sen).measure(lmk) = line(...
                    'parent',SenFig(sen).axes,...
                    'linestyle','none',...
                    'marker','.',...
                    'xdata',[],...
                    'ydata',[],...
                    'vis','off');
                SenFig(sen).ellipse(lmk) = line(...
                    'parent',SenFig(sen).axes,...
                    'xdata',[],...
                    'ydata',[],...
                    'vis','off');
                SenFig(sen).label(lmk) = text(...
                    'parent',SenFig(sen).axes,...
                    'position',[50 50],...
                    'string',num2str(lmk),...
                    'color','k',...
                    'horizontalalignment','center',...
                    'vis','off');
            end

            % ADD HERE FOR INITIALIZATION OF NEW SENSORS's FIGURES
            % case {'newSensor'}
            % do something


            % unknown
            % -------
        otherwise
            % Print an error and go out
            error('??? Unknown sensor type ''%s''.',Sen(sen).type);
    end

end


