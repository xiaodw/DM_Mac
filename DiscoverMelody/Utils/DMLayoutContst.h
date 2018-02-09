//
//  DMConst.h
//  DiscoverMelody
//

#import <Foundation/Foundation.h>

#if LANGUAGE_ENVIRONMENT == 0 //中文
//首页
#define DMHomeViewCellNameLabelWidth  298     //首页Cell 课程名label的宽度
#define DMHomeViewCellStatusLabelWidth 298   //首页Cell 课程状态label的宽度

#elif LANGUAGE_ENVIRONMENT == 1 //英文
//首页
#define DMHomeViewCellNameLabelWidth   (DMScreenWidth/2-80)   //首页Cell 课程名label的宽度
#define DMHomeViewCellStatusLabelWidth (DMScreenWidth/2-100)/3  //首页Cell 课程状态label的宽度

#endif



// DMBottomBarView
OBJC_EXTERN CGFloat const DMBottomBarViewUploadButtonLeft;
OBJC_EXTERN CGFloat const DMBottomBarViewUploadButtonWidth;
OBJC_EXTERN CGFloat const DMBottomBarViewDeleteButtonRight;

//侧滑菜单的Logo
OBJC_EXTERN NSString * const DMMenu_Logo;
//登录logo
OBJC_EXTERN NSString * const DMLogin_Logo;
//课程列表右上角的筛选列表
OBJC_EXTERN CGFloat const DMRightPullDownMenuRectWidth;//列表的宽度
OBJC_EXTERN CGFloat const DMRightPullDownMenuRectX;    //列表的X
OBJC_EXTERN CGFloat const DMRightPullDownMenuCellLeft; //cell的左间距
OBJC_EXTERN CGFloat const DMRightPullDownMenuCellRight;//cell的右间距

//首页
OBJC_EXTERN CGFloat const DMHomeViewTopViewRightLabelWidth; //右侧label的宽度
OBJC_EXTERN CGFloat const DMHomeViewTopViewRightLabelRight; //右侧label的右间距
OBJC_EXTERN CGFloat const DMHomeViewCellTimeLabelLeft;      //首页Cell 课程时间label的左间距
OBJC_EXTERN CGFloat const DMHomeViewReloadButtonWidth;      //点击重试按钮


// DMAssetsCollectionView
OBJC_EXTERN CGFloat const DMAssetsCollectionUploadButtonWidth;

// DMNavigationBar
OBJC_EXTERN CGFloat const DMNavigationBarLeftButtonWidth;

// DMCourseFilesController
OBJC_EXTERN CGFloat const DMCourseFilesNavigationLeftButtonWidth;
OBJC_EXTERN CGFloat const DMCourseFilesNavigationRightButtonRight;

// DMCourseListCell
OBJC_EXTERN CGFloat const DMCourseListCellStatusButtonWidth;

// DMLiveWillStartView
OBJC_EXTERN CGFloat const DMLiveWillStartDescribeLabelBottom;






