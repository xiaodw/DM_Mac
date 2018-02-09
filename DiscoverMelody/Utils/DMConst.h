//
//  DMConst.h
//  DiscoverMelody
//

#import <Cocoa/Cocoa.h>


OBJC_EXTERN NSString * const Capture_Msg;
OBJC_EXTERN NSString * const Audio_Msg;
OBJC_EXTERN NSString * const Photo_Msg;
//弹窗选项 权限
OBJC_EXTERN NSString * const DMTitleDonAllow;
OBJC_EXTERN NSString * const DMTitleAllow;
OBJC_EXTERN NSString * const DMTitleGoSetting;
//弹窗选项 是否 比如是否重传
OBJC_EXTERN NSString * const DMTitleYes;
OBJC_EXTERN NSString * const DMTitleNO;
//弹窗选项 确定/取消
OBJC_EXTERN NSString * const DMTitleOK;
OBJC_EXTERN NSString * const DMTitleCancel;
//弹窗选项 建议升级、强制升级
OBJC_EXTERN NSString * const DMTitleUpgrade;
OBJC_EXTERN NSString * const DMTitleMustUpgrade;
//网络/错误
OBJC_EXTERN NSString * const DMTitleNetworkError;
OBJC_EXTERN NSString * const DMTitleNoTypeError;
OBJC_EXTERN NSString * const DMTextDataLoaddingError;
OBJC_EXTERN NSString * const DMTitleRefresh;
//通用术语
OBJC_EXTERN NSString * const DMStringIDStudent;
OBJC_EXTERN NSString * const DMStringIDTeacher;
//通用术语 课程状态
OBJC_EXTERN NSString * const DMKeyStatusNotStart;
OBJC_EXTERN NSString * const DMKeyStatusInclass;
OBJC_EXTERN NSString * const DMKeyStatusClassEnd;
OBJC_EXTERN NSString * const DMKeyStatusClassCancel;

/////////////////////////////////////////////////////////////////////////// 侧边栏
OBJC_EXTERN NSString * const DMTitleHome;
OBJC_EXTERN NSString * const DMTitleCourseList;
OBJC_EXTERN NSString * const DMTitleContactCustomerService;
OBJC_EXTERN NSString * const DMTitleExitLogin;
OBJC_EXTERN NSString * const Logout_Msg; //退出登录的二次确认

/////////////////////////////////////////////////////////////////////////// 登陆页
OBJC_EXTERN NSString * const DMTextPlaceholderAccount;
OBJC_EXTERN NSString * const DMTextPlaceholderPassword;
OBJC_EXTERN NSString * const DMTitleLogin;
OBJC_EXTERN NSString * const DMTextLoginDescribe;

/////////////////////////////////////////////////////////////////////////// 首页
OBJC_EXTERN NSString * const DMTextThisClassFile;
OBJC_EXTERN NSString * const DMTextJoinClass;
OBJC_EXTERN NSString * const DMTextStartClassTime;
OBJC_EXTERN NSString * const DMClassStartTimeYMDHM;
OBJC_EXTERN NSString * const DMTextRecentNotClass;

/////////////////////////////////////////////////////////////////////////// 视频上课页
OBJC_EXTERN NSString * const DMTextLiveRecording;
OBJC_EXTERN NSString * const DMTextLiveStartTimeInterval;
OBJC_EXTERN NSString * const DMTextLiveStudentNotEnter;
OBJC_EXTERN NSString * const DMTextLiveTeacherNotEnter;
OBJC_EXTERN NSString * const DMTextLiveDelayTime;
//关闭视频 主副标题
OBJC_EXTERN NSString * const DMTitleExitLiveRoom;
OBJC_EXTERN NSString * const DMTitleLiveAutoClose;

OBJC_EXTERN NSString * const DMAlertTitleCameraNotOpen; //作废文案，不会出现

/////////////////////////////////////////////////////////////////////////// 课件
OBJC_EXTERN NSString * const DMTextNotCourse;
//课件浮层 tab
OBJC_EXTERN NSString * const DMTitleMyUploadFild;
OBJC_EXTERN NSString * const DMTitleStudentUploadFild;
OBJC_EXTERN NSString * const DMTitleTeacherUploadFild;
//icon按钮
OBJC_EXTERN NSString * const DMTitleSelected;
OBJC_EXTERN NSString * const DMTitleUpload;
OBJC_EXTERN NSString * const DMTitleDeleted;
OBJC_EXTERN NSString * const DMTitleSync;
//课件 同步
OBJC_EXTERN NSString * const DMTitleImmediatelySync;
OBJC_EXTERN NSString * const DMTitleCloseSync;
OBJC_EXTERN NSString * const DMTitleCloseSyncMessage;
OBJC_EXTERN NSString * const DMAlertTitleNotSync;
//课件 删除确认 主副标题
OBJC_EXTERN NSString * const DMTitleDeletedPhotos;
OBJC_EXTERN NSString * const DMTitleDeletedPhotosMessage;
OBJC_EXTERN NSString * const DMTitleDeletedPhoto;
OBJC_EXTERN NSString * const DMTitleDeletedPhotoMessage;
//课件 上传重传 主副标题
OBJC_EXTERN NSString * const DMTitleUploadFail;
OBJC_EXTERN NSString * const DMTitleUploadFailMessage;

