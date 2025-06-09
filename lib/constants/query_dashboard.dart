class QueryDashboard {
  static String getBranchesQuery(String email) {
    return "SELECT k.Cabang,k.NamaCabang, k.JenisUsaha, s.Kode from Staff s, StaffCabang scb, Kategori k where s.Email = '$email' and s.kode = scb.staff and k.Cabang = scb.Cabang";
  }

  static String dashBoardQuery(
          String branch, cabang, pilih, String tglAwal, String tglAkhir) =>"""
          SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
          DECLARE @Cabang VARCHAR(10),@pilih VARCHAR(40),@Branch VARCHAR(10)
SET @Branch='$branch'
SET @Cabang='$cabang'
SET @pilih='$pilih'

DECLARE @TGL1 as DateTime, @TGL2 as DateTime, @Periode VARCHAR(10), @PerkiraanLRBerjalan VARCHAR(30)
DECLARE @Now DATETIME SET @Now=DATEADD(day, DATEDIFF(Day, 0, getdate()), 0)
if (@pilih='Today') BEGIN SET @TGL1 = dateadd(DAY, datediff(DAY, 0, getdate()), 0) SET @TGL2 =  getdate()  END
else if (@pilih='Yesterday') BEGIN SET @TGL1 =  dateadd(DAY, -1 , dateadd(DAY, datediff(DAY, 0, getdate()), 0)) SET @TGL2 = dateadd(SECOND, -1,dateadd(DAY, datediff(DAY, 0, getdate()), 0)) END
else if (@pilih='This Week') BEGIN  SET @TGL1 = DATEADD(wk,DATEDIFF(wk,0,@Now),-1) SET @TGL2 = DATEADD(wk,DATEDIFF(wk,0,@Now),5)   END
else if (@pilih='Last Week') BEGIN  SET @TGL1 = DATEADD(wk,DATEDIFF(wk,7,@Now),-1) SET @TGL2 = DATEADD(wk,DATEDIFF(wk,7,@Now),5) END
else if (@pilih='This Month') BEGIN SET @TGL1 = dateadd(MONTH, datediff(MONTH, 0, getdate()), 0) SET @TGL2 =  getdate()  END
else if (@pilih='Last Month') BEGIN SET @TGL1 = dateadd(MONTH, -1 , dateadd(MONTH, datediff(MONTH, 0, getdate()), 0)) SET @TGL2 = dateadd(SECOND, -1,dateadd(MONTH, datediff(MONTH, 0, getdate()), 0)) END
else if (@pilih='This Year') BEGIN SET @TGL1 = dateadd(YEAR, datediff(YEAR, 0, getdate()), 0) SET @TGL2 =  getdate()  END
else if (@pilih='Last Year') BEGIN SET @TGL1 = dateadd(YEAR, -1 , dateadd(YEAR, datediff(YEAR, 0, getdate()), 0)) SET @TGL2 = dateadd(SECOND, -1,dateadd(YEAR, datediff(YEAR, 0, getdate()), 0)) END
else if (@pilih='Custom') BEGIN SET @TGL1 = convert(datetime, '$tglAwal', 120) SET @TGL2 = convert(datetime, '$tglAkhir', 120) END

SET @Periode=0
IF (@pilih='This Month') BEGIN SET @Periode=(SELECT MAX(Kode) FROM MstPeriode WITH(NOLOCK)) END
IF (@pilih='Last Month') BEGIN SET @Periode=(SELECT MAX(Kode) FROM MstPeriode WITH(NOLOCK) WHERE Kode<(SELECT MAX(Kode) FROM MstPeriode WITH(NOLOCK))) END

SELECT TOP 1 @PerkiraanLRBerjalan=SaldoPeriodeBerjalan FROM Kategori WITH(NOLOCK) WHERE Cabang=@Cabang

IF OBJECT_ID('tempdb.dbo.#KDNOT', 'U') IS NOT NULL DROP TABLE #KDNOT
select m.kodenota into #KDNOT from masterjual m WITH(NOLOCK)
where m.tgl between @TGL1 and @TGL2 and m.Kodenota like @Cabang + '%' and m.Keterangan not like '%<BATAL>%' and substring(m.Kodenota,10,1) IN ('V','N')

-- tambahan potongan invoice dan pos
DECLARE @Potongan NUMERIC(18,4), @PotonganInvoice NUMERIC(18,4), @PotonganPOS NUMERIC(18,4)
SET @Potongan=ISNULL((SELECT SUM(Total) FROM MasterPiutang WITH(NOLOCK) WHERE KodeNota LIKE @Cabang+'%' AND Keterangan NOT LIKE '%<BATAL>%' AND SUBSTRING(Kodenota,10,1) IN('V','P') AND Tgl BETWEEN @TGL1 AND @TGL2 AND Status='POTONGAN'),0)
SET @PotonganInvoice=ISNULL((SELECT SUM(Total) FROM MasterPiutang WITH(NOLOCK) WHERE KodeNota LIKE @Cabang+'%' AND Keterangan NOT LIKE '%<BATAL>%' AND SUBSTRING(Kodenota,10,1) IN('P') AND Tgl BETWEEN @TGL1 AND @TGL2 AND Status='POTONGAN'),0)
SET @PotonganPOS=ISNULL((SELECT SUM(Total) FROM MasterPiutang WITH(NOLOCK) WHERE KodeNota LIKE @Cabang+'%' AND Keterangan NOT LIKE '%<BATAL>%' AND SUBSTRING(Kodenota,10,1) IN('V') AND Tgl BETWEEN @TGL1 AND @TGL2 AND Status='POTONGAN'),0)
-- =====================================

DECLARE @NetSales NUMERIC(18,4),@GrandTotalSales NUMERIC(18,4),@TotalBayar NUMERIC(18,4),@TotalTransaksi NUMERIC(18,4),@avgTransaksi NUMERIC(18,4)
select @NetSales = (sum(m.Total)-sum(m.Disc)), @GrandTotalSales = (sum(m.Total)-sum(m.Disc))+sum(m.jasapelayanan)+sum(m.ppn), @TotalBayar = sum(m.Total),@TotalTransaksi = count(m.kodenota),@avgTransaksi = sum(m.TotalBayar-ISNULL(mp.Total,0))/count(m.kodenota)
from MasterJual m WITH(NOLOCK) LEFT JOIN MasterPiutang mp WITH(NOLOCK) ON mp.Keterangan=m.KodeNota AND mp.Status='POTONGAN' AND mp.KodeNota LIKE @Cabang+'%'
where m.Kodenota like @Cabang + '%' and m.Keterangan not like '%<BATAL>%' and substring(m.Kodenota,10,1) IN ('V','N')  and (m.Tgl between @TGL1 and @TGL2)


-- invoice
DECLARE @NetSalesInvoice NUMERIC(18,4), @grandTotalSalesInvoice NUMERIC(18,4),@TotalBayarInvoice NUMERIC(18,4),@TotalTransaksiInvoice NUMERIC(18,4),@avgTransaksiInvoice NUMERIC(18, 4)
select @NetSalesInvoice = (sum(m.Total)-sum(m.Disc)), @grandTotalSalesInvoice= (sum(m.Total)-sum(m.Disc))+sum(m.jasapelayanan)+sum(m.ppn), @TotalBayarInvoice = sum(m.Total), @TotalTransaksiInvoice=count(m.KodeNota), @avgTransaksiInvoice=sum(m.TotalBayar-ISNULL(mp.Total,0))/count(m.KodeNota)  from MasterJual m LEFT JOIN MasterPiutang mp ON mp.Keterangan=m.KodeNota AND mp.Status='POTONGAN' AND mp.KodeNota LIKE @Cabang+'%'
where m.KodeNota like @Cabang + '%' and m.Keterangan not like '%<BATAL>%' and SUBSTRING(m.KodeNota,10,1) IN ('N') and (m.Tgl between @TGL1 and @TGL2)
-- pos
DECLARE @NetSalesPOS NUMERIC(18,4), @grandTotalSalesPOS NUMERIC(18,4),@TotalBayarPOS NUMERIC(18,4),@TotalTransaksiPOS NUMERIC(18,4),@avgTransaksiPOS NUMERIC(18, 4)
select @NetSalesPOS = (sum(m.Total)-sum(m.disc)), @grandTotalSalesPOS= (sum(m.Total)-sum(m.Disc))+sum(m.jasapelayanan)+sum(m.ppn),@TotalBayarPOS = sum(m.Total), @TotalTransaksiPOS=count(m.KodeNota), @avgTransaksiPOS=sum(m.TotalBayar-ISNULL(mp.Total,0))/count(m.KodeNota)  from MasterJual m LEFT JOIN MasterPiutang mp ON mp.Keterangan=m.KodeNota AND mp.Status='POTONGAN' AND mp.KodeNota LIKE @Cabang+'%'where m.KodeNota like @Cabang + '%' and m.Keterangan not like '%<BATAL>%' and SUBSTRING(m.KodeNota,10,1) IN ('V') and (m.Tgl between @TGL1 and @TGL2)
--===============

if (select object_id('tempdb..#pembayaran')) is not null drop table #pembayaran

DECLARE @GrupKategoriCabang varchar(50)
SET @GrupKategoriCabang=(select isnull(GrupKategoriCabang,'') GrupKategoriCabang from KategoriCabang WITH(NOLOCK) where branch=@Branch)
select case when m.[Status]='KARTU KREDIT' and @GrupKategoriCabang='NETTO' then 'USED BALANCE' else m.[Status] end Status , case when m.[Status]='TUNAI' then sum(m.Total-isnull(d.Jml,0)) else sum(m.Total) end Jumlah into #pembayaran
from MasterPiutang m WITH(NOLOCK) left outer join DetailPiutangLain d WITH(NOLOCK) ON m.Kodenota=d.Kodenota and d.Keterangan='KEMBALIAN'
where m.Kodenota like @Cabang + '%' and m.Keterangan not like '%<BATAL>%' and substring(m.Kodenota,10,1) IN ('V','P')  and (m.Tgl between @TGL1 and @TGL2) AND m.Status<>'POTONGAN'
group by m.[Status]

DECLARE @OmzetHari NUMERIC(18,4)
select @OmzetHari=sum(m.Total) from MasterJual m WITH(NOLOCK)
where m.Kodenota like @Cabang + '%' and m.Keterangan not like '%<BATAL>%' and substring(m.Kodenota,10,1) IN ('V','N')  and m.Tgl=cast(floor(cast(getdate() as float)) as datetime)

DECLARE @OmzetWeekEnd NUMERIC(18,4)
select @OmzetWeekEnd=sum(m.Total)/count(*) from MasterJual m WITH(NOLOCK)
where m.Kodenota like @Cabang + '%' and m.Keterangan not like '%<BATAL>%' and substring(m.Kodenota,10,1) IN ('V','N')  and DATENAME(dw, m.Tgl) IN ('Saturday', 'Sunday') 
and m.Tgl between DATEADD(d,DATEDIFF(d,0,getdate()),-90) AND GETDATE()

DECLARE @OmzetWeekDay NUMERIC(18,4)
select @OmzetWeekDay=sum(m.Total)/count(*) from MasterJual m WITH(NOLOCK)
where m.Kodenota like @Cabang + '%' and m.Keterangan not like '%<BATAL>%' and substring(m.Kodenota,10,1) IN ('V','N')  and DATENAME(dw, m.Tgl) NOT IN ('Saturday', 'Sunday')
and m.Tgl between DATEADD(d,DATEDIFF(d,0,getdate()),-90) AND GETDATE()

DECLARE @OmzetSampaiHari NUMERIC(18,4)
select @OmzetSampaiHari=sum(m.Total) from MasterJual m WITH(NOLOCK)
where m.Kodenota like @Cabang + '%' and m.Keterangan not like '%<BATAL>%' and substring(m.Kodenota,10,1) IN ('V','N')
and m.Tgl between DATEADD(mm,DATEDIFF(mm,0,cast(floor(cast(getdate() as float)) as datetime)),0) and cast(floor(cast(getdate() as float)) as datetime)

DECLARE @OmzetRataBulan NUMERIC(18,4)
select @OmzetRataBulan=sum(m.Total)/MONTH(getdate()) from MasterJual m WITH(NOLOCK)
where m.Kodenota like @Cabang + '%' and m.Keterangan not like '%<BATAL>%' and substring(m.Kodenota,10,1) IN ('V','N')  and YEAR(m.Tgl)=YEAR(getdate()) and MONTH(m.Tgl)<=MONTH(getdate())

DECLARE @PelangganHari NUMERIC(18,4)
select @PelangganHari=sum(m.Total)/count(*) from MasterJual m WITH(NOLOCK)
where m.Kodenota like @Cabang + '%' and m.Keterangan not like '%<BATAL>%' and substring(m.Kodenota,10,1) IN ('V','N')  and m.Tgl=cast(floor(cast(getdate() as float)) as datetime)

DECLARE @PelangganRata NUMERIC(18,4)
select @PelangganRata=sum(m.Total)/count(*) from MasterJual m WITH(NOLOCK)
where m.Kodenota like @Cabang + '%' and m.Keterangan not like '%<BATAL>%' and substring(m.Kodenota,10,1) IN ('V','N')
and m.Tgl between DATEADD(wk,DATEDIFF(wk,7,getdate()),-1) and DATEADD(wk,DATEDIFF(wk,7,getdate()),5)

if (select object_id('tempdb..#toppelanggan')) is not null drop table #toppelanggan
select top 5 m.Cust, p.Perusahaan NamaPelanggan, count(*) Total INTO #toppelanggan
from MasterJual m WITH(NOLOCK), Pelanggan p WITH(NOLOCK)
where m.Kodenota like @Cabang + '%' and m.Keterangan not like '%<BATAL>%' and substring(m.Kodenota,10,1) IN ('V','N')  and (m.Tgl between @TGL1 and @TGL2)
and m.Cust=p.Kode group by m.Cust, p.Perusahaan order by Total desc

if (select object_id('tempdb..#stocklimit')) is not null drop table #stocklimit
select p.Brg, b.Keterangan NamaBarang, sum(p.StokAkhir) StokAkhir, sum(isnull(s.StokLimit,0)) StokLimit into #stocklimit
from PeriodeBrg p WITH(NOLOCK) left outer join Stoklimit s WITH(NOLOCK) ON p.Brg=s.Brg and p.Gudang=s.Gudang , MstPeriode m WITH(NOLOCK), Barang b WITH(NOLOCK)
where cast(floor(cast(getdate() as float)) as datetime) between m.TglMulai and m.TglAkhir and p.Periode=m.Kode
and p.Gudang like @Cabang + '%' and right(p.Gudang,2)<>'ZZ' and p.Brg=b.Kode group by p.Brg, b.Keterangan having sum(p.StokAkhir)<sum(isnull(s.StokLimit,0))

if (select object_id('tempdb..#HARIMINGGU')) is not null drop table #HARIMINGGU
DECLARE @DAY INT, @AMOUNTd MONEY, @HARI VARCHAR(10)
set @DAY= 1
CREATE TABLE #HARIMINGGU (AMOUNT MONEY , DAY VARCHAR(10) )
WHILE @DAy <= 7
BEGIN
select @AMOUNTd=isnull(sum(m.Total),0), @HARI=convert(Char(2), @DAY)  from MasterJual m WITH(NOLOCK)
where m.Kodenota like @Cabang + '%' and m.Keterangan not like '%<BATAL>%' and substring(m.Kodenota,10,1) IN ('V','N')  and (m.Tgl between @TGL1 and @TGL2) and (DATEPART(dw,m.Tgl) = @DAY)

insert into #HARIMINGGU VALUES(@AMOUNTd, @HARI)
set @DAY=@DAY+1
END

if (select object_id('tempdb..#JAM')) is not null drop table #JAM
DECLARE @HR INT, @AMOUNTh MONEY, @HOUR VARCHAR(10)
set @HR= 0
CREATE TABLE #JAM (AMOUNT MONEY , HOUR VARCHAR(10) )
WHILE @HR <> 24
BEGIN
select @AMOUNTh = isnull(sum(m.Total),0),@HOUR=convert(Char(2), @HR) from MasterJual m WITH(NOLOCK)
where m.Kodenota like @Cabang + '%' and m.Keterangan not like '%<BATAL>%' and substring(m.Kodenota,10,1) IN ('V','N')  and (m.CreateDate between @TGL1 and @TGL2) and DATEPART(hour,createdate) = @HR

insert into #JAM VALUES(@AMOUNTh, @HOUR)
set @HR=@HR+1
END

if (select object_id('tempdb..#topbarang')) is not null drop table #topbarang  
 select top 5 x.Brg kodebrg, x.keterangan Barang, x.Total  ,x.TotalHarga
 INTO #topbarang  
 from  
 ( 
 select top 5 d.Brg Brg, b.Keterangan Keterangan, COUNT(*) Total ,SUM(d.HrgSatuan) AS TotalHarga
 from #KDNOT m inner join DetailJual d on d.KodeNota=m.KodeNota  join barang b on b.kode =d.brg  
 group by d.brg, b.keterangan order by total desc  
 union all 
 select top 5 d.JenisPekerjaan Brg, b.JenisPekerjaan Keterangan, COUNT(*) Total , SUM(d.HrgSatuan) AS TotalHarga
 from #KDNOT m inner join DetailJualNonStok d on d.KodeNota=m.KodeNota join JenisPekerjaan b on b.Kode=d.JenisPekerjaan and b.Branch=@Branch 
 group by d.JenisPekerjaan, b.JenisPekerjaan order by Total desc 
 ) x 
 order by x.Total desc 

  if (select object_id('tempdb..#topPisahBarang')) is not null drop table #topPisahBarang 
 select top 5 x.Brg kodebrg, x.keterangan Barang, x.Total  ,x.TotalHarga
 INTO #topPisahBarang  
 from  
 ( 
 select top 5 d.Brg Brg, b.Keterangan Keterangan, COUNT(*) Total ,SUM(d.HrgSatuan) AS TotalHarga
 from #KDNOT m inner join DetailJual d on d.KodeNota=m.KodeNota  join barang b on b.kode =d.brg  
 group by d.brg, b.keterangan order by total desc 
 ) x 
 order by x.Total desc 

   if (select object_id('tempdb..#topPisahJasa')) is not null drop table #topPisahJasa 
 select top 5 x.Brg kodebrg, x.keterangan Barang, x.Total  ,x.TotalHarga
 INTO #topPisahJasa  
 from  
 ( 
 select top 5 d.JenisPekerjaan Brg, b.JenisPekerjaan Keterangan, COUNT(*) Total , SUM(d.HrgSatuan) AS TotalHarga
 from #KDNOT m inner join DetailJualNonStok d on d.KodeNota=m.KodeNota join JenisPekerjaan b on b.Kode=d.JenisPekerjaan and b.Branch=@Branch 
 group by d.JenisPekerjaan, b.JenisPekerjaan order by Total desc 
 ) x 
 order by x.Total desc 

if (select object_id('tempdb..#topkategori')) is not null drop table #topkategori
select top 5 x.kodekat, x.kategori, x.Total
INTO #topkategori
from
(
select top 5 b.kategori kodekat, (select bk.keterangan from brgkategori bk WITH(NOLOCK) where b.kategori = bk.kode) kategori, count(*) Total
from #KDNOT m inner join DetailJual d WITH(NOLOCK) on d.KodeNota=m.KodeNota join barang b WITH(NOLOCK) on b.kode =d.brg
group by b.kategori order by total desc
union all
select top 5 b.Kategori kodekat, (select bk.Keterangan from JasaKategori bk WITH(NOLOCK) where b.Kategori=bk.Kode) kategori, COUNT(*) Total
from #KDNOT m inner join DetailJualNonStok d WITH(NOLOCK) on d.KodeNota=m.KodeNota join JenisPekerjaan b WITH(NOLOCK) on b.Kode=d.JenisPekerjaan and b.Branch=@Branch
group by b.Kategori order by total desc
) x
order by x.Total

if (select object_id('tempdb..#penjualanPerStaff')) is not null drop table #penjualanPerStaff
SELECT s.Kode, isnull(s.Email,'') Email, isnull(s.NamaAlias,'') NamaAlias, SUM(m.TotalBayar-ISNULL(mp.Total,0)) TotalBayar into #penjualanPerStaff
FROM MasterJual m WITH(NOLOCK) LEFT JOIN MasterPiutang mp WITH(NOLOCK) ON m.KodeNota=mp.Keterangan AND mp.Status='POTONGAN' AND mp.KodeNota LIKE @Cabang+'%', Staff s
WHERE m.KodeNota LIKE  @Cabang + '%'
AND SUBSTRING(m.KodeNota,10,1) IN ('V', 'N')
AND m.Tgl BETWEEN @TGL1 and @TGL2
AND m.CreateBy=s.Kode
GROUP BY s.Kode, s.Email,s.NamaAlias

IF (SELECT OBJECT_ID('tempdb..#PersediaanDashboard')) IS NOT NULL DROP TABLE #PersediaanDashboard
SELECT x.Kode, SUM(x.Persediaan) Persediaan
INTO #PersediaanDashboard
FROM
(
SELECT 2 Kode, (SUM(d.Jml*dh.HrgPokok)*-1) Persediaan
FROM MasterKejadianStok m WITH(NOLOCK), DetailKejadianStok d WITH(NOLOCK), DetailKejadianStokHrgPokok dh WITH(NOLOCK)
WHERE m.KodeNota LIKE @Cabang + '%'
AND m.Tgl BETWEEN @TGL1 AND @TGL2
AND m.KodeNota=d.KodeNota
AND m.KodeNota=dh.KodeNota
AND d.Brg=dh.Brg
AND d.NoItem=dh.NoItem
UNION ALL
SELECT 2 Kode, SUM(d.Jml*dh.HrgPokok) Persediaan
FROM #KDNOT m, DetailJual d WITH(NOLOCK), DetailJualHrgPokok dh WITH(NOLOCK)
WHERE m.KodeNota=d.KodeNota
AND m.KodeNota=dh.KodeNota
AND d.Brg=dh.Brg
AND d.NoItem=dh.NoItem
AND d.Gudang=dh.Gudang
) x
GROUP BY x.Kode
UNION ALL
SELECT 1 Kode, ISNULL(@NetSales,0) Persediaan

DECLARE @ReturSales NUMERIC(18,4)
SELECT @ReturSales = sum(m.TotalBayar)
FROM MasterJual m WITH(NOLOCK)
WHERE m.Kodenota like @Cabang + '%' and m.Keterangan not like '%<BATAL>%' and substring(m.Kodenota,10,2)='R/'  and (m.Tgl between @TGL1 and @TGL2)

SELECT 'Q001' kode, '' kodeket,'Omzet Hari Ini' keterangan,isnull(@TotalBayar,0) nilai1,isnull(@TotalTransaksi,0) nilai2, isnull(@avgTransaksi,0)  nilai3,isnull(@grandtotalsales,0)-@Potongan grandtotalsales, isnull(@NetSales,0) netsales, ISNULL(@ReturSales,0)*(-1) ReturSales, ISNULL(@GrandTotalSales,0)-@Potongan+ISNULL(@ReturSales,0) GrandTotalSalesMinusReturSales
UNION 
SELECT 'Q002', Status,'Jenis Pembayaran Hari Ini',isnull(Jumlah,0),0,0,0,0,0,0 from #pembayaran
UNION
select 'Q003', '','Omzet Hari Ini VS Rata-rata Weekend (Sabtu-Minggu) & WeekDay (Senin-Jumat)', isnull(@OmzetHari,0) OmzetHari, isnull(@OmzetWeekEnd,0) OmzetWeekEnd, isnull(@OmzetWeekDay,0) OmzetWeekDay,0,0,0,0
UNION
select 'Q004', '','Omzet Sampai Dengan Hari Ini VS Rata-rata per Bulan',isnull(@OmzetSampaiHari,0) OmzetSampaiHariIni, isnull(@OmzetRataBulan,0) OmzetRataRataBulan,0,0,0,0,0
UNION 
select 'Q005', '','Rata-rata Pembelian per Pelanggan per Hari', isnull(@PelangganHari,0) PelangganHari, isnull(@PelangganRata,0) PelangganRataRata,0,0,0,0,0
UNION
SELECT 'Q006', Cust, NamaPelanggan, Total, 0, 0,0,0,0,0 FROM #toppelanggan
UNION
select 'Q007',Brg, NamaBarang , StokAkhir,StokLimit,0,0,0,0,0 FROM #stocklimit
UNION
 SELECT 'Q008', kodebrg,Barang,isnull(Total,0),ISNULL(TotalHarga,0),0,0,0,0,0 from #topbarang    
UNION
SELECT 'Q009', kodekat,kategori,isnull(Total,0),0,0,0,0,0,0 from #topkategori
UNION
SELECT 'Q010', '','',0, DAY,isnull(AMOUNT,0),0,0,0,0  from #HARIMINGGU
UNION
SELECT 'Q011', '','',0, HOUR,isnull(AMOUNT,0),0,0,0,0  from #JAM
UNION
SELECT 'Q012', '','',0, count(kodenota) jumlah,0,0,0,0,0  from #KDNOT
UNION
SELECT 'Q013', Kode,Case WHEN isnull(NamaAlias,'') = '' THEN Email ELSE NamaAlias END NamaStaff,isnull(TotalBayar,0),0,0,0,0,0,0  from #penjualanPerStaff
UNION
SELECT 'Q016', '','Invoice',ISNULL(@TotalBayarInvoice, 0) nilai1,ISNULL(@TotalTransaksiInvoice, 0) nilai2,ISNULL(@avgTransaksiInvoice, 0) nilai3,ISNULL(@grandTotalSalesInvoice,0)-@PotonganInvoice grandtotalsales,ISNULL(@NetSalesInvoice, 0) netsales,0,0
UNION
SELECT 'Q017', '','POS',ISNULL(@TotalBayarPOS,0) nilai1,ISNULL(@TotalTransaksiPOS,0) nilai2,ISNULL(@avgTransaksiPOS, 0) nilai3,ISNULL(@grandTotalSalesPOS,0)-@PotonganPOS grantotalsales,ISNULL(@NetSalesPOS,0) netsales,0,0
 UNION 
  SELECT 'Q018', kodebrg,Barang,isnull(Total,0),ISNULL(TotalHarga,0),0,0,0,0,0 from #topPisahBarang
 UNION
  SELECT 'Q019', kodebrg,Barang,isnull(Total,0),ISNULL(TotalHarga,0),0,0,0,0,0 from #topPisahJasa

UNION
SELECT 'Q020', '', 'Laba Bersih', SaldoAkhir, 0, 0,0,0,0,0 FROM PeriodeAkuntansi WITH(NOLOCK) WHERE Periode=@Periode AND NoPerkiraan=@PerkiraanLRBerjalan
ORDER BY kode, nilai1 desc,nilai2 asc
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
""";
}
