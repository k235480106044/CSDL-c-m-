CREATE DATABASE QuanLyCamDo;
GO
USE QuanLyCamDo;

CREATE TABLE KhachHang (
    KhachHangID INT IDENTITY PRIMARY KEY,
    TenKH NVARCHAR(100),
    SoDienThoai VARCHAR(15)
);

CREATE TABLE HopDong (
    HopDongID INT IDENTITY PRIMARY KEY,
    KhachHangID INT,
    NgayTao DATE,
    SoTienGoc FLOAT,
    Deadline1 DATE,
    Deadline2 DATE,
    TrangThai NVARCHAR(50),
    FOREIGN KEY (KhachHangID) REFERENCES KhachHang(KhachHangID)
);

CREATE TABLE TaiSan (
    TaiSanID INT IDENTITY PRIMARY KEY,
    TenTaiSan NVARCHAR(100),
    GiaTriDinhGia FLOAT,
    TrangThai NVARCHAR(50)
);

CREATE TABLE ChiTietHopDong (
    ID INT IDENTITY PRIMARY KEY,
    HopDongID INT,
    TaiSanID INT,
    FOREIGN KEY (HopDongID) REFERENCES HopDong(HopDongID),
    FOREIGN KEY (TaiSanID) REFERENCES TaiSan(TaiSanID)
);

CREATE TABLE GiaoDich (
    GiaoDichID INT IDENTITY PRIMARY KEY,
    HopDongID INT,
    NgayTra DATE,
    SoTienTra FLOAT,
    NguoiThu NVARCHAR(100),
    FOREIGN KEY (HopDongID) REFERENCES HopDong(HopDongID)
);
CREATE PROCEDURE sp_TaoHopDong
    @TenKH NVARCHAR(100),
    @SDT VARCHAR(15),
    @SoTienGoc FLOAT,
    @Deadline1 DATE,
    @Deadline2 DATE
AS
BEGIN
    DECLARE @KhachHangID INT

    INSERT INTO KhachHang(TenKH, SoDienThoai)
    VALUES(@TenKH, @SDT)

    SET @KhachHangID = SCOPE_IDENTITY()

    INSERT INTO HopDong(KhachHangID, NgayTao, SoTienGoc, Deadline1, Deadline2, TrangThai)
    VALUES(@KhachHangID, GETDATE(), @SoTienGoc, @Deadline1, @Deadline2, N'Đang vay')
END

-- Khách
INSERT INTO KhachHang(TenKH, SoDienThoai)
VALUES (N'Nguyễn Văn A', '0123456789');

-- Hợp đồng
INSERT INTO HopDong(KhachHangID, NgayTao, SoTienGoc, Deadline1, Deadline2, TrangThai)
VALUES (1, '2026-05-01', 1000000, '2026-05-05', '2026-05-10', N'Đang vay');

-- Tài sản
INSERT INTO TaiSan(TenTaiSan, GiaTriDinhGia, TrangThai)
VALUES (N'Điện thoại', 2000000, N'Đang cầm cố');

-- Liên kết
INSERT INTO ChiTietHopDong(HopDongID, TaiSanID)
VALUES (1,1);

EXEC sp_TaoHopDong 
    @TenKH = N'Trần Văn B',
    @SDT = '0999999999',
    @SoTienGoc = 2000000,
    @Deadline1 = '2026-05-10',
    @Deadline2 = '2026-05-20'
SELECT * FROM KhachHang ORDER BY KhachHangID DESC
SELECT * FROM HopDong ORDER BY HopDongID DESC

CREATE FUNCTION fn_CalcMoneyContract
(
    @HopDongID INT,
    @TargetDate DATE
)
RETURNS FLOAT
AS
BEGIN
    DECLARE @Goc FLOAT
    DECLARE @NgayTao DATE
    DECLARE @Deadline1 DATE

    SELECT @Goc = SoTienGoc, @NgayTao = NgayTao, @Deadline1 = Deadline1
    FROM HopDong WHERE HopDongID = @HopDongID

    DECLARE @SoNgay INT = DATEDIFF(DAY, @NgayTao, @TargetDate)

    DECLARE @LaiDon FLOAT
    SET @LaiDon = @Goc * 0.005 * @SoNgay

    IF @TargetDate <= @Deadline1
        RETURN @Goc + @LaiDon

    DECLARE @SoNgayQua INT = DATEDIFF(DAY, @Deadline1, @TargetDate)

    DECLARE @Tong FLOAT = @Goc + @LaiDon

    -- Lãi kép
    SET @Tong = @Tong * POWER(1.005, @SoNgayQua)

    RETURN @Tong
