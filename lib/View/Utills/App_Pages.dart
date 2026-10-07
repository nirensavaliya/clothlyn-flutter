import 'package:clothlyn/Controller/Add_product_Controller.dart';
import 'package:clothlyn/Controller/Admin_Controller.dart';
import 'package:clothlyn/Controller/Admin_Home_Controller.dart';
import 'package:clothlyn/Controller/Admin_Salary_Paid_Controller.dart';
import 'package:clothlyn/Controller/Admin_Salary_Report_Controller.dart';
import 'package:clothlyn/Controller/Admin_Upad_Controller.dart';
import 'package:clothlyn/Controller/Alter_Controller.dart';
import 'package:clothlyn/Controller/Alter_Hisotry_Controller.dart';
import 'package:clothlyn/Controller/Companies_Controller.dart';
import 'package:clothlyn/Controller/Company_Report_Controller.dart';
import 'package:clothlyn/Controller/Design_Controller.dart';
import 'package:clothlyn/Controller/Employee_Controller.dart';
import 'package:clothlyn/Controller/Login_Controller.dart';
import 'package:clothlyn/Controller/Machine_Controller.dart';
import 'package:clothlyn/Controller/Product_Report_Controller.dart';
import 'package:clothlyn/Controller/Profile_Controller.dart';
import 'package:clothlyn/Controller/Reject_Controller.dart';
import 'package:clothlyn/Controller/Salary_Report_Controller.dart';
import 'package:clothlyn/Controller/Upad_Report_Controller.dart';
import 'package:clothlyn/View/Screen/Admin/Admin_Home/Admin_Home_Screen.dart';
import 'package:clothlyn/View/Screen/Admin/Admin_Home/Employee_Screen.dart';
import 'package:clothlyn/View/Screen/Admin/Admin_Salary_Paid/Admin_Salary_Master_Screen.dart';
import 'package:clothlyn/View/Screen/Admin/Admin_Salary_Paid/Admin_Salary_Paid_Screen.dart';
import 'package:clothlyn/View/Screen/Admin/Admin_Salary_Report_Screen/Admin_Salary_Report_Screen.dart';
import 'package:clothlyn/View/Screen/Admin/Companies/Alter_History_Screen.dart';
import 'package:clothlyn/View/Screen/Admin/Companies/Alter_Screen.dart';
import 'package:clothlyn/View/Screen/Admin/Companies/Companies_Screen.dart';
import 'package:clothlyn/View/Screen/Admin/Companies/Company_Report_Screen.dart';
import 'package:clothlyn/View/Screen/Admin/Companies/Design_Screen.dart';
import 'package:clothlyn/View/Screen/Admin/Companies/Machine_Screen.dart';
import 'package:clothlyn/View/Screen/Admin/Companies/Process_Screen.dart';
import 'package:clothlyn/View/Screen/Admin/Companies/Reject_Screen.dart';
import 'package:clothlyn/View/Screen/Admin/Non_Moving_item/Non_Moving_Item_Screen.dart';
import 'package:clothlyn/View/Screen/Admin/Product/Product_Report_Screen.dart';
import 'package:clothlyn/View/Screen/Home/Home_Screen.dart';
import 'package:clothlyn/View/Screen/Login/Login_Screen.dart';
import 'package:clothlyn/View/Screen/Profile/User_Profile_Screen.dart';
import 'package:get/get.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import '../../Controller/Admin_Salary_Master_Controller.dart';
import '../../Controller/Non_Moving_Controller.dart';
import '../../Controller/Process_Controller.dart';
import '../../Controller/Salary_Paid_Controller.dart';
import '../../Controller/Scanner_Controller.dart';
import '../../Controller/Splash_Controller.dart';
import '../Screen/Admin/Admin_Home/Admin_Screen.dart';
import '../Screen/Admin/Product/Product_Screen.dart';
import '../Screen/Admin/Upad_Report/Upad_Report_Screen.dart';
import '../Screen/Salary_Paid/Salary_Paid_Screen.dart';
import '../Screen/Salary_Report/Salary_Report_Screen.dart';
import '../Screen/Scanner/Scanner_Screen.dart';
import '../Screen/Splash/Splash_Screen.dart';
import '../Screen/Upad_Report/Upad_Report_Screen.dart';
import 'App_Routes.dart';

