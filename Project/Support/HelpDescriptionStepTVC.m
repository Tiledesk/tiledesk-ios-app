//
//  HelpDescriptionStepTVC.m
//  bppmobile
//
//  Created by Andrea Sponziello on 05/10/2017.
//  Copyright © 2017 Frontiere21. All rights reserved.
//

#import "HelpDescriptionStepTVC.h"
#import "HelpCategoryStepTVC.h"

@interface HelpDescriptionStepTVC ()

@end

@implementation HelpDescriptionStepTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // init description text field
    self.descriptionTextView.delegate = self;
    //    kPlaceholderDescription = NSLocalizedString(@"jobWizardDescriptionPlaceholder", nil);
    NSString *description = [self.context objectForKey:@"description"];
    if (description) {
        self.descriptionTextView.text = description;
    }
    [self validateDescription];
    
    self.nextButton.title = NSLocalizedString(@"Help wizard send button", nil);
    self.titleLabel.text = NSLocalizedString(@"help wizard title", nil);
    self.subtitleLabel.text = NSLocalizedString(@"help wizard description", nil);//@"Descrivi sinteticamente il tuo problema, ti metteremo in contatto con un operatore specializzato";//NSLocalizedString(@"description subtitle", nil);
    self.navigationItem.title = NSLocalizedString(@"help wizard navigation title", nil);
    
    // test
    NSLog(@"context: %@", self.context);
    //    [self resetDescription];
}

//- (void)resetDescription
//{
//    self.descriptionTextView.text = kPlaceholderDescription;
//    self.descriptionTextView.textColor = [UIColor lightGrayColor];
//}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.descriptionTextView becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
//    return 0;
//}

/*
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
 
 // Configure the cell...
 
 return cell;
 }
 */

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"next"]) {
        NSObject *vc = (NSObject *)[segue destinationViewController];
        NSString *description = self.descriptionTextView.text;
        [self saveDescription:description];
        [self.context setObject:description forKey:@"description"];
        [vc setValue:self.context forKey:@"context"];
    }
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSString *description = self.descriptionTextView.text;
    [self saveDescription:description];
    [self.context setObject:description forKey:@"description"];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSString *lastDescription = [self loadDescription];
    if (lastDescription) {
        self.descriptionTextView.text = lastDescription;
        [self validateDescription];
    }
}

#pragma mark - Validate text

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    NSLog(@"textViewDidBeginEditing...");
    // Clear the message text when the user starts editing
    //    if ([self.descriptionTextView.text isEqualToString:kPlaceholderDescription]) {//|| [textView.text isEqualToString:kPlaceholderDescription]
    //        self.descriptionTextView.text = @"";
    //        self.descriptionTextView.textColor = [UIColor blackColor];
    //    }
}

static NSInteger MAX_CHARACTERS_DESCRIPTION = 600;
static NSInteger MIN_CHARACTERS_DESCRIPTION = 4;

- (void)textViewDidEndEditing:(UITextView *)textView
{
    NSLog(@"textViewDidEndEditing...");
    [self validateDescription];
    // Reset to placeholder text if the user has finished
    // editing and no message has been entered.
    //    if ([self.descriptionTextView.text isEqualToString:@""]) {
    //        [self resetDescription];
    //    }
}

-(void)textViewDidChange:(UITextView *)textView {
    //    NSLog(@"TEXT CHANGED %@", textView.text);
    [self validateDescription];
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)string {
    //    NSLog(@"shouldChangeCharactersInRange");
    NSUInteger newLength = [textView.text length] + [string length] - range.length;
    return (newLength > MAX_CHARACTERS_DESCRIPTION) ? NO : YES;
}

