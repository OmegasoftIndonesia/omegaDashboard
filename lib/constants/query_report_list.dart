class QueryReportList {
  static const queryDepartment =
      "SELECT DISTINCT(Dept) FROM MenuGrup m WITH(NOLOCK), ReportList r WITH(NOLOCK) WHERE m.ObjectName LIKE 'R____' AND m.ObjectName='R'+CAST(r.ID AS VARCHAR(100)) AND r.Dept NOT IN('PAJAK', 'ACCOUNTING') AND m.Jabatan='ADMINISTRATOR' ORDER BY Dept";

  static String queryDetailDepartment(String department) =>
      "SELECT DISTINCT r.Title, r.ID FROM menugrup m WITH(NOLOCK), reportlist r WITH(NOLOCK) WHERE m.objectname LIKE 'R%' AND m.objectname='R'+cast(r.id as varchar(100))AND r.Dept='$department' AND m.Jabatan='ADMINISTRATOR' ORDER BY r.title";
}