END
SELECT dbo.fn_CalcMoneyContract(1, '2026-05-04') AS TruocDeadline
SELECT dbo.fn_CalcMoneyContract(1, '2026-05-07') AS SauDeadline

CREATE PROCEDURE sp_TraNo
    @HopDongID INT,
    @SoTienTra FLOAT,
    @NguoiThu NVARCHAR(100)
AS
BEGIN
    DECLARE @TrangThai NVARCHAR(50)

    SELECT @TrangThai = TrangThai FROM HopDong WHERE HopDongID = @HopDongID

    IF @TrangThai = N'Đã thanh lý'
    BEGIN
        PRINT N'Không thể trả'
        RETURN
    END

    DECLARE @TongNo FLOAT
    SET @TongNo = dbo.fn_CalcMoneyContract(@HopDongID, GETDATE())

    INSERT INTO GiaoDich(HopDongID, NgayTra, SoTienTra, NguoiThu)
    VALUES(@HopDongID, GETDATE(), @SoTienTra, @NguoiThu)

    IF @SoTienTra >= @TongNo
        UPDATE HopDong SET TrangThai = N'Đã thanh toán'
        WHERE HopDongID = @HopDongID
    ELSE
        UPDATE HopDong SET TrangThai = N'Đang trả góp'
        WHERE HopDongID = @HopDongID
END

EXEC sp_TraNo 
    @HopDongID = 1,
    @SoTienTra = 500000,
    @NguoiThu = N'Admin'
SELECT * FROM GiaoDich
SELECT TrangThai FROM HopDong WHERE HopDongID = 1

EXEC sp_TraNo 
    @HopDongID = 1,
    @SoTienTra = 5000000,
    @NguoiThu = N'Admin'

SELECT 
    KH.TenKH,
    KH.SoDienThoai,
    HD.SoTienGoc,
    DATEDIFF(DAY, HD.Deadline1, GETDATE()) AS SoNgayQuaHan,
    dbo.fn_CalcMoneyContract(HD.HopDongID, GETDATE()) AS NoHienTai,
    dbo.fn_CalcMoneyContract(HD.HopDongID, DATEADD(MONTH,1,GETDATE())) AS NoSau1Thang
FROM HopDong HD
JOIN KhachHang KH ON KH.KhachHangID = HD.KhachHangID
WHERE GETDATE() > HD.Deadline1
AND HD.TrangThai != N'Đã thanh toán'
SELECT * FROM HopDong

CREATE TRIGGER trg_QuaHan
ON HopDong
AFTER UPDATE
AS
BEGIN
    UPDATE HopDong
    SET TrangThai = N'Nợ xấu'
    WHERE GETDATE() > Deadline1
    AND TrangThai = N'Đang vay'
END

UPDATE HopDong
SET Deadline1 = '2026-05-01',
    TrangThai = N'Đang vay'
WHERE HopDongID = 1
SELECT TrangThai FROM HopDong WHERE HopDongID = 1

CREATE TRIGGER trg_ThanhLy
ON HopDong
AFTER UPDATE
AS
BEGIN
    UPDATE TaiSan
    SET TrangThai = N'Sẵn sàng thanh lý'
    WHERE TaiSanID IN (
        SELECT TaiSanID FROM ChiTietHopDong CT
        JOIN HopDong HD ON CT.HopDongID = HD.HopDongID
        WHERE GETDATE() > HD.Deadline2
    )
END

UPDATE HopDong
SET Deadline2 = '2026-05-01'
WHERE HopDongID = 1
SELECT * FROM TaiSan

CREATE TRIGGER trg_BanTaiSan
ON HopDong
AFTER UPDATE
AS
BEGIN
    UPDATE TaiSan
    SET TrangThai = N'Đã bán'
    WHERE TaiSanID IN (
        SELECT TaiSanID FROM ChiTietHopDong
        WHERE HopDongID IN (
            SELECT HopDongID FROM inserted WHERE TrangThai = N'Đã thanh lý'
        )
    )
END
UPDATE HopDong
SET TrangThai = N'Đã thanh lý'
WHERE HopDongID = 1
SELECT TrangThai FROM TaiSan
CREATE PROCEDURE sp_GiaHan
    @HopDongID INT,
    @SoNgayThem INT
AS
BEGIN
    UPDATE HopDong
    SET Deadline1 = DATEADD(DAY, @SoNgayThem, Deadline1),
        Deadline2 = DATEADD(DAY, @SoNgayThem, Deadline2)
    WHERE HopDongID = @HopDongID
END