class AppPages {
  static final routes = [
    GetPage(
        name: AppRoutes.splashScreen,
        page: () =>  SplashScreen(),
        binding: BindingsBuilder(() {
        Get.lazyPut<SplashController>(() => SplashController());
      }),
    ),
    GetPage(
        name: AppRoutes.loginScreen,
        page: () => LoginScreen(),
        binding: BindingsBuilder(() {
        Get.lazyPut<LoginController>(() => LoginController(),fenix: true);
      }),
    ),
    GetPage(
      name: AppRoutes.homeScreen,
      page: () => HomeScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<LoginController>(() => LoginController(),fenix: true);
        Get.lazyPut<UserProfileController>(() => UserProfileController(),fenix: true);

      })
    ),
    GetPage(
      name: AppRoutes.adminHomeScreen,
      page: () => AdminHomeScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<AdminHomeController>(() => AdminHomeController(),fenix: true);
        Get.lazyPut<AddProductController>(() => AddProductController(),fenix: true);
        Get.lazyPut<LoginController>(() => LoginController(),fenix: true);
        Get.lazyPut<UserProfileController>(() => UserProfileController());
      }),
    ),
    GetPage(
      name: AppRoutes.productScreen,
      page: () => ProductScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<AddProductController>(() => AddProductController(),fenix: true);
      }),
    ),
    GetPage(
      name: AppRoutes.userProfileScreen,
      page: () => UserProfileScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<UserProfileController>(() => UserProfileController(),fenix: true);
        Get.lazyPut<LoginController>(() => LoginController(),fenix: true);
      }),
    ),
    GetPage(
      name: AppRoutes.adminSalaryReportScreen,
      page: () => AdminSalaryReportScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<AdminSalaryReportController>(() => AdminSalaryReportController(),fenix: true);
      }),
    ),
    GetPage(
      name: AppRoutes.nonMovingItemScreen,
      page: () => NonMovingItemScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<NonMovingController>(() => NonMovingController(),fenix: true);
      }),
    ),
    GetPage(
      name: AppRoutes.adminUPadReportScreen,
      page: () => AdminUpadReportScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<AdminHomeController>(() => AdminHomeController(),fenix: true);
        Get.lazyPut<AdminUpadController>(() => AdminUpadController(),fenix: true);
      }),
    ),
    GetPage(
      name: AppRoutes.productReportScreen,
      page: () => ProductReportScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<ProductReportController>(() => ProductReportController(),fenix: true);
      }),
    ),
    GetPage(
      name: AppRoutes.companiesScreen,
      page: () => CompaniesScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<CompaniesController>(() => CompaniesController(),fenix: true);
      }),
    ),
    GetPage(
      name: AppRoutes.companyReportScreen,
      page: () => CompanyReportScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<CompanyReportController>(() => CompanyReportController(),fenix: true);

      }),
    ),
    GetPage(
      name: AppRoutes.adminSalaryPaidScreen,
      page: () => AdminSalaryPaidScreen(),
        binding: BindingsBuilder(() {
          Get.lazyPut<AdminSalaryPaidController>(() => AdminSalaryPaidController(),fenix: true);
        })
    ),
    GetPage(
      name: AppRoutes.adminSalaryMasterScreen,
      page: () => AdminSalaryMasterScreen(),
        binding: BindingsBuilder(() {
          Get.lazyPut<AdminSalaryMasterController>(() => AdminSalaryMasterController(),fenix: true);
        })
    ),
    GetPage(
      name: AppRoutes.designScreen,
      page: () => DesignScreen(),
        binding: BindingsBuilder(() {
          Get.lazyPut<DesignController>(() => DesignController(),fenix: true);
        })
    ),
    GetPage(
      name: AppRoutes.processScreen,
      page: () => ProcessScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<ProcessController>(() => ProcessController(),fenix: true);
      }),
    ),
    GetPage(
      name: AppRoutes.adminScreen,
      page: () => AdminScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<AdminController>(() => AdminController(),fenix: true);
      }),
    ),
    GetPage(
      name: AppRoutes.employeeScreen,
      page: () => EmployeeScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<EmployeeController>(() => EmployeeController(),fenix: true);
      }),
    ),
    GetPage(
      name: AppRoutes.machineScreen,
      page: () => MachineScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<MachineController>(() => MachineController(),fenix: true);
      }),
    ),
    GetPage(
      name: AppRoutes.alterScreen,
      page: () => AlterScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<AlterController>(() => AlterController(),fenix: true);
      }),
    ),
    GetPage(
      name: AppRoutes.alterHistoryScreen,
      page: () => AlterHistoryScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<AlterHistoryController>(() => AlterHistoryController(),fenix: true);
      }),
    ),
    GetPage(
      name: AppRoutes.rejectScreen,
      page: () => RejectScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<RejectController>(() => RejectController(),fenix: true);
      }),
    ),
    // GetPage(
    //   name: AppRoutes.profileScreen,
    //   page: () => ProfileAccountBottomView(),
    // ),
    GetPage(
      name: AppRoutes.salaryReportScreen,
      page: () => SalaryReportScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<SalaryReportController>(() => SalaryReportController(),fenix: true);
      }),
    ),
    GetPage(
      name: AppRoutes.salaryPaidScreen,
      page: () => SalaryPaidScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<SalaryPaidController>(() => SalaryPaidController(),fenix: true);
      }),
    ),
    GetPage(
      name: AppRoutes.upadReportScreen,
      page: () => UpadReportScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<UpadReportController>(() => UpadReportController(),fenix: true);
      }),
    ),
    GetPage(
      name: AppRoutes.scannerScreen,
      page: () => ScannerScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<ScanUserController>(() => ScanUserController(),fenix: true);
      }),
    ),
  ];

}