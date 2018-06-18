//
//  HelpCategoryStepTVC.m
//  
//
//  Created by Andrea Sponziello on 05/10/2017.
//
//

#import "HelpCategoryStepTVC.h"
#import "HelpCategory.h"
#import "HelpDataService.h"
#import "HelpDepartment.h"

@interface HelpCategoryStepTVC ()

@end

@implementation HelpCategoryStepTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
//    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Help-Info" ofType:@"plist"]];
//    NSArray *plist_categories = [dictionary objectForKey:@"help-categories"];
//    if (self.category) {
//        // selected category & children
//        self.categories = self.category.children;
//    }
//    else {
//        self.categories = [[NSMutableArray alloc] init];
//        for (NSDictionary *cat in plist_categories) {
//            HelpCategory *category = [[HelpCategory alloc] initWithDictionary:cat parent:nil];
//            [self.categories addObject:category];
//        }
//    }
//    if (!self.category) {
//        self.cancelButton.title = NSLocalizedString(@"cancel", nil);
//        self.navigationItem.title = NSLocalizedString(@"help wizard title topic", nil);
//    }
//    else {
//        self.navigationItem.leftBarButtonItem = nil;
//        self.navigationItem.title = self.category.nameInCurrentLocale;
//    }
    
    self.cancelButton.title = NSLocalizedString(@"cancel", nil);
    self.navigationItem.title = NSLocalizedString(@"help wizard title topic", nil);

    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = YES;
}

-(void)viewDidAppear:(BOOL)animated {
    HelpDataService *service =[[HelpDataService alloc] init];
    [service downloadDepartmentsWithCompletionHandler:^(NSArray<HelpDepartment *> *departments, NSError *error) {
        // TODO
        NSLog(@"count deps: %@", departments);
        self.departments = departments;
        for (HelpDepartment *dep in departments) {
            NSLog(@"dep id: %@, name: %@ isDefault: %d", dep.departmentId, dep.name, dep.isDefault);
        }
        [self.tableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

static NSInteger FIRST_STEP_CELL_HEIGHT = 60;
static NSInteger NEXT_STEP_CELL_HEIGHT = 60;

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return FIRST_STEP_CELL_HEIGHT;
    } else {
//        HelpCategory *category = self.categories[indexPath.row];
//        HelpDepartment *dep = self.departments[indexPath.row];
//        NSLog(@"CATEGORY FOR HEIGHT = %@ image: %@", category.nameInCurrentLocale, category.imageName);
//        if (category.parent) {
//            return NEXT_STEP_CELL_HEIGHT;
//        } else {
            return FIRST_STEP_CELL_HEIGHT;
//        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
//        return self.categories.count;
        return self.departments.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"title-cell" forIndexPath:indexPath];
        UILabel *titleLabel = [cell viewWithTag:1];
        titleLabel.text = NSLocalizedString(@"Help wizard select argument", nil);
    }
    if (indexPath.section == 1) {
//        HelpCategory *category = self.categories[indexPath.row];
        HelpDepartment *dep = self.departments[indexPath.row];
//        if (category.parent) {
//            cell = [tableView dequeueReusableCellWithIdentifier:@"category-cell" forIndexPath:indexPath];
//        } else {
            cell = [tableView dequeueReusableCellWithIdentifier:@"root-category-cell" forIndexPath:indexPath];
//            UIImageView *imageView = (UIImageView *)[cell viewWithTag:2];
//            imageView.image = [UIImage imageNamed:category.imageName];
//        }
        UILabel *categoryLabel = (UILabel *)[cell viewWithTag:1];
//        categoryLabel.text = category.nameInCurrentLocale;
        categoryLabel.text = dep.name;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    //    if (indexPath.section == 1) {
    //        [self.context setObject:[self.categories objectAtIndex:indexPath.row] forKey:@"category"];
    //        [self performSegueWithIdentifier:@"next" sender:self];
    //    }
    
//    HelpCategory *selectedCategory = [self.categories objectAtIndex:indexPath.row];
    HelpDepartment *selectedCategory = [self.departments objectAtIndex:indexPath.row];
//    if (selectedCategory.children) {
//        // call yourself, no prepareForSegue is called, all init here.
//        HelpCategoryStepTVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"request-vc"];
//        vc.category = selectedCategory;
//        vc.context = self.context;
//        [self.navigationController pushViewController:vc animated:YES];
//    } else {
        [self.context setObject:selectedCategory forKey:@"category"];
        [self performSegueWithIdentifier:@"next" sender:self];
//    }
    
    //    NSLog(@"context %@", self.context);
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"next"]) {
        NSObject *vc = (NSObject *)[segue destinationViewController];
        [vc setValue:self.context forKey:@"context"];
    }
}

- (IBAction)cancelAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
