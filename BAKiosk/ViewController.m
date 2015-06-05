//
//  ViewController.m
//  BAKiosk
//
//  Created by Eirik Eikås on 16.05.15.
//  Copyright (c) 2015 Evil Corp ENK. All rights reserved.
//

#import "ViewController.h"
#import "TVViewController.h"
#import "SlideShowNavigatorViewController.h"
@import MediaPlayer;

@interface ViewController ()

@property UIWindow *external;
@property TVViewController *externalController;

@property (strong, nonatomic) IBOutlet UIButton *topLeft;
@property (strong, nonatomic) IBOutlet UIButton *topMiddle;
@property (strong, nonatomic) IBOutlet UIButton *topRight;
@property (strong, nonatomic) IBOutlet UIButton *bottomLeft;
@property (strong, nonatomic) IBOutlet UIButton *bottomMiddle;
@property (strong, nonatomic) IBOutlet UIButton *bottomRight;


@end

@implementation ViewController

@synthesize external;
@synthesize externalController;
@synthesize topLeft;
@synthesize topMiddle;
@synthesize topRight;
@synthesize bottomLeft;
@synthesize bottomMiddle;
@synthesize bottomRight;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    externalController = [[TVViewController alloc] init];
    [[self navigationController] setToolbarHidden:YES animated:NO];
    
    float width = [UIScreen mainScreen].bounds.size.width;
    float height = [UIScreen mainScreen].bounds.size.height;
    
    // Container
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height*0.45)];
    [image setBackgroundColor:[UIColor redColor]];
    [image setImage:[UIImage imageNamed:@"Kiosk"]];
    
    UIButton *olinaButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [olinaButton setBackgroundColor:[UIColor clearColor]];
    [olinaButton setTitle:@"" forState:UIControlStateNormal];
    [olinaButton addTarget:self action:@selector(olinaHandler:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:olinaButton];
    
    UIButton *eirikButton = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-50, 0, 50, 50)];
    [eirikButton setBackgroundColor:[UIColor clearColor]];
    [eirikButton setTitle:@"" forState:UIControlStateNormal];
    [eirikButton addTarget:self action:@selector(eirikHandler:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:eirikButton];
    
    //[self.view addGestureRecognizer:olinaGest];
    //[self.view addGestureRecognizer:eirikGest];
    
    // Buttons
    topLeft = [[UIButton alloc] initWithFrame:CGRectMake(0, height*0.45, width*0.333, height*0.275)];
    topMiddle = [[UIButton alloc] initWithFrame:CGRectMake(width*0.333, height*0.45, width*0.333, height*0.275)];
    topRight = [[UIButton alloc] initWithFrame:CGRectMake(width*0.666, height*0.45, width*0.333, height*0.275)];
    bottomLeft = [[UIButton alloc] initWithFrame:CGRectMake(0, (height*0.45)+(height*0.275), width*0.333, height*0.275)];
    bottomMiddle = [[UIButton alloc] initWithFrame:CGRectMake(width*0.333, (height*0.45)+(height*0.275), width*0.333, height*0.275)];
    bottomRight = [[UIButton alloc] initWithFrame:CGRectMake(width*0.666, (height*0.45)+(height*0.275), width*0.333, height*0.275)];
    
    [topLeft setBackgroundColor:[UIColor lightGrayColor]];
    [topMiddle setBackgroundColor:[UIColor lightGrayColor]];
    [topRight setBackgroundColor:[UIColor lightGrayColor]];
    [bottomLeft setBackgroundColor:[UIColor lightGrayColor]];
    [bottomMiddle setBackgroundColor:[UIColor lightGrayColor]];
    [bottomRight setBackgroundColor:[UIColor lightGrayColor]];
    
    [topLeft setBackgroundImage:[UIImage imageNamed:@"Konsept"] forState:UIControlStateNormal];
    [topMiddle setBackgroundImage:[UIImage imageNamed:@"Dybdeintervju"] forState:UIControlStateNormal];
    [topRight setBackgroundImage:[UIImage imageNamed:@"Oppdrag"] forState:UIControlStateNormal];
    [bottomLeft setBackgroundImage:[UIImage imageNamed:@"Prosess"] forState:UIControlStateNormal];
    [bottomMiddle setBackgroundImage:[UIImage imageNamed:@"Node"] forState:UIControlStateNormal];
    [bottomRight setBackgroundImage:[UIImage imageNamed:@"Plattform"] forState:UIControlStateNormal];
    
    // Add everything
    [self.view addSubview:topLeft];
    [self.view addSubview:topMiddle];
    [self.view addSubview:topRight];
    [self.view addSubview:bottomLeft];
    [self.view addSubview:bottomMiddle];
    [self.view addSubview:bottomRight];
    [self.view addSubview:image];
    
    // Button targets
    [topLeft addTarget:self action:@selector(topLeftHandle:) forControlEvents:UIControlEventTouchUpInside];
    [topMiddle addTarget:self action:@selector(topMiddleHandle:) forControlEvents:UIControlEventTouchUpInside];
    [topRight addTarget:self action:@selector(topRightHandle:) forControlEvents:UIControlEventTouchUpInside];
    [bottomLeft addTarget:self action:@selector(bottomLeftHandle:) forControlEvents:UIControlEventTouchUpInside];
    [bottomMiddle addTarget:self action:@selector(bottomMiddleHandle:) forControlEvents:UIControlEventTouchUpInside];
    [bottomRight addTarget:self action:@selector(bottomRightHandle:) forControlEvents:UIControlEventTouchUpInside];
    
    // Observers
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleScreenConnectNotification:) name:UIScreenDidConnectNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleScreenDisconnectNotification:) name:UIScreenDidDisconnectNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if([[UIScreen screens] count] > 1){
            NSLog(@"Init display once");
            [self handleScreenConnectNotification:[NSNotification notificationWithName:UIScreenDidConnectNotification object:[[UIScreen screens] objectAtIndex:1]]];
        }
    });
}

