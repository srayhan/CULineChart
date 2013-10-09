//
//  CULineChartView.m
//  chipup
//
//  Created by Syed Rayhan on 8/28/13.
//  Copyright (c) 2013 ChipUp LLC. All rights reserved.
//

#import "CULineChartView.h"

@implementation CULineChartView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark - Chart behavior
-(void)initPlotWithTitle:(NSString *) title
           andXAxisTitle:(NSString *)xTitle
           andYAxisTitle:(NSString *)yTitle
       andPlotIdentifier:(NSString *)identifier
{

   // NSLog(@"%@", self.plotData);
    self.hostView = [[CPTGraphHostingView alloc] initWithFrame:self.bounds];
    self.hostView.backgroundColor = [UIColor whiteColor];
    self.hostView.allowPinchScaling = NO;
    [self configureGraphWithTitle:title];
    [self configurePlotWithIdentifier:identifier];
    [self configureAxesWithXTitle:xTitle andYTitle:yTitle];
    [self addSubview:self.hostView];
}

-(void) refresh
{
    DebugLog("refershing chart");
    [self.hostView.hostedGraph reloadData];
}

-(void)configureGraphWithTitle:(NSString *) title
{
    DebugLog("creatign the graph");
    // 1 - Create the graph
    CPTGraph *graph = [[CPTXYGraph alloc] initWithFrame:self.hostView.bounds];
    graph.plotAreaFrame.masksToBorder = NO;
    graph.plotAreaFrame.borderLineStyle = nil;
    
    // 2 - Configure the graph
   // [graph applyTheme:[CPTTheme themeNamed:kCPTPlainWhiteTheme]];
    graph.paddingBottom = 30.0f;
    graph.paddingLeft  = 30.0f;
    graph.paddingTop    = 5.0f;
    graph.paddingRight  = 5.0f;
    
    // 3 - Set up styles
    CPTMutableTextStyle *titleStyle = [CPTMutableTextStyle textStyle];
    titleStyle.color = [CPTColor blackColor];
    titleStyle.fontName = @"Helvetica-Bold";
    titleStyle.fontSize = 12.0f;
    
    // 4 - Set up title
    graph.title = title;
    graph.titleTextStyle = titleStyle;
    graph.titlePlotAreaFrameAnchor = CPTRectAnchorTop;
    graph.titleDisplacement = CGPointMake(0.0f, 0.0f);
    
    // 5 - Set up plot space
    CGFloat xMin = 0.0f;
    CGFloat xMax = [self.xMax floatValue] * 1.5f;
    CGFloat yMin = 0.0f;
    CGFloat yMax = [self.yMax floatValue] * 1.5f;
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *) graph.defaultPlotSpace;
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(xMin) length:CPTDecimalFromFloat(xMax)];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(yMin) length:CPTDecimalFromFloat(yMax)];
    self.hostView.hostedGraph = graph;
}

-(void) configurePlotWithIdentifier:(NSString *) identifier
{
    DebugLog("adding the plot");
    // Set up the plot
    CPTScatterPlot * linePlot = [[CPTScatterPlot alloc] init];
    linePlot.identifier = identifier;
    

    // Set up line style
    CPTMutableLineStyle *lineStyle = [[CPTMutableLineStyle alloc] init];
    lineStyle.lineColor = [CPTColor blackColor];
    lineStyle.lineWidth = 1.0;
    
    // Style the points
    CPTPlotSymbol *plotSymbol = [CPTPlotSymbol ellipsePlotSymbol];
    plotSymbol.fill = [CPTFill fillWithColor:[CPTColor whiteColor]];
    plotSymbol.size = CGSizeMake(5.0, 5.0);
    linePlot.plotSymbol = plotSymbol;
    linePlot.labelRotation = -45;
    // Add the plot to graph
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *) self.hostView.hostedGraph.defaultPlotSpace;
    CPTMutablePlotRange *xRange = [plotSpace.xRange mutableCopy];
    [xRange expandRangeByFactor:CPTDecimalFromCGFloat(1.1f)];
    plotSpace.xRange = xRange;
    CPTMutablePlotRange *yRange = [plotSpace.yRange mutableCopy];
    [yRange expandRangeByFactor:CPTDecimalFromCGFloat(1.2f)];
    plotSpace.yRange = yRange;
    linePlot.labelOffset = 5.0f;
    linePlot.dataSource = self;
    linePlot.delegate = self;
    linePlot.dataLineStyle = lineStyle;
    [self.hostView.hostedGraph addPlot:linePlot toPlotSpace:self.hostView.hostedGraph.defaultPlotSpace];

}