-(void)validateDescription {
    NSLog(@"validateDescription");
    NSString *trimmed = [self.descriptionTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSUInteger characterCount = [trimmed length];
    BOOL valid = true;
    if([trimmed isEqualToString:@""]){
        NSLog(@"INVALID");
        valid = false;
    } else if (characterCount < MIN_CHARACTERS_DESCRIPTION) {
        NSLog(@"INVALID");
        valid = false;
    } else {
        NSLog(@"VALID!");
        valid = true;
    }
    
    if (valid == false) {
        self.nextButton.enabled = NO;
    } else {
        self.nextButton.enabled = YES;
    }
    
}

//- (IBAction)nextAction:(id)sender {
//    NSLog(@"next to?");
//    [self performSegueWithIdentifier:@"next" sender:self];
//}

-(void)saveDescription:(NSString *)description {
    NSUserDefaults *userPreferences = [NSUserDefaults standardUserDefaults];
    [userPreferences setObject:self.descriptionTextView.text forKey:@"helpUserDescription"];
    [userPreferences synchronize];
}

-(NSString *)loadDescription {
    NSUserDefaults *userPreferences = [NSUserDefaults standardUserDefaults];
    return [userPreferences stringForKey:@"helpUserDescription"];
}

- (IBAction)sendAction:(id)sender {
    UIAlertController * menu =   [UIAlertController
                                  alertControllerWithTitle:nil
                                  message:@"Invio richiesta?"
                                  preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* sendStepAskPush = [UIAlertAction
                                      actionWithTitle:@"Invia"
                                      style:UIAlertActionStyleDefault
                                      handler:^(UIAlertAction * action)
                                      {
                                          NSLog(@"Sending help request");
//                                          [self sendStepAskPush];
                                          [self send];
                                      }];
    
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:NSLocalizedString(@"Help wizard not now button", nil)
                             style:UIAlertActionStyleCancel
                             handler:^(UIAlertAction * action)
                             {
                                 NSLog(@"action canceled");
                             }];
    [menu addAction:sendStepAskPush];
    [menu addAction:cancel];
    // for ipad
    menu.popoverPresentationController.barButtonItem = self.navigationItem.rightBarButtonItem;
    
    [self presentViewController:menu animated:YES completion:nil];
}

-(void)send {
    NSLog(@"sending: %@", self.context);
    self.descriptionTextView.delegate = nil;
    [self.context setObject:self forKey:@"source-view-controller"];
    id vc = [self.context objectForKey:@"view-controller"];
    NSLog(@"vc: %@", vc);
    if ([vc respondsToSelector:@selector(helpWizardEnd:)]) {
        NSLog(@"performing selector...");
        [vc performSelector:@selector(helpWizardEnd:) withObject:self.context];
    }
}

-(void)dealloc {
    NSLog(@"Deallocating HelpDescriptionTVC");
}

//-(void)helpWizardEnd:(NSDictionary *)context {
//    NSLog(@"helpWizardEnd");
//    UIViewController *sourceViewController = (UIViewController *)[context objectForKey:@"source-view-controller"];
//    if ([sourceViewController isKindOfClass:[HelpCategoryStepTVC class]]) {
//        NSLog(@"Job wizard canceled.");
//        [self dismissViewControllerAnimated:YES completion:nil];
//    }
//    else if ([sourceViewController isKindOfClass:[HelpDescriptionStepTVC class]]) {
//        // RITORNO DALLA RICERCA
//        NSLog(@"job context MRPreviewStepTVC: %@", self.jobWizardContext);
//        [self dismissViewControllerAnimated:YES completion:^{
//            MRJobCategory *cat = [context objectForKey:@"category"];
//            NSString *skill_name = cat.nameInCurrentLocale;
//            NSString *skill_id = cat.pathId;
//            NSString *skill_part = [NSString stringWithFormat:@"%@ [%@]", skill_name, skill_id];
//            NSString *place = [context objectForKey:@"position"];
//            NSString *description = [context objectForKey:@"description"];
//            NSString *hello_message = [NSString stringWithFormat:NSLocalizedString(@"hello message template - quote", nil), description, place, skill_part];
//            self.selectedRecipientTextToSend = hello_message;
//            NSDictionary *search_attributes = @{@"skill_id" : skill_id, @"skill_name" : skill_name, @"place": place, @"description": description};
//            NSMutableDictionary *search_attributes_and_quote_request = [search_attributes mutableCopy];
//            [search_attributes_and_quote_request setObject:@"1" forKey:@"quote_request"]; // da aggiungere per l'autoreply.
//            self.selectedRecipientAttributesToSend = search_attributes_and_quote_request;
//            
//            NSMutableDictionary *search = [[NSMutableDictionary alloc] init];
//            search[@"fullname"] = self.applicationContext.loggedUser.fullName;
//            search[@"userid"] = self.applicationContext.loggedUser.username;
//            search[@"category"]  = skill_id;
//            search[@"body"]  = description;
//            search[@"cap"]  = place;
//            search[@"city"]  = @"UNKNOWN";
//            search[@"prov"]  = @"UNKNOWN";
//            search[@"zone"]  = @"UNKNOWN";
//            search[@"tel"] = @"0000000000";
//            MRService *service = [[MRService alloc] init];
//            [service sendSearchRequest:search completion:^(NSDictionary *dict) {
//                if (dict != nil) {
//                    NSLog(@"dict: %@", dict);
//                    NSString *lat = dict[@"lat"];
//                    NSString *lon = dict[@"lon"];
//                    NSLog(@"lat: %@, lon: %@", lat, lon);
//                    // recupera gli utenti cui inviare la comunicazione di match! (servizio query.php)
//                    [service queryProfessionalsInCategory:skill_id lat:lat lon:lon completion:^(NSDictionary *dict) {
//                        for (NSDictionary *user in dict[@"users"]) {
//                            NSString *userId_match = user[@"subscriber"];
//                            NSLog(@"user match: %@", userId_match);
//                            // TODO Teamlabot invia al professionista un messaggio con testo:
//                            
//                            [ChatConversationHandler sendSpecialMessageFromTeamlabotButMustBeServerSide:userId_match attributes:search_attributes];
//                            // La creazione del messaggio di Teamlabot produce l'invio di una notifica ai destinatari.
//                            
//                            // Creo una conversazione virtuale (come quella di creazione del gruppo) tra i due utenti con il testo della richiesta.
//                        }
//                    }];
//                }
//            }];
//            NSString *botuser = [self.settings objectForKey:@"botuser"];
//            [self openConversationWithRecipient:botuser];
//        }];
//    } else if ([sourceViewController isKindOfClass:[MRJobSkillPreviewStepTVC class]]) {
//        // RITORNO DALL INVIO CV
//        NSLog(@"job context MRJobSkillPreviewStepTVC: %@", self.jobWizardContext);
//        [self dismissViewControllerAnimated:YES completion:^{
//            MRJobCategory *cat = [context objectForKey:@"category"];
//            NSString *skill_name = cat.nameInCurrentLocale;
//            NSString *skill_id = cat.pathId;
//            NSString *skill_part = [NSString stringWithFormat:@"%@ [%@]", skill_name, skill_id];
//            NSString *place = [context objectForKey:@"position"];
//            NSString *description = [context objectForKey:@"description"];
//            NSString *tel = [context objectForKey:@"telephone"];
//            
//            NSLog(@"category: %@", cat);
//            NSLog(@"position: %@", place);
//            NSLog(@"description: %@", description);
//            NSLog(@"tel: %@", tel);
//            NSString *hello_message = [NSString stringWithFormat:NSLocalizedString(@"hello message template - cv", nil), description, place, skill_part, tel];
//            self.selectedRecipientTextToSend = hello_message;
//            NSDictionary *cv_sent_attributes = @{@"cv_sent": @"1", @"skill_id" : skill_id, @"skill_name" : skill_name, @"place": place, @"description": description};
//            self.selectedRecipientAttributesToSend = cv_sent_attributes;
//            
//            NSMutableDictionary *cv = [[NSMutableDictionary alloc] init];
//            cv[@"fullname"] = self.applicationContext.loggedUser.fullName;
//            cv[@"userid"] = self.applicationContext.loggedUser.username;
//            cv[@"category"]  = skill_id;
//            cv[@"body"]  = description;
//            cv[@"cap"]  = place;
//            cv[@"city"]  = @"UNKNOWN";
//            cv[@"prov"]  = @"UNKNOWN";
//            cv[@"zone"]  = @"UNKNOWN";
//            cv[@"tel"] = tel;
//            MRService *service = [[MRService alloc] init];
//            [service sendCV:cv completion:^(NSDictionary *dict) {
//                if (dict != nil) {
//                    NSLog(@"dict: %@", dict);
//                    NSString *lat = dict[@"lat"];
//                    NSString *lon = dict[@"lon"];
//                    NSLog(@"lat: %@, lon: %@", lat, lon);
//                    // recupera gli utenti cui inviare la comunicazione di match! (servizio query.php)
//                    // crea conversazioni
//                    // invia notifica
//                    // find zone (CAP?) coordinates
//                    // call tu subscribe service.
//                    [service subscribeToJobSearching:self.me.userId lat:lat lon:lon category:skill_id completion:nil];
//                }
//            }];
//            NSString *botuser = [self.settings objectForKey:@"botuser"];
//            [self openConversationWithRecipient:botuser];
//        }];
//    }
//    NSLog(@"dismissing request wizard");
//}

@end
