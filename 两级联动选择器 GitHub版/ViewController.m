//
//  ViewController.m
//  两级联动选择器 GitHub版
//
//  Created by JoJo on 15/12/9.
//  Copyright © 2015年 JoJo. All rights reserved.
//


#import "ViewController.h"

@interface ViewController ()<UIPickerViewDataSource,UIPickerViewDelegate>{
    
    NSDictionary *_books;
    
    NSArray *_authors;
    
    NSString *_selectedAuthor;  //保存当前选中的作者
    
    NSInteger tmpRow_Author;
    
    NSInteger tmpRow_Book;
    
    NSString *tmpAuthor;
    
    NSString *tmpBook;
    
    BOOL flagBook; //为书名列设置一个标志位,表明书名列有没有由用户手动滚动选择器来选择,NO表示没有，YES表示用户滚动了书名列选择器去选中特定的Row
}
@property (strong, nonatomic) IBOutlet UITextField *tf_Author;

@property (strong, nonatomic) IBOutlet UITextField *tf_BookName;

@property (strong, nonatomic) IBOutlet UIPickerView *picker;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化书名列标志位为NO
    
    flagBook=NO;
    
    
    tmpRow_Author=0;  //初始化作者列默认为第一行(Row=0的那一行) ,注:考虑到当用户在程序加载完成之后没有手动滚动选择器去选择的时候，直接点击了确定按钮，这时候基本推断用户选择的就是默认作者列第一行，书名列第一行的内容
    
    //初始化_books字典对象
    
    _books=@{
             @"莫言":@[@"蛙",@"丰乳肥臀",@"红高粱"],
             @"韩寒":@[@"想得美",@"就这么漂来漂去",@"一座城池"],
             @"郭敬明":@[@"小时代",@"爵迹",@"幻城"],
             };
    
    _authors=[_books allKeys]; //获取_books中所有的key,也就是获取所有的作者名，以数组形式输出
    
    _selectedAuthor=_authors[0]; //设置默认选中_authors中的第一个元素
    
    
    
    self.picker.dataSource=self;
    
    self.picker.delegate=self;
    
    
    // Do any additional setup after loading the view, typically from a nib.
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return 2;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    if (component==0) { //如果是第一列
        
        return _authors.count; //返回_authors中元素的个数,即_authors包含多少个元素，第一列就包含多少个列表项
    }
    
    else{ //如果是其他列，当然这里只有第二列(书名列)
        
        return [_books[_selectedAuthor] count]; //返回_books中_selectedAuthor中对应的NSArray中元素的个数
    }
    
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    if (component==0) {
        
        return _authors[row]; //思路:按自然顺序0,1,2排下来的
    }
    
    else{
        
        return [_books[_selectedAuthor] objectAtIndex:row];  //接着上面的思路:因为前面的作者列是按自然顺序0,1,2排列下来的，所以书名列也是按照第一个作者的作品自然排序的
    }
}


-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    if (component==0) {
        
        _selectedAuthor=_authors[row];  //只要第一作者列不变，第二列作品也不会变
        
        [self.picker reloadComponent:1]; //控制重写第二个列表,根据选中的作者来加载第二个列表
        
        [self.picker selectRow:0 inComponent:1 animated:YES]; //每当选择作者列的时候，让书名列默认选中的都是第一行(Row为0的那一行)
        
        tmpRow_Author=row; //将作者列选择的行号记录下来
        
        flagBook=NO; //每当用户选择了新的作者,其对应的书名也必须是不同的，所以flagBook设为NO表明当前用户只手动选择了作者列而未手动选择书名列,让其保持默认选中书名列的第一行(Row=0的那一行)
        
    }
    
    if (component==1) {
        
        tmpRow_Book=row; //将书名列选择的行号记录下来
        
        flagBook=YES; //用户手动选择了书名列滚动选择器，标志位设为YES
    }
    
}



- (IBAction)confirm:(id)sender {
    
    //作者
    tmpAuthor=_authors[tmpRow_Author];
    
    self.tf_Author.text=tmpAuthor;
    
    
    
    //书
    if (flagBook) {   //flagBook==YES的话,也就是手动选择了书名列
        
        tmpBook=[_books[tmpAuthor] objectAtIndex:tmpRow_Book];

    }
    
    else{ //flagBook==NO的话,也就是如果没有手动选择书名列，默认输入第一项(Row=0的那一行)
        
        tmpBook=[_books[tmpAuthor] objectAtIndex:0];
    }
    
    self.tf_BookName.text=tmpBook;
    
}

//UIPickerViewDelegate中定义的方法,该方法返回的CGFloat将作为UIPickerView中指定的宽度
-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    
    if (component==0) {
        
        return 90;
    }
    
    else{
        
        return 200;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