- (void)olinaHandler:(UIButton *)sender {
    NSLog(@"Hallo");
    SlideShowNavigatorViewController *navigator = [[SlideShowNavigatorViewController alloc] init];
    navigator.dataObject = @{@"images": @[@"presentasjon.001",
                                          @"presentasjon.002",
                                          @"presentasjon.003",
                                          @"presentasjon.004",
                                          @"presentasjon.005",
                                          @"presentasjon.006",
                                          @"presentasjon.007",
                                          @"presentasjon.008",
                                          @"presentasjon.009",
                                          @"presentasjon.010",
                                          @"presentasjon.011",
                                          @"presentasjon.012",
                                          @"presentasjon.013",
                                          @"presentasjon.014",
                                          @"presentasjon.015",
                                          @"presentasjon.016",
                                          @"presentasjon.017",
                                          @"presentasjon.018",
                                          @"presentasjon.019",
                                          @"presentasjon.020",
                                          @"presentasjon.021",
                                          @"presentasjon.022"],
                             @"description": @[@""], @"transition": @0};
    
    [navigator setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self presentViewController:navigator animated:YES completion:nil];
}

- (void)eirikHandler:(UITapGestureRecognizer *)sender {
    SlideShowNavigatorViewController *navigator = [[SlideShowNavigatorViewController alloc] init];
    navigator.dataObject = @{@"images": @[@"eirik.001",
                                          @"eirik.002",
                                          @"eirik.003",
                                          @"eirik.004",
                                          @"eirik.005",
                                          @"eirik.006",
                                          @"eirik.007",
                                          @"eirik.008",
                                          @"eirik.009",
                                          @"eirik.010",
                                          @"eirik.011",
                                          @"eirik.012",
                                          @"eirik.013",
                                          @"eirik.014",
                                          @"eirik.015",
                                          @"eirik.016"],
                             @"description": @[@""], @"transition": @0};
    
    [navigator setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self presentViewController:navigator animated:YES completion:nil];
}