-(void)configureAxesWithXTitle:(NSString *)xTitle andYTitle:(NSString *)yTitle
{
    DebugLog("configuring axes");
    // Configure styles
    CPTMutableTextStyle *axisTitleStyle = [CPTMutableTextStyle textStyle];
    axisTitleStyle.color = [CPTColor blackColor];
    axisTitleStyle.fontName = @"Helvetica-Bold";
    axisTitleStyle.fontSize = 8.0f;
    CPTMutableLineStyle *axisLineStyle = [CPTMutableLineStyle lineStyle];
    axisLineStyle.lineWidth = 1.0f;
    axisLineStyle.lineColor = [[CPTColor blackColor] colorWithAlphaComponent:1];
    
    // Get the graph's axis set
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *) self.hostView.hostedGraph.axisSet;
    
    NSNumberFormatter *newFormatter = [[NSNumberFormatter alloc] init];
    newFormatter.minimumIntegerDigits = 1;
    [newFormatter setGeneratesDecimalNumbers:NO];
    [newFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    static CPTMutableTextStyle *labelTextStyle = nil;
    labelTextStyle = [[CPTMutableTextStyle alloc] init];
    labelTextStyle.color = [CPTColor blackColor];
    labelTextStyle.fontSize = 8.0f;
   
    // Configure the x-axis
    //axisSet.xAxis.labelingPolicy = CPTAxisLabelingPolicyNone;
    axisSet.xAxis.labelingPolicy = CPTAxisLabelingPolicyAutomatic;
    axisSet.xAxis.title = xTitle;
    axisSet.xAxis.titleTextStyle = axisTitleStyle;
    axisSet.xAxis.titleOffset = 20.0f;
    axisSet.xAxis.labelFormatter = newFormatter;
    axisSet.xAxis.axisLineStyle = axisLineStyle;
    axisSet.xAxis.labelTextStyle = labelTextStyle;
    
    // 4 - Configure the y-axis
    //axisSet.yAxis.labelingPolicy = CPTAxisLabelingPolicyNone;
    axisSet.yAxis.labelingPolicy = CPTAxisLabelingPolicyAutomatic;
    axisSet.yAxis.title = yTitle;
    axisSet.yAxis.titleTextStyle = axisTitleStyle;
    axisSet.yAxis.titleOffset = 30.0f;
    axisSet.yAxis.labelFormatter = newFormatter;
    axisSet.yAxis.axisLineStyle = axisLineStyle;
    axisSet.yAxis.labelTextStyle = labelTextStyle;
}

-(void)hideAnnotation:(CPTGraph *)graph {
}

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot {
    DebugLog("number of records %d", [self.plotData count] );
    return [self.plotData count];
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot
                     field:(NSUInteger)fieldEnum
               recordIndex:(NSUInteger)index
{
   // NSLog(@"%@", self.plotData);
    DebugLog("%d at index %d value %@", fieldEnum, index, [[self.plotData objectAtIndex: index] objectAtIndex: fieldEnum]);
    return [[self.plotData objectAtIndex: index] objectAtIndex: fieldEnum];
}

- (CPTLayer *)dataLabelForPlot:(CPTPlot *)plot recordIndex:(NSUInteger)index
{
    NSNumber *data = [self numberForPlot:plot field:CPTScatterPlotFieldY recordIndex:index];
    CPTMutableTextStyle *labelTextStyle = [CPTMutableTextStyle textStyle];
    labelTextStyle.fontSize = 8.0f;
    labelTextStyle.color = [CPTColor blackColor];
    int value = [data intValue];
    NSString * displayValue = @"";
    switch (value)
    {
        case 0 ... 999:
            displayValue = [NSString stringWithFormat:@"%d", value];
            break;
        case 1000 ... 999999:
            displayValue = [NSString stringWithFormat:@"%dK", value/1000];
            break;
        case 1000000 ... 999999999:
            displayValue = [NSString stringWithFormat:@"%dM", value/1000000];
            break;
    }
    CPTTextLayer * newLayer = [[CPTTextLayer alloc] initWithText:displayValue style:labelTextStyle];
    
    return newLayer;
}

@end
