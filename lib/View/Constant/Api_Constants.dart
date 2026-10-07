class ApiConstants {
  // static const String baseUrl = "https://moccasin-alligator-549486.hostingersite.com/api/";
  static const String baseUrl = "https://200.97.163.242.sslip.io/api/";

  static const String appRelease = "app/release";
  static const String getClientByCode = "users/client/";
  static const String requestOTP = "users/request-otp";
  static const String login = "users/login";
  static const String employeeLogin = "users/user-login";

  //admin
  static const String employees = "employees";
  static const String getAllProduct = "dashboard/search";
  /// Lot CRUD base: POST create, PUT/DELETE `dashboard/{id}` (not search)
  static const String productLot = "dashboard";
  static const String getAllAdmin = "/users/admins";
  static const String addAdmin = "users/admins";
  static const String updateAdmin = "users/admins";
  static const String deleteAdmin = "users/admins";
  static const String getAllProcess = "processes";
  static const String addProcess = "processes";
  static const String updateProcess = "processes";
  static const String deleteProcess = "processes";
  static const String getAllDesign = "designs";
  static const String addDesign  = "designs";
  static const String updateDesign  = "designs";
  static const String getProcess  = "processes";
  static const String getAllMachine  = "machines";
  static const String addMachine  = "machines";
  static const String deleteMachine  = "machines";
  static const String salaryMaster = "upads/salary-summary-master";
  static const String getAllSalaryPaid = "paid-salaries";
  static const String addSalaryPaid = "paid-salaries";
  static const String deleteSalaryPaid = "paid-salaries";
  static const String getAllCompany = "companies";
  static const String addCompany = "companies";
  static const String billing = "companies/billing/dates";
  static const String viewBill = "companies/billing/challan";
  static const String challan = "companies/billing/details";
  static const String viewBillExcel = "companies/billing/challan/excel";
  static const String challanBill = "companies/billing/excel";
  static const String getProductReport = "designs/product-report";
  static const String designNumbers = "designs/numbers";
  static const String uPad = "upads";
  static const String processReport = "dashboard/admin/process-reports";
  static const String designByNumber = "designs/by-number";
  static const String salaryExcel = "dashboard/admin/salary-report-new";
  static const String salaryReportNew = "dashboard/admin/salary-report-new";
  static const String nonMovingItem = "items/unchanged-status";
  static const String dashBoardSearch = "dashboard/search";
  static const String alter = "dashboard/alter-count";
  static const String alterEditLot = "rc-process/lot";
  static const String alterHistory = "dashboard/alter-done-history";
  static const String reject = "dashboard/reject-list";
  static const String salaryMasterView  = "upads/salary-master";
  static const String getDashboardByLookupKey  = "dashboard";
  static const String salaryPaidImportDemo = "paid-salaries/import-demo";
  static const String salaryPaidImport = "paid-salaries/import";

  //Scan :-
  static const String scanProcess = "scan/process";
  static const String rcProcess = "rc-process";

  static const String salaryReport = "dashboard/user/process-report";


  static const String verifyOtp = "users/verify-otp";
  static const String logOut = "users/logout";

}