- (void)topLeftHandle:(UIButton*)sender {
    SlideShowNavigatorViewController *navigator = [[SlideShowNavigatorViewController alloc] init];
    navigator.dataObject = @{@"images": @[@"Konseptbeskrivelse.001",
                                          @"Konseptbeskrivelse.002",
                                          @"Konseptbeskrivelse.003",
                                          @"Konseptbeskrivelse.004",
                                          @"Konseptbeskrivelse.005",
                                          @"Konseptbeskrivelse.006",
                                          @"Konseptbeskrivelse.007",
                                          @"Konseptbeskrivelse.008",
                                          @"Konseptbeskrivelse.009",
                                          @"Konseptbeskrivelse.010",
                                          @"Konseptbeskrivelse.011",
                                          @"Konseptbeskrivelse.012",
                                          @"Konseptbeskrivelse.013",
                                          @"Konseptbeskrivelse.014",
                                          @"Konseptbeskrivelse.015",
                                          @"Konseptbeskrivelse.016"],
                             @"description": @[@""], @"transition": @0};
    
    [navigator setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self presentViewController:navigator animated:YES completion:nil];
}
- (void)topMiddleHandle:(UIButton*)sender {
    SlideShowNavigatorViewController *navigator = [[SlideShowNavigatorViewController alloc] init];
    navigator.dataObject = @{@"images": @[@"Dybdeintervjuer.001",
                                          @"Dybdeintervjuer.002",
                                          @"Dybdeintervjuer.003",
                                          @"Dybdeintervjuer.004",
                                          @"Dybdeintervjuer.005",
                                          @"Dybdeintervjuer.006",
                                          @"Dybdeintervjuer.007",
                                          @"Dybdeintervjuer.008",
                                          @"Dybdeintervjuer.009",
                                          @"Dybdeintervjuer.010",
                                          @"Dybdeintervjuer.011",
                                          @"Dybdeintervjuer.012",
                                          @"Dybdeintervjuer.013",
                                          @"Dybdeintervjuer.014",
                                          @"Dybdeintervjuer.015",
                                          @"Dybdeintervjuer.016",
                                          @"Dybdeintervjuer.017",
                                          @"Dybdeintervjuer.018",
                                          @"Dybdeintervjuer.019",
                                          @"Dybdeintervjuer.020",
                                          @"Dybdeintervjuer.021",
                                          @"Dybdeintervjuer.022",
                                          @"Dybdeintervjuer.023",
                                          @"Dybdeintervjuer.024",
                                          @"Dybdeintervjuer.025",
                                          @"Dybdeintervjuer.026",
                                          @"Dybdeintervjuer.027",
                                          @"Dybdeintervjuer.028",
                                          @"Dybdeintervjuer.029",
                                          @"Dybdeintervjuer.030",
                                          @"Dybdeintervjuer.031",
                                          @"Dybdeintervjuer.032",
                                          @"Dybdeintervjuer.033",
                                          @"Dybdeintervjuer.034",
                                          @"Dybdeintervjuer.035",
                                          @"Dybdeintervjuer.036",
                                          @"Dybdeintervjuer.037",
                                          @"Dybdeintervjuer.038",
                                          @"Dybdeintervjuer.039",
                                          @"Dybdeintervjuer.040",
                                          @"Dybdeintervjuer.041",
                                          @"Dybdeintervjuer.042",
                                          @"Dybdeintervjuer.043",
                                          @"Dybdeintervjuer.044",
                                          @"Dybdeintervjuer.045",
                                          @"Dybdeintervjuer.046",
                                          @"Dybdeintervjuer.047",
                                          @"Dybdeintervjuer.048",
                                          @"Dybdeintervjuer.049",
                                          @"Dybdeintervjuer.050",
                                          @"Dybdeintervjuer.051",
                                          @"Dybdeintervjuer.052",
                                          @"Dybdeintervjuer.053",
                                          @"Dybdeintervjuer.054",
                                          @"Dybdeintervjuer.055",
                                          @"Dybdeintervjuer.056",
                                          @"Dybdeintervjuer.057",
                                          @"Dybdeintervjuer.058",
                                          @"Dybdeintervjuer.059",
                                          @"Dybdeintervjuer.060",
                                          @"Dybdeintervjuer.061",
                                          @"Dybdeintervjuer.062",
                                          @"Dybdeintervjuer.063",
                                          @"Dybdeintervjuer.064",
                                          @"Dybdeintervjuer.065",
                                          @"Dybdeintervjuer.066",
                                          @"Dybdeintervjuer.067",
                                          @"Dybdeintervjuer.068"],
                             @"description": @[@""], @"transition": @0};
    
    [navigator setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self presentViewController:navigator animated:YES completion:nil];
}
- (void)topRightHandle:(UIButton*)sender { // Oppdrag Vega
    SlideShowNavigatorViewController *navigator = [[SlideShowNavigatorViewController alloc] init];
    navigator.dataObject = @{@"images": @[@"Story i skisser.001",
                                          @"Story i skisser.002",
                                          @"Story i skisser.003",
                             @"Story i skisser.004",
                             @"Story i skisser.005",
                             @"Story i skisser.006",
                             @"Story i skisser.007",
                             @"Story i skisser.008",
                             @"Story i skisser.009",
                             @"Story i skisser.010",
                             @"Story i skisser.011",
                             @"Story i skisser.012",
                             @"Story i skisser.013",
                             @"Story i skisser.014",
                             @"Story i skisser.015",
                             @"Story i skisser.016",
                             @"Story i skisser.017",
                             @"Story i skisser.018",
                             @"Story i skisser.019",
                             @"Story i skisser.020",
                             @"Story i skisser.021",
                             @"Story i skisser.022",
                             @"Story i skisser.023",
                             @"Story i skisser.024",
                             @"Story i skisser.025",
                             @"Story i skisser.026",
                             @"Story i skisser.027",
                             @"Story i skisser.028",
                             @"Story i skisser.029",
                             @"Story i skisser.030"],
                             @"description": @[@""]};
    
    [navigator setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self presentViewController:navigator animated:YES completion:nil];
}
- (void)bottomLeftHandle:(UIButton*)sender {
    SlideShowNavigatorViewController *navigator = [[SlideShowNavigatorViewController alloc] init];
    navigator.dataObject = @{@"images": @[@"Prosess.00001",
                                          @"Prosess.00002",
                                          @"Prosess.00003",
                                          @"Prosess.00004",
                                          @"Prosess.00005",
                                          @"Prosess.00006",
                                          @"Prosess.00007",
                                          @"Prosess.00008.png",
                                          @"Prosess.00009",
                                          @"Prosess.00010",
                                          @"Prosess.00011",
                                          @"Prosess.00012",
                                          @"Prosess.00013",
                                          @"Prosess.00014",
                                          @"Prosess.00015",
                                          @"Prosess.00016",
                                          @"Prosess.00017",
                                          @"Prosess.00018",
                                          @"Prosess.00019",
                                          @"Prosess.00020",
                                          @"Prosess.00021",
                                          @"Prosess.00022",
                                          @"Prosess.00023",
                                          @"Prosess.00024",
                                          @"Prosess.00025",
                                          @"Prosess.00026",
                                          @"Prosess.00027",
                                          @"Prosess.00028",
                                          @"Prosess.00029",
                                          @"Prosess.00030",
                                          @"Prosess.00031",
                                          @"Prosess.00032",
                                          @"Prosess.00033",
                                          @"Prosess.00034",
                                          @"Prosess.00035",
                                          @"Prosess.00036",
                                          @"Prosess.00037",
                                          @"Prosess.00038",
                                          @"Prosess.00039",
                                          @"Prosess.00040",
                                          @"Prosess.00041",
                                          @"Prosess.00042",
                                          @"Prosess.00043",
                                          @"Prosess.00044",
                                          @"Prosess.00045",
                                          @"Prosess.00046",
                                          @"Prosess.00047",
                                          @"Prosess.00048",
                                          @"Prosess.00049",
                                          @"Prosess.00050"],
                             @"description": @[@""]};
    
    [navigator setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self presentViewController:navigator animated:YES completion:nil];
}
- (void)bottomMiddleHandle:(UIButton*)sender { // Noderute
    SlideShowNavigatorViewController *navigator = [[SlideShowNavigatorViewController alloc] init];
    navigator.dataObject = @{@"images": @[@"RUTENY.001",
                                          @"RUTENY.002",
                                          @"RUTENY.003",
                                          @"RUTENY.004",
                                          @"RUTENY.005",
                                          @"RUTENY.006",
                                          @"RUTENY.007",
                                          @"RUTENY.008",
                                          @"RUTENY.009",
                                          @"RUTENY.010",
                                          @"RUTENY.011",
                                          @"RUTENY.012",
                                          @"RUTENY.013",
                                          @"RUTENY.014",
                                          @"RUTENY.015",
                                          @"RUTENY.016"],
                             @"description": @[@""]};
    
    [navigator setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self presentViewController:navigator animated:YES completion:nil];
}
- (void)bottomRightHandle:(UIButton*)sender {
    SlideShowNavigatorViewController *navigator = [[SlideShowNavigatorViewController alloc] init];
    navigator.dataObject = @{@"videos": @[
                                     [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Plattform_Cut_01" ofType:@"mp4"]],
                                     [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Plattform_Cut_01" ofType:@"mp4"]],
                                     [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Plattform_Cut_02" ofType:@"mp4"]],
                                     [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Plattform_Cut_03" ofType:@"mp4"]],
                                     [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Plattform_Cut_04" ofType:@"mp4"]],
                                     [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Plattform_Cut_05" ofType:@"mp4"]],
                                     [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Plattform_Cut_06" ofType:@"mp4"]],
                                     [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Plattform_Cut_07" ofType:@"mp4"]],
                                     [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Plattform_Cut_08" ofType:@"mp4"]],
                                     [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Plattform_Cut_09" ofType:@"mp4"]],
                                     [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Plattform_Cut_10" ofType:@"mp4"]],
                                     [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Plattform_Cut_11" ofType:@"mp4"]],
                                     [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Plattform_Cut_12" ofType:@"mp4"]],
                                     [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Plattform_Cut_13" ofType:@"mp4"]],
                                     [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Plattform_Cut_14" ofType:@"mp4"]],
                                     [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Plattform_Cut_15" ofType:@"mp4"]],
                                     [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Plattform_Cut_16" ofType:@"mp4"]],
                                     [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Plattform_Cut_17" ofType:@"mp4"]],
                                     [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Plattform_Cut_18" ofType:@"mp4"]],
                                     [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Plattform_Cut_19" ofType:@"mp4"]],
                                     [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Plattform_Cut_20" ofType:@"mp4"]],
                                     [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Plattform_Cut_21" ofType:@"mp4"]],
                                     [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Plattform_Cut_22" ofType:@"mp4"]],
                                     [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Plattform_Cut_23" ofType:@"mp4"]],
                                     [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Plattform_Cut_24" ofType:@"mp4"]],
                                     [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Plattform_Cut_25" ofType:@"mp4"]],
                                     [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Plattform_Cut_26" ofType:@"mp4"]],
                                     ],
                             @"navigationDisabled": @NO,
                             @"description": @[@"",
                                               @"For å kunne nå sin målsetting er applikasjonen bygget opp som en plattform bestående av fire lag",
                                               @"Disse fire lagene representerer applikasjonens grunnleggende funksjonalitet så vel som formål",
                                               @"Nederest finner vi laget for å brukerens tilbakevenning til applikasjonen og fungerer som en grunnmur",
                                               @"Skal vi endre ungdommenes syn på og forhold til arven i området, er det grunnleggende at vi klarer å engasjere over en lengre tidsperiode",
                                               @"Det nederste laget av vår applikasjon og plattform er dermed ment for å øke retensjonen og å skape en vane for å bruke vår applikasjon",
                                               @"I sin letteste form innebærer dette laget at vi tar i bruk atferdsanalytisk teori og implementerer dette i brukerens opplevde sløyfe bestående av tre trinn. Et cue, som trigger en handling, brukeren blir belønnet for utførelsen av handlingen",
                                               @"For vår del øker vi retensjonen ved å minne brukeren på å komme tilbake til applikasjonen. Når brukeren interagerer med applikasjonen kommuniserer vi vårt budskap og vi påvirker brukerens holdninger. Til slutt gir vi brukeren positiv feedback for å ha interagert og samhandlet med applikasjonen",
                                               @"I den første generasjonen av applikasjonen vil dette aspektet ikke være veldig synlig, da hele opplevelsen og historien er beregnet å være et sammenhengende løp men kunden er interessert i å kunne lage større opplevelser på et senere tidspunkt",
                                               @"Over dette laget finner vi det spillmekaniske laget",
                                               @"Dette laget sørger for de engasjerende og underholdende aspektene ved applikasjonen",
                                               @"I utgangspunktet har vi tatt i bruk to spillmekaniske grep for å engasjere ungdommene",
                                               @"Først har vi innført en valuta. Vi kommer tilbake til denne",
                                               @"Dernest har vi implementert elementer for positiv feedback for å forsterke brukerens opplevelse, som diskutert i det forrige laget",
                                               @"Hensikten med valuta-elementet er, i den større versjonen av applikasjonen, å fremtvinge en kognitiv avgjørelse hos brukeren slik at vi bedre kan sørge for at ungdommene får med seg vårt budskap. Vi tvinger en kognitiv avgjørelse gjennom å sørge for at brukeren føler en risiko i bruke spillets interne valuta",
                                               @"Over igjen finner vi interaksjonslaget med spillets narrativ og det grafiske grensesnittet",
                                               @"Dette laget er det første av lagene som brukeren faktisk interagerer med, og er med det det eneste laget brukeren ser.",
                                               @"I sin enkleste form omfatter dette et kart, dialogbokser og tilknytning til fysiske aktiviteter",
                                               @"Brukeren spiller; tar avgjørelser, leter etter noder og får inntrykk som hjelper i å endre deres holdninger og atferd",
                                               @"Øverst har vi et fysisk aktivitetslag",
                                               @"Dette laget engasjerer brukeren i den fysiske aktiviteten",
                                               @"Brukeren må, på ulike tidspunkt i spillets flyt ut i naturen for å lette etter utplasserte bluetooth-noder",
                                               @"Disse nodene har en rekkevidde på 30 meter",
                                               @"Så snart brukeren er innenfor denne sonen vil de kunne søke etter dise utplasserte sporene",
                                               @"Har brukeren ikke applikasjonen oppe, vil det komme en notifikasjon som tilsier at de er i nærheten",
                                               @"Sett i en helhet kan plattformens fire lag legges ut følgende",
                                               @"Ved behov for endringer eller nye applikasjoner med nye formål eller vanskelighetsgrad kan kunden lett, via et grafisk grensesnitt, endre innholdet i de ulike lagene.",]};
    
    [navigator setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self presentViewController:navigator animated:YES completion:nil];
}

- (void)handleScreenConnectNotification:(NSNotification*)aNotification {
    UIScreen*    newScreen = [aNotification object];
    CGRect        screenBounds = newScreen.bounds;
    
    if (!external) {
        external = [[UIWindow alloc] initWithFrame:screenBounds];
        external.screen = newScreen;
        
        // Set the initial UI for the window.
        [externalController.view setFrame:screenBounds];
        [external addSubview:externalController.view];
        
        external.hidden = NO;
        NSLog(@"Connect!");
        NSLog(@"Ext sized: %@", NSStringFromCGRect(externalController.view.frame));
    }
}
- (void)handleScreenDisconnectNotification:(NSNotification*)aNotification {
    if (external) {
        // Hide and then delete the window.
        external.hidden = YES;
        external = nil;
        
        NSLog(@"Disconnect");
        
        // Update the main screen based on what is showing here.
        //[externalController displaySelectionOnMainScreen];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