//课件 本地相册
OBJC_EXTERN NSString * const DMTitleAllPhotos;
OBJC_EXTERN NSString * const DMTitlePhoto;
//课件 上传
OBJC_EXTERN NSString * const DMTitleUploadCount;
OBJC_EXTERN NSString * const DMTitlePhotoUpload;
OBJC_EXTERN NSString * const DMTitlePhotoUploadCount;

/////////////////////////////////////////////////////////////////////////// 课程列表页
OBJC_EXTERN NSString * const DMTextNotClass;
//课程筛选
OBJC_EXTERN NSString * const DMTitleAllCourse;
OBJC_EXTERN NSString * const DMTitleAlreadyCourse;
OBJC_EXTERN NSString * const DMTitleNotStartCourse;
//列表项
OBJC_EXTERN NSString * const DMTextClassNumber;
OBJC_EXTERN NSString * const DMTextClassName;
OBJC_EXTERN NSString * const DMTextStudentName;
OBJC_EXTERN NSString * const DMTextTeacherName;
OBJC_EXTERN NSString * const DMTextDate;
OBJC_EXTERN NSString * const DMTextDetailDate;
OBJC_EXTERN NSString * const DMTextPeriod;
OBJC_EXTERN NSString * const DMTextStauts;
OBJC_EXTERN NSString * const DMTextFiles;
OBJC_EXTERN NSString * const DMTextQuestionnaire;
OBJC_EXTERN NSString * const DMTextMinutes;
OBJC_EXTERN NSString * const DMTitleClassRelook;

/////////////////////////////////////////////////////////////////////////// 问卷总结
OBJC_EXTERN NSString * const DMDateFormatterYMD;
OBJC_EXTERN NSString * const DMTitleStudentQuestionFild;
OBJC_EXTERN NSString * const DMTitleTeacherQuestionFild;

OBJC_EXTERN NSString * const DMTextPlaceholderMustFill;
OBJC_EXTERN NSString * const DMTitleSubmit;
//OBJC_EXTERN NSString * const DMQuestCommitStatusSuccess;
//OBJC_EXTERN NSString * const DMQuestCommitStatusFailed;
OBJC_EXTERN NSString * const DMTitleNoTeacherQuestionComFild;
//老师问卷状态
OBJC_EXTERN NSString * const DMTitleTeacherQuestionReviewFild;
OBJC_EXTERN NSString * const DMTitleTeacherQuestionFailedFild;
OBJC_EXTERN NSString * const DMTitleTeacherQuestionSuccessFild;


/////////////////////////////////////////////////////////////////////////// 客服页
OBJC_EXTERN NSString * const DMStringWeChatNumber;
OBJC_EXTERN NSString * const DMTextCustomerServiceDescribe;

/////////////////////////////////////////////////////////////////////////// 点播
OBJC_EXTERN NSString * const DMAlertTitleVedioNotExist;
OBJC_EXTERN NSString * const DMTitleVedioRetry;

/////////////////////////////////////////////////////////////////////////// 下拉、上拉
OBJC_EXTERN NSString * const DMRefreshHeaderIdleText;
OBJC_EXTERN NSString * const DMRefreshHeaderPullingText;
OBJC_EXTERN NSString * const DMRefreshHeaderRefreshingText;

OBJC_EXTERN NSString * const DMRefreshAutoFooterIdleText;
OBJC_EXTERN NSString * const DMRefreshAutoFooterRefreshingText;
OBJC_EXTERN NSString * const DMRefreshAutoFooterNoMoreDataText;

OBJC_EXTERN NSString * const DMRefreshBackFooterIdleText;
OBJC_EXTERN NSString * const DMRefreshBackFooterPullingText;
OBJC_EXTERN NSString * const DMRefreshBackFooterRefreshingText;
OBJC_EXTERN NSString * const DMRefreshBackFooterNoMoreDataText;

OBJC_EXTERN NSString * const DMRefreshHeaderLastTimeText;
OBJC_EXTERN NSString * const DMRefreshHeaderDateTodayText;
OBJC_EXTERN NSString * const DMRefreshHeaderNoneLastDateText;

