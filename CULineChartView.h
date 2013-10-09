//
//  CULineChartView.h
//  chipup
//
//  Created by Syed Rayhan on 8/28/13.
//  Copyright (c) 2013 ChipUp LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tournament.h"
#import "CorePlot-CocoaTouch.h"

@interface CULineChartView : UIView <CPTScatterPlotDataSource, CPTScatterPlotDelegate>

@property (nonatomic, strong) IBOutlet CPTGraphHostingView *hostView;
//@property (nonatomic, strong) CPTXYGraph * graph;
//@property (nonatomic, strong) CPTScatterPlot * linePlot;
@property (nonatomic, strong) NSMutableArray * plotData;
@property (nonatomic, copy )  NSNumber * xMax;
@property (nonatomic, copy)   NSNumber* yMax;

-(void)initPlotWithTitle:(NSString *) title
           andXAxisTitle:(NSString *)xTitle
           andYAxisTitle:(NSString *)yTitle
       andPlotIdentifier:(NSString *)identifier;
-(void)configureGraphWithTitle:(NSString *) title;
-(void)configurePlotWithIdentifier:(NSString *)identifier;
-(void)configureAxesWithXTitle:(NSString *)xTitle andYTitle:(NSString *)yTitle;
-(void)hideAnnotation:(CPTGraph *)graph;
-(void)refresh;

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot;

- (CPTLayer *)dataLabelForPlot:(CPTPlot *)plot recordIndex:(NSUInteger)index;

// Implement one of the following
/*-(NSArray *)numbersForPlot:(CPTPlot *)plot
                     field:(NSUInteger)fieldEnum
          recordIndexRange:(NSRange)indexRange; */

-(NSNumber *)numberForPlot:(CPTPlot *)plot
                     field:(NSUInteger)fieldEnum
               recordIndex:(NSUInteger)index;

/*-(NSRange)recordIndexRangeForPlot:(CPTPlot *)plot
                        plotRange:(CPTPlotRange *)plotRect;*/

@end
