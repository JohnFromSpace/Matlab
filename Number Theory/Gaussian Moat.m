classdef GaussianMoatApp < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = private)
        UIFigure              matlab.ui.Figure
        GridLayout            matlab.ui.container.GridLayout
        GridLayout2           matlab.ui.container.GridLayout
        IslandRadiusLabel     matlab.ui.control.Label
        IslandRadiusSlider    matlab.ui.control.Slider
        MaximumMoatWidthLabel matlab.ui.control.Label
        MaximumMoatWidthSlider matlab.ui.control.Slider
        SigmaLabel            matlab.ui.control.Label
        SigmaSlider           matlab.ui.control.Slider
        GridSizeLabel         matlab.ui.control.Label
        GridSizeSlider        matlab.ui.control.Slider
        ColormapLabel         matlab.ui.control.Label
        ColormapDropDown      matlab.ui.control.DropDown
        PlotButton            matlab.ui.control.Button
        SaveButton            matlab.ui.control.Button
        ResetButton           matlab.ui.control.Button
        UIAxes                matlab.ui.control.UIAxes
        FeedbackLabel         matlab.ui.control.Label
    end

    
end

