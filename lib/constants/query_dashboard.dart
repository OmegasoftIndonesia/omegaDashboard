class QueryDashboard {
  static String getBranchesQuery(String email) {
    return "SELECT k.Cabang,k.NamaCabang, k.JenisUsaha, s.Kode from Staff s, StaffCabang scb, Kategori k where s.Email = '$email' and s.kode = scb.staff and k.Cabang = scb.Cabang";
  }

  static String dashBoardQuery(
          String branch, cabang, pilih, String tglAwal, String tglAkhir) =>
      "DECLARE @Cabang VARCHAR(10),@pilih VARCHAR(40),@Branch VARCHAR(10)\n" +
      "SET @Branch='$branch'\n" +
      "SET @Cabang='$cabang'\n" +
      "SET @pilih='$pilih'\n" +
      "\n" +
      "DECLARE @TGL1 as DateTime, @TGL2 as DateTime, @Periode VARCHAR(10), @PerkiraanLRBerjalan VARCHAR(30)\n" +
      "DECLARE @Now DATETIME SET @Now=DATEADD(day, DATEDIFF(Day, 0, getdate()), 0)\n" +
      "if (@pilih='Today') BEGIN SET @TGL1 = dateadd(DAY, datediff(DAY, 0, getdate()), 0) SET @TGL2 =  getdate()  END\n" +
      "else if (@pilih='Yesterday') BEGIN SET @TGL1 =  dateadd(DAY, -1 , dateadd(DAY, datediff(DAY, 0, getdate()), 0)) SET @TGL2 = dateadd(SECOND, -1,dateadd(DAY, datediff(DAY, 0, getdate()), 0)) END\n" +
      "else if (@pilih='This Week') BEGIN  SET @TGL1 = DATEADD(wk,DATEDIFF(wk,0,@Now),-1) SET @TGL2 = DATEADD(wk,DATEDIFF(wk,0,@Now),5)   END\n" +
      "else if (@pilih='Last Week') BEGIN  SET @TGL1 = DATEADD(wk,DATEDIFF(wk,7,@Now),-1) SET @TGL2 = DATEADD(wk,DATEDIFF(wk,7,@Now),5) END\n" +
      "else if (@pilih='This Month') BEGIN SET @TGL1 = dateadd(MONTH, datediff(MONTH, 0, getdate()), 0) SET @TGL2 =  getdate()  END\n" +
      "else if (@pilih='Last Month') BEGIN SET @TGL1 = dateadd(MONTH, -1 , dateadd(MONTH, datediff(MONTH, 0, getdate()), 0)) SET @TGL2 = dateadd(SECOND, -1,dateadd(MONTH, datediff(MONTH, 0, getdate()), 0)) END\n" +
      "else if (@pilih='This Year') BEGIN SET @TGL1 = dateadd(YEAR, datediff(YEAR, 0, getdate()), 0) SET @TGL2 =  getdate()  END\n" +
      "else if (@pilih='Last Year') BEGIN SET @TGL1 = dateadd(YEAR, -1 , dateadd(YEAR, datediff(YEAR, 0, getdate()), 0)) SET @TGL2 = dateadd(SECOND, -1,dateadd(YEAR, datediff(YEAR, 0, getdate()), 0)) END\n" +
      "else if (@pilih='Custom') BEGIN SET @TGL1 = convert(datetime, '$tglAwal', 120) SET @TGL2 = convert(datetime, '$tglAkhir', 120) END\n" +
      "\n" +
      "SET @Periode=0\n" +
      "IF (@pilih='This Month') BEGIN SET @Periode=(SELECT MAX(Kode) FROM MstPeriode WITH(NOLOCK)) END\n" +
      "IF (@pilih='Last Month') BEGIN SET @Periode=(SELECT MAX(Kode) FROM MstPeriode WITH(NOLOCK) WHERE Kode<(SELECT MAX(Kode) FROM MstPeriode WITH(NOLOCK))) END\n" +
      "\n" +
      "SELECT TOP 1 @PerkiraanLRBerjalan=SaldoPeriodeBerjalan FROM Kategori WITH(NOLOCK) WHERE Cabang=@Cabang\n" +
      "\n" +
      "IF OBJECT_ID('tempdb.dbo.#KDNOT', 'U') IS NOT NULL DROP TABLE #KDNOT\n" +
      "select m.kodenota into #KDNOT from masterjual m WITH(NOLOCK)\n" +
      "where m.tgl between @TGL1 and @TGL2 and m.Kodenota like @Cabang + '%' and m.Keterangan not like '%<BATAL>%' and substring(m.Kodenota,10,1) IN ('V','N')\n" +
      "\n" +
      "DECLARE @Potongan NUMERIC(18,4), @PotonganInvoice NUMERIC(18,4), @PotonganPOS NUMERIC(18,4)\n" +
      "SET @Potongan=ISNULL((SELECT SUM(Total) FROM MasterPiutang WITH(NOLOCK) WHERE KodeNota LIKE @Cabang+'%' AND Keterangan NOT LIKE '%<BATAL>%' AND SUBSTRING(Kodenota,10,1) IN('V','P') AND Tgl BETWEEN @TGL1 AND @TGL2 AND Status='POTONGAN'),0)\n" +
      "SET @PotonganInvoice=ISNULL((SELECT SUM(Total) FROM MasterPiutang WITH(NOLOCK) WHERE KodeNota LIKE @Cabang+'%' AND Keterangan NOT LIKE '%<BATAL>%' AND SUBSTRING(Kodenota,10,1) IN('P') AND Tgl BETWEEN @TGL1 AND @TGL2 AND Status='POTONGAN'),0)\n" +
      "SET @PotonganPOS=ISNULL((SELECT SUM(Total) FROM MasterPiutang WITH(NOLOCK) WHERE KodeNota LIKE @Cabang+'%' AND Keterangan NOT LIKE '%<BATAL>%' AND SUBSTRING(Kodenota,10,1) IN('V') AND Tgl BETWEEN @TGL1 AND @TGL2 AND Status='POTONGAN'),0)\n" +
      "\n" +
      "DECLARE @NetSales NUMERIC(18,4),@GrandTotalSales NUMERIC(18,4),@TotalBayar NUMERIC(18,4),@TotalTransaksi NUMERIC(18,4),@avgTransaksi NUMERIC(18,4)\n" +
      "select @NetSales = (sum(m.Total)-sum(m.Disc)), @GrandTotalSales = (sum(m.Total)-sum(m.Disc))+sum(m.jasapelayanan)+sum(m.ppn), @TotalBayar = sum(m.Total),@TotalTransaksi = count(m.kodenota),@avgTransaksi = sum(m.TotalBayar-ISNULL(mp.Total,0))/count(m.kodenota)\n" +
      "from MasterJual m WITH(NOLOCK) LEFT JOIN MasterPiutang mp WITH(NOLOCK) ON mp.Keterangan=m.KodeNota AND mp.Status='POTONGAN' AND mp.KodeNota LIKE @Cabang+'%'\n" +
      "where m.Kodenota like @Cabang + '%' and m.Keterangan not like '%<BATAL>%' and substring(m.Kodenota,10,1) IN ('V','N')  and (m.Tgl between @TGL1 and @TGL2)\n" +
      "\n" +
      "DECLARE @NetSalesInvoice NUMERIC(18,4), @grandTotalSalesInvoice NUMERIC(18,4),@TotalBayarInvoice NUMERIC(18,4),@TotalTransaksiInvoice NUMERIC(18,4),@avgTransaksiInvoice NUMERIC(18, 4)\n" +
      "select @NetSalesInvoice = (sum(m.Total)-sum(m.Disc)), @grandTotalSalesInvoice= (sum(m.Total)-sum(m.Disc))+sum(m.jasapelayanan)+sum(m.ppn), @TotalBayarInvoice = sum(m.Total), @TotalTransaksiInvoice=count(m.KodeNota), @avgTransaksiInvoice=sum(m.TotalBayar-ISNULL(mp.Total,0))/count(m.KodeNota)  from MasterJual m LEFT JOIN MasterPiutang mp ON mp.Keterangan=m.KodeNota AND mp.Status='POTONGAN' AND mp.KodeNota LIKE @Cabang+'%'\n" +
      "where m.KodeNota like @Cabang + '%' and m.Keterangan not like '%<BATAL>%' and SUBSTRING(m.KodeNota,10,1) IN ('N') and (m.Tgl between @TGL1 and @TGL2)\n" +
      "\n" +
      "DECLARE @NetSalesPOS NUMERIC(18,4), @grandTotalSalesPOS NUMERIC(18,4),@TotalBayarPOS NUMERIC(18,4),@TotalTransaksiPOS NUMERIC(18,4),@avgTransaksiPOS NUMERIC(18, 4)\n" +
      "select @NetSalesPOS = (sum(m.Total)-sum(m.disc)), @grandTotalSalesPOS= (sum(m.Total)-sum(m.Disc))+sum(m.jasapelayanan)+sum(m.ppn),@TotalBayarPOS = sum(m.Total), @TotalTransaksiPOS=count(m.KodeNota), @avgTransaksiPOS=sum(m.TotalBayar-ISNULL(mp.Total,0))/count(m.KodeNota)  from MasterJual m LEFT JOIN MasterPiutang mp ON mp.Keterangan=m.KodeNota AND mp.Status='POTONGAN' AND mp.KodeNota LIKE @Cabang+'%'where m.KodeNota like @Cabang + '%' and m.Keterangan not like '%<BATAL>%' and SUBSTRING(m.KodeNota,10,1) IN ('V') and (m.Tgl between @TGL1 and @TGL2)\n" +
      "DECLARE @GrupKategoriCabang varchar(50)\n" +
      "SET @GrupKategoriCabang=(select isnull(GrupKategoriCabang,'') GrupKategoriCabang from KategoriCabang WITH(NOLOCK) where branch=@Branch)\n" +
      "select case when m.[Status]='KARTU KREDIT' and @GrupKategoriCabang='NETTO' then 'USED BALANCE' else m.[Status] end Status , case when m.[Status]='TUNAI' then sum(m.Total-isnull(d.Jml,0)) else sum(m.Total) end Jumlah into #pembayaran\n" +
      "from MasterPiutang m WITH(NOLOCK) left outer join DetailPiutangLain d WITH(NOLOCK) ON m.Kodenota=d.Kodenota and d.Keterangan='KEMBALIAN'\n" +
      "where m.Kodenota like @Cabang + '%' and m.Keterangan not like '%<BATAL>%' and substring(m.Kodenota,10,1) IN ('V','P')  and (m.Tgl between @TGL1 and @TGL2) AND m.Status<>'POTONGAN'\n" +
      "group by m.[Status]\n" +
      "\n" +
      "DECLARE @OmzetHari NUMERIC(18,4)\n" +
      "select @OmzetHari=sum(m.Total) from MasterJual m WITH(NOLOCK)\n" +
      "where m.Kodenota like @Cabang + '%' and m.Keterangan not like '%<BATAL>%' and substring(m.Kodenota,10,1) IN ('V','N')  and m.Tgl=cast(floor(cast(getdate() as float)) as datetime)\n" +
      "\n" +
      "DECLARE @OmzetWeekEnd NUMERIC(18,4)\n" +
      "select @OmzetWeekEnd=sum(m.Total)/count(*) from MasterJual m WITH(NOLOCK)\n" +
      "where m.Kodenota like @Cabang + '%' and m.Keterangan not like '%<BATAL>%' and substring(m.Kodenota,10,1) IN ('V','N')  and DATENAME(dw, m.Tgl) IN ('Saturday', 'Sunday') \n" +
      "and m.Tgl between DATEADD(d,DATEDIFF(d,0,getdate()),-90) AND GETDATE()\n" +
      "\n" +
      "DECLARE @OmzetWeekDay NUMERIC(18,4)\n" +
      "select @OmzetWeekDay=sum(m.Total)/count(*) from MasterJual m WITH(NOLOCK)\n" +
      "where m.Kodenota like @Cabang + '%' and m.Keterangan not like '%<BATAL>%' and substring(m.Kodenota,10,1) IN ('V','N')  and DATENAME(dw, m.Tgl) NOT IN ('Saturday', 'Sunday')\n" +
      "and m.Tgl between DATEADD(d,DATEDIFF(d,0,getdate()),-90) AND GETDATE()\n" +
      "\n" +
      "DECLARE @OmzetSampaiHari NUMERIC(18,4)\n" +
      "select @OmzetSampaiHari=sum(m.Total) from MasterJual m WITH(NOLOCK)\n" +
      "where m.Kodenota like @Cabang + '%' and m.Keterangan not like '%<BATAL>%' and substring(m.Kodenota,10,1) IN ('V','N')\n" +
      "and m.Tgl between DATEADD(mm,DATEDIFF(mm,0,cast(floor(cast(getdate() as float)) as datetime)),0) and cast(floor(cast(getdate() as float)) as datetime)\n" +
      "\n" +
      "DECLARE @OmzetRataBulan NUMERIC(18,4)\n" +
      "select @OmzetRataBulan=sum(m.Total)/MONTH(getdate()) from MasterJual m WITH(NOLOCK)\n" +
      "where m.Kodenota like @Cabang + '%' and m.Keterangan not like '%<BATAL>%' and substring(m.Kodenota,10,1) IN ('V','N')  and YEAR(m.Tgl)=YEAR(getdate()) and MONTH(m.Tgl)<=MONTH(getdate())\n" +
      "\n" +
      "DECLARE @PelangganHari NUMERIC(18,4)\n" +
      "select @PelangganHari=sum(m.Total)/count(*) from MasterJual m WITH(NOLOCK)\n" +
      "where m.Kodenota like @Cabang + '%' and m.Keterangan not like '%<BATAL>%' and substring(m.Kodenota,10,1) IN ('V','N')  and m.Tgl=cast(floor(cast(getdate() as float)) as datetime)\n" +
      "\n" +
      "DECLARE @PelangganRata NUMERIC(18,4)\n" +
      "select @PelangganRata=sum(m.Total)/count(*) from MasterJual m WITH(NOLOCK)\n" +
      "where m.Kodenota like @Cabang + '%' and m.Keterangan not like '%<BATAL>%' and substring(m.Kodenota,10,1) IN ('V','N')\n" +
      "and m.Tgl between DATEADD(wk,DATEDIFF(wk,7,getdate()),-1) and DATEADD(wk,DATEDIFF(wk,7,getdate()),5)\n" +
      "\n" +
      "if (select object_id('tempdb..#toppelanggan')) is not null drop table #toppelanggan\n" +
      "select top 5 m.Cust, p.Perusahaan NamaPelanggan, count(*) Total INTO #toppelanggan\n" +
      "from MasterJual m WITH(NOLOCK), Pelanggan p WITH(NOLOCK)\n" +
      "where m.Kodenota like @Cabang + '%' and m.Keterangan not like '%<BATAL>%' and substring(m.Kodenota,10,1) IN ('V','N')  and (m.Tgl between @TGL1 and @TGL2)\n" +
      "and m.Cust=p.Kode group by m.Cust, p.Perusahaan order by Total desc\n" +
      "\n" +
      "if (select object_id('tempdb..#stocklimit')) is not null drop table #stocklimit\n" +
      "select p.Brg, b.Keterangan NamaBarang, sum(p.StokAkhir) StokAkhir, sum(isnull(s.StokLimit,0)) StokLimit into #stocklimit\n" +
      "from PeriodeBrg p WITH(NOLOCK) left outer join Stoklimit s WITH(NOLOCK) ON p.Brg=s.Brg and p.Gudang=s.Gudang , MstPeriode m WITH(NOLOCK), Barang b WITH(NOLOCK)\n" +
      "where cast(floor(cast(getdate() as float)) as datetime) between m.TglMulai and m.TglAkhir and p.Periode=m.Kode\n" +
      "and p.Gudang like @Cabang + '%' and right(p.Gudang,2)<>'ZZ' and p.Brg=b.Kode group by p.Brg, b.Keterangan having sum(p.StokAkhir)<sum(isnull(s.StokLimit,0))\n" +
      "\n" +
      "if (select object_id('tempdb..#HARIMINGGU')) is not null drop table #HARIMINGGU\n" +
      "DECLARE @DAY INT, @AMOUNTd MONEY, @HARI VARCHAR(10)\n" +
      "set @DAY= 1\n" +
      "CREATE TABLE #HARIMINGGU (AMOUNT MONEY , DAY VARCHAR(10) )\n" +
      "WHILE @DAy <= 7\n" +
      "BEGIN\n" +
      "select @AMOUNTd=isnull(sum(m.Total),0), @HARI=convert(Char(2), @DAY)  from MasterJual m WITH(NOLOCK)\n" +
      "where m.Kodenota like @Cabang + '%' and m.Keterangan not like '%<BATAL>%' and substring(m.Kodenota,10,1) IN ('V','N')  and (m.Tgl between @TGL1 and @TGL2) and (DATEPART(dw,m.Tgl) = @DAY)\n" +
      "\n" +
      "insert into #HARIMINGGU VALUES(@AMOUNTd, @HARI)\n" +
      "set @DAY=@DAY+1\n" +
      "END\n" +
      "\n" +
      "if (select object_id('tempdb..#JAM')) is not null drop table #JAM\n" +
      "DECLARE @HR INT, @AMOUNTh MONEY, @HOUR VARCHAR(10)\n" +
      "set @HR= 0\n" +
      "CREATE TABLE #JAM (AMOUNT MONEY , HOUR VARCHAR(10) )\n" +
      "WHILE @HR <> 24\n" +
      "BEGIN\n" +
      "select @AMOUNTh = isnull(sum(m.Total),0),@HOUR=convert(Char(2), @HR) from MasterJual m WITH(NOLOCK)\n" +
      "where m.Kodenota like @Cabang + '%' and m.Keterangan not like '%<BATAL>%' and substring(m.Kodenota,10,1) IN ('V','N')  and (m.CreateDate between @TGL1 and @TGL2) and DATEPART(hour,createdate) = @HR\n" +
      "\n" +
      "insert into #JAM VALUES(@AMOUNTh, @HOUR)\n" +
      "set @HR=@HR+1\n" +
      "END\n" +
      "\n" +
      "if (select object_id('tempdb..#topbarang')) is not null drop table #topbarang\n" +
      "select top 5 x.Brg kodebrg, x.keterangan Barang, x.Total, x.TotalHarga\n" +
      "INTO #topbarang\n" +
      "from\n" +
      "(\n" +
      "select top 5 d.Brg Brg, b.Keterangan Keterangan, COUNT(*) Total, SUM(d.HrgSatuan) AS TotalHarga\n" +
      "from #KDNOT m inner join DetailJual d WITH(NOLOCK) on d.KodeNota=m.KodeNota  join barang b on b.kode =d.brg\n" +
      "group by d.brg, b.keterangan order by total desc\n" +
      "union all\n" +
      "select top 5 d.JenisPekerjaan Brg, b.JenisPekerjaan Keterangan, COUNT(*) Total, SUM(d.HrgSatuan) AS TotalHarga\n" +
      "from #KDNOT m inner join DetailJualNonStok d WITH(NOLOCK) on d.KodeNota=m.KodeNota join JenisPekerjaan b on b.Kode=d.JenisPekerjaan and b.Branch=@Branch\n" +
      "group by d.JenisPekerjaan, b.JenisPekerjaan order by Total desc\n" +
      ") x\n" +
      "order by x.Total desc\n" +
      "\n" +
      "if (select object_id('tempdb..#topPisahBarang')) is not null drop table #topPisahBarang\n" +
      "select top 5 x.Brg kodebrg, x.keterangan Barang, x.Total  ,x.TotalHarga\n" +
      "INTO #topPisahBarang\n" +
      "from\n" +
      "(select top 5 d.Brg Brg, b.Keterangan Keterangan, COUNT(*) Total ,SUM(d.HrgSatuan) AS TotalHarga\n" +
      "from #KDNOT m inner join DetailJual d on d.KodeNota=m.KodeNota  join barang b on b.kode =d.brg\n" +
      "group by d.brg, b.keterangan order by total desc\n" +
      ") x\n" +
      "order by x.Total desc\n" +
      "if (select object_id('tempdb..#topPisahJasa')) is not null drop table #topPisahJasa\n" +
      "select top 5 x.Brg kodebrg, x.keterangan Barang, x.Total  ,x.TotalHarga\n" +
      "INTO #topPisahJasa\n" +
      "from(" +
      "select top 5 d.JenisPekerjaan Brg, b.JenisPekerjaan Keterangan, COUNT(*) Total , SUM(d.HrgSatuan) AS TotalHarga\n" +
      "from #KDNOT m inner join DetailJualNonStok d on d.KodeNota=m.KodeNota join JenisPekerjaan b on b.Kode=d.JenisPekerjaan and b.Branch=@Branch\n" +
      "group by d.JenisPekerjaan, b.JenisPekerjaan order by Total desc\n" +
      ") x\n" +
      "order by x.Total desc\n" +
      "if (select object_id('tempdb..#topkategori')) is not null drop table #topkategori\n" +
      "select top 5 x.kodekat, x.kategori, x.Total\n" +
      "INTO #topkategori\n" +
      "from\n" +
      "(\n" +
      "select top 5 b.kategori kodekat, (select bk.keterangan from brgkategori bk WITH(NOLOCK) where b.kategori = bk.kode) kategori, count(*) Total\n" +
      "from #KDNOT m inner join DetailJual d WITH(NOLOCK) on d.KodeNota=m.KodeNota join barang b WITH(NOLOCK) on b.kode =d.brg\n" +
      "group by b.kategori order by total desc\n" +
      "union all\n" +
      "select top 5 b.Kategori kodekat, (select bk.Keterangan from JasaKategori bk WITH(NOLOCK) where b.Kategori=bk.Kode) kategori, COUNT(*) Total\n" +
      "from #KDNOT m inner join DetailJualNonStok d WITH(NOLOCK) on d.KodeNota=m.KodeNota join JenisPekerjaan b WITH(NOLOCK) on b.Kode=d.JenisPekerjaan and b.Branch=@Branch\n" +
      "group by b.Kategori order by total desc\n" +
      ") x\n" +
      "order by x.Total\n" +
      "\n" +
      "if (select object_id('tempdb..#penjualanPerStaff')) is not null drop table #penjualanPerStaff\n" +
      "SELECT s.Kode, isnull(s.Email,'') Email, isnull(s.NamaAlias,'') NamaAlias, SUM(m.TotalBayar-ISNULL(mp.Total,0)) TotalBayar into #penjualanPerStaff\n" +
      "FROM MasterJual m WITH(NOLOCK) LEFT JOIN MasterPiutang mp WITH(NOLOCK) ON m.KodeNota=mp.Keterangan AND mp.Status='POTONGAN' AND mp.KodeNota LIKE @Cabang+'%', Staff s\n" +
      "WHERE m.KodeNota LIKE  @Cabang + '%'\n" +
      "AND SUBSTRING(m.KodeNota,10,1) IN ('V', 'N')\n" +
      "AND m.Tgl BETWEEN @TGL1 and @TGL2\n" +
      "AND m.CreateBy=s.Kode\n" +
      "GROUP BY s.Kode, s.Email,s.NamaAlias\n" +
      "\n" +
      "IF (SELECT OBJECT_ID('tempdb..#PersediaanDashboard')) IS NOT NULL DROP TABLE #PersediaanDashboard\n" +
      "SELECT x.Kode, SUM(x.Persediaan) Persediaan\n" +
      "INTO #PersediaanDashboard\n" +
      "FROM\n" +
      "(\n" +
      "SELECT 2 Kode, (SUM(d.Jml*dh.HrgPokok)*-1) Persediaan\n" +
      "FROM MasterKejadianStok m WITH(NOLOCK), DetailKejadianStok d WITH(NOLOCK), DetailKejadianStokHrgPokok dh WITH(NOLOCK)\n" +
      "WHERE m.KodeNota LIKE @Cabang + '%'\n" +
      "AND m.Tgl BETWEEN @TGL1 AND @TGL2\n" +
      "AND m.KodeNota=d.KodeNota\n" +
      "AND m.KodeNota=dh.KodeNota\n" +
      "AND d.Brg=dh.Brg\n" +
      "AND d.NoItem=dh.NoItem\n" +
      "UNION ALL\n" +
      "SELECT 2 Kode, SUM(d.Jml*dh.HrgPokok) Persediaan\n" +
      "FROM #KDNOT m, DetailJual d WITH(NOLOCK), DetailJualHrgPokok dh WITH(NOLOCK)\n" +
      "WHERE m.KodeNota=d.KodeNota\n" +
      "AND m.KodeNota=dh.KodeNota\n" +
      "AND d.Brg=dh.Brg\n" +
      "AND d.NoItem=dh.NoItem\n" +
      "AND d.Gudang=dh.Gudang\n" +
      ") x\n" +
      "GROUP BY x.Kode\n" +
      "UNION ALL\n" +
      "SELECT 1 Kode, ISNULL(@NetSales,0) Persediaan\n" +
      "\n" +
      "DECLARE @ReturSales NUMERIC(18,4)\n" +
      "SELECT @ReturSales = sum(m.TotalBayar)\n" +
      "FROM MasterJual m WITH(NOLOCK)\n" +
      "WHERE m.Kodenota like @Cabang + '%' and m.Keterangan not like '%<BATAL>%' and substring(m.Kodenota,10,2)='R/'  and (m.Tgl between @TGL1 and @TGL2)\n" +
      "\n" +
      "SELECT 'Q001' kode, '' kodeket,'Omzet Hari Ini' keterangan,isnull(@TotalBayar,0) nilai1,isnull(@TotalTransaksi,0) nilai2, isnull(@avgTransaksi,0)  nilai3,isnull(@grandtotalsales,0)-@Potongan grandtotalsales, isnull(@NetSales,0) netsales, ISNULL(@ReturSales,0)*(-1) ReturSales, ISNULL(@GrandTotalSales,0)-@Potongan+ISNULL(@ReturSales,0) GrandTotalSalesMinusReturSales\n" +
      "UNION \n" +
      "SELECT 'Q002', Status,'Jenis Pembayaran Hari Ini',isnull(Jumlah,0),0,0,0,0,0,0 from #pembayaran\n" +
      "UNION\n" +
      "select 'Q003', '','Omzet Hari Ini VS Rata-rata Weekend (Sabtu-Minggu) & WeekDay (Senin-Jumat)', isnull(@OmzetHari,0) OmzetHari, isnull(@OmzetWeekEnd,0) OmzetWeekEnd, isnull(@OmzetWeekDay,0) OmzetWeekDay,0,0,0,0\n" +
      "UNION\n" +
      "select 'Q004', '','Omzet Sampai Dengan Hari Ini VS Rata-rata per Bulan',isnull(@OmzetSampaiHari,0) OmzetSampaiHariIni, isnull(@OmzetRataBulan,0) OmzetRataRataBulan,0,0,0,0,0\n" +
      "UNION \n" +
      "select 'Q005', '','Rata-rata Pembelian per Pelanggan per Hari', isnull(@PelangganHari,0) PelangganHari, isnull(@PelangganRata,0) PelangganRataRata,0,0,0,0,0\n" +
      "UNION\n" +
      "SELECT 'Q006', Cust, NamaPelanggan, Total, 0, 0,0,0,0,0 FROM #toppelanggan\n" +
      "UNION\n" +
      "select 'Q007',Brg, NamaBarang , StokAkhir,StokLimit,0,0,0,0,0 FROM #stocklimit\n" +
      "UNION\n" +
      "SELECT 'Q008', kodebrg,Barang,isnull(Total,0),ISNULL(TotalHarga,0),0,0,0,0,0 from #topbarang\n" +
      "UNION\n" +
      "SELECT 'Q009', kodekat,kategori,isnull(Total,0),0,0,0,0,0,0 from #topkategori\n" +
      "UNION\n" +
      "SELECT 'Q010', '','',0, DAY,isnull(AMOUNT,0),0,0,0,0  from #HARIMINGGU\n" +
      "UNION\n" +
      "SELECT 'Q011', '','',0, HOUR,isnull(AMOUNT,0),0,0,0,0  from #JAM\n" +
      "UNION\n" +
      "SELECT 'Q012', '','',0, count(kodenota) jumlah,0,0,0,0,0  from #KDNOT\n" +
      "UNION\n" +
      "SELECT 'Q013', Kode,Case WHEN isnull(NamaAlias,'') = '' THEN Email ELSE NamaAlias END NamaStaff,isnull(TotalBayar,0),0,0,0,0,0,0  from #penjualanPerStaff\n" +
      "UNION\n" +
      "SELECT 'Q016', '','Invoice',ISNULL(@TotalBayarInvoice, 0) nilai1,ISNULL(@TotalTransaksiInvoice, 0) nilai2,ISNULL(@avgTransaksiInvoice, 0) nilai3,ISNULL(@grandTotalSalesInvoice,0)-@PotonganInvoice grandtotalsales,ISNULL(@NetSalesInvoice, 0) netsales,0,0\n" +
      "UNION\n" +
      "SELECT 'Q017', '','POS',ISNULL(@TotalBayarPOS,0) nilai1,ISNULL(@TotalTransaksiPOS,0) nilai2,ISNULL(@avgTransaksiPOS, 0) nilai3,ISNULL(@grandTotalSalesPOS,0)-@PotonganPOS grantotalsales,ISNULL(@NetSalesPOS,0) netsales,0,0\n" +
      "UNION\n" +
      "SELECT 'Q018', kodebrg,Barang,isnull(Total,0),ISNULL(TotalHarga,0),0,0,0,0,0 from #topPisahBarang\n" +
      "UNION\n" +
      "SELECT 'Q019', kodebrg,Barang,isnull(Total,0),ISNULL(TotalHarga,0),0,0,0,0,0 from #topPisahJasa\n" +
      "UNION\n" +
      "SELECT 'Q020', '', 'Laba Bersih', SaldoAkhir, 0, 0,0,0,0,0 FROM PeriodeAkuntansi WITH(NOLOCK) WHERE Periode=@Periode AND NoPerkiraan=@PerkiraanLRBerjalan\n" +
      "ORDER BY kode, nilai1 desc,nilai2 asc\n";
